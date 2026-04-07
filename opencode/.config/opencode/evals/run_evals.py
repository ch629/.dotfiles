#!/usr/bin/env python3
import argparse
import atexit
import concurrent.futures
import json
import os
import re
import shlex
import socket
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Run OpenCode agent regression evals")
    p.add_argument(
        "--cases",
        default="opencode/.config/opencode/evals/cases.json",
        help="Path to eval cases JSON",
    )
    p.add_argument(
        "--out-dir",
        default="opencode/.config/opencode/evals/results",
        help="Directory for reports",
    )
    p.add_argument(
        "--baseline",
        default="opencode/.config/opencode/evals/results/baseline.json",
        help="Baseline summary JSON path",
    )
    p.add_argument(
        "--workspace",
        default=".",
        help="Workspace dir used by `opencode run --dir`",
    )
    p.add_argument(
        "--agent",
        default="developer-primary",
        help="Default primary agent name",
    )
    p.add_argument(
        "--suite",
        choices=["offline", "live", "all"],
        default="offline",
        help="Which suite to run",
    )
    p.add_argument(
        "--only",
        default="",
        help=(
            "Comma-separated case id filters (regex). "
            "Example: --only go-review,validator-evidence-matrix"
        ),
    )
    p.add_argument(
        "--jobs",
        type=int,
        default=1,
        help="Number of cases to run in parallel (default: 1)",
    )
    p.add_argument(
        "--timeout",
        type=int,
        default=90,
        help="Per-case timeout in seconds",
    )
    p.add_argument(
        "--set-baseline",
        action="store_true",
        help="Write this run as baseline",
    )
    p.add_argument(
        "--compare-baseline",
        action="store_true",
        help="Compare this run against baseline",
    )
    p.add_argument(
        "--attach",
        default="",
        help="Attach URL for an already running OpenCode server (e.g. http://127.0.0.1:4096)",
    )
    p.add_argument(
        "--no-auto-serve",
        action="store_true",
        help="Disable auto-starting a temporary OpenCode server when --attach is not set",
    )
    return p.parse_args()


def load_cases(path: Path):
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError("cases.json must contain a list")
    return data


def filter_cases(cases, suite: str):
    if suite == "all":
        return cases
    return [c for c in cases if c.get("suite", "offline") == suite]


def filter_cases_by_id(cases, only: str):
    if not only.strip():
        return cases
    patterns = [p.strip() for p in only.split(",") if p.strip()]
    return [
        c
        for c in cases
        if any(re.search(pat, c.get("id", ""), flags=re.IGNORECASE) for pat in patterns)
    ]


def score_output(text: str, case: dict):
    must_include = case.get("must_include", [])
    should_include = case.get("should_include", [])
    must_not_include = case.get("must_not_include", [])

    missing = [
        pat for pat in must_include if re.search(pat, text, flags=re.IGNORECASE) is None
    ]
    missing_should = [
        pat
        for pat in should_include
        if re.search(pat, text, flags=re.IGNORECASE) is None
    ]
    forbidden_hits = [
        pat
        for pat in must_not_include
        if re.search(pat, text, flags=re.IGNORECASE) is not None
    ]

    score = 0
    score += 2 * (len(must_include) - len(missing))
    score += 1 * (len(should_include) - len(missing_should))
    score -= 2 * len(forbidden_hits)

    passed = not missing and not forbidden_hits
    return {
        "passed": passed,
        "score": score,
        "missing": missing,
        "missing_should": missing_should,
        "forbidden_hits": forbidden_hits,
    }


def _print_progress(msg: str):
    print(msg, flush=True)


def run_case(case: dict, args: argparse.Namespace, attach_url: str):
    prompt = case["prompt"].strip()
    subagent = case.get("invoke_subagent")
    if subagent:
        prompt = f"@{subagent} {prompt}"

    target_agent = case.get("agent") or args.agent
    cmd = [
        "opencode",
        "run",
        "--attach",
        attach_url,
        "--agent",
        target_agent,
        "--dir",
        args.workspace,
        "--format",
        "default",
        prompt,
    ]

    case_timeout = int(case.get("timeout", args.timeout))
    started = datetime.now(timezone.utc)
    _print_progress(f"[start] {case['id']} ({target_agent})")
    try:
        proc = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        start_ts = time.time()
        last_tick = -1
        while True:
            rc = proc.poll()
            elapsed = int(time.time() - start_ts)
            if rc is not None:
                break
            if elapsed // 5 != last_tick:
                last_tick = elapsed // 5
                _print_progress(
                    f"[tick] {case['id']} running {elapsed}s/{case_timeout}s"
                )
            if elapsed >= case_timeout:
                proc.kill()
                out, err = proc.communicate()
                _print_progress(f"[timeout] {case['id']} after {elapsed}s")
                stdout = out or ""
                stderr = (err or "") + "\ntimeout"
                ok = False
                error = "timeout"
                break
            time.sleep(0.2)
        else:
            pass

        if "ok" not in locals():
            out, err = proc.communicate()
            stdout = out or ""
            stderr = err or ""
            ok = proc.returncode == 0
            error = "" if ok else f"exit_code={proc.returncode}"

        if ok:
            _print_progress(f"[done] {case['id']} ok")
        else:
            _print_progress(f"[fail] {case['id']} {error}")
    except Exception as ex:  # broad on purpose for eval robustness
        stdout = ""
        stderr = str(ex)
        ok = False
        error = "runner_exception"
        _print_progress(f"[error] {case['id']} runner_exception")

    ended = datetime.now(timezone.utc)
    scoring = (
        score_output(stdout, case)
        if ok
        else {
            "passed": False,
            "score": -10,
            "missing": case.get("must_include", []),
            "missing_should": case.get("should_include", []),
            "forbidden_hits": [],
        }
    )

    return {
        "id": case["id"],
        "suite": case.get("suite", "offline"),
        "agent": target_agent,
        "invoke_subagent": subagent,
        "command": " ".join(shlex.quote(x) for x in cmd),
        "started_at": started.isoformat(),
        "ended_at": ended.isoformat(),
        "ok": ok,
        "error": error,
        "stdout": stdout,
        "stderr": stderr,
        **scoring,
    }


def summarize(results):
    total = len(results)
    passed = sum(1 for r in results if r["passed"])
    score = sum(r["score"] for r in results)
    return {
        "total": total,
        "passed": passed,
        "failed": total - passed,
        "score": score,
    }


def write_reports(out_dir: Path, payload: dict):
    out_dir.mkdir(parents=True, exist_ok=True)
    summary_json = out_dir / "summary.json"
    summary_md = out_dir / "summary.md"

    summary_json.write_text(json.dumps(payload, indent=2), encoding="utf-8")

    lines = []
    lines.append("# Agent Eval Summary")
    lines.append("")
    lines.append(f"- Timestamp: {payload['timestamp']}")
    lines.append(f"- Total: {payload['summary']['total']}")
    lines.append(f"- Passed: {payload['summary']['passed']}")
    lines.append(f"- Failed: {payload['summary']['failed']}")
    lines.append(f"- Score: {payload['summary']['score']}")
    if payload.get("baseline_comparison"):
        c = payload["baseline_comparison"]
        lines.append(f"- Baseline delta score: {c['delta_score']}")
        lines.append(f"- Baseline delta passed: {c['delta_passed']}")
    lines.append("")
    lines.append("## Cases")
    lines.append("")
    for r in payload["results"]:
        status = "PASS" if r["passed"] else "FAIL"
        lines.append(f"- {r['id']}: {status} (score={r['score']}, ok={r['ok']})")
        if r["missing"]:
            lines.append(f"  - missing: {', '.join(r['missing'])}")
        if r["forbidden_hits"]:
            lines.append(f"  - forbidden: {', '.join(r['forbidden_hits'])}")
        if not r["ok"] and r["error"]:
            lines.append(f"  - error: {r['error']}")

    summary_md.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return summary_json, summary_md


def compare_to_baseline(summary: dict, baseline_path: Path):
    if not baseline_path.exists():
        return None
    base = json.loads(baseline_path.read_text(encoding="utf-8"))
    return {
        "baseline_score": base["summary"]["score"],
        "baseline_passed": base["summary"]["passed"],
        "delta_score": summary["score"] - base["summary"]["score"],
        "delta_passed": summary["passed"] - base["summary"]["passed"],
    }


def _find_free_port() -> int:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind(("127.0.0.1", 0))
    port = sock.getsockname()[1]
    sock.close()
    return port


def _server_ready(url: str, workspace: str) -> bool:
    try:
        test = subprocess.run(
            [
                "opencode",
                "run",
                "--attach",
                url,
                "--agent",
                "build",
                "--dir",
                workspace,
                "ping",
            ],
            capture_output=True,
            text=True,
            timeout=20,
            check=False,
        )
        return test.returncode == 0
    except Exception:
        return False


def find_existing_server(workspace: str) -> str:
    candidates = []
    env_url = os.getenv("OPENCODE_ATTACH") or os.getenv("OPENCODE_SERVER_URL")
    if env_url:
        candidates.append(env_url)
    candidates.extend(["http://127.0.0.1:4096", "http://localhost:4096"])

    for url in candidates:
        if _server_ready(url, workspace):
            return url
    return ""


def start_temp_server(workspace: str) -> tuple[str, subprocess.Popen]:
    port = _find_free_port()
    url = f"http://127.0.0.1:{port}"
    cmd = ["opencode", "serve", "--hostname", "127.0.0.1", "--port", str(port)]
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    deadline = time.time() + 15
    ready = False
    while time.time() < deadline:
        if proc.poll() is not None:
            break
        if _server_ready(url, workspace):
            ready = True
            break
        time.sleep(0.5)

    if not ready:
        out, err = proc.communicate(timeout=2)
        raise RuntimeError(
            "failed to start temporary opencode server"
            + f"\nstdout: {out[:500]}\nstderr: {err[:500]}"
        )

    return url, proc


def main() -> int:
    args = parse_args()
    root = Path.cwd()
    cases_path = (root / args.cases).resolve()
    out_dir = (root / args.out_dir).resolve()
    baseline_path = (root / args.baseline).resolve()

    cases = load_cases(cases_path)
    selected = filter_cases(cases, args.suite)
    selected = filter_cases_by_id(selected, args.only)
    if not selected:
        print("No cases selected", file=sys.stderr)
        return 2
    if args.jobs < 1:
        print("--jobs must be >= 1", file=sys.stderr)
        return 2

    server_proc = None
    attach_url = args.attach
    if not attach_url:
        attach_url = find_existing_server(args.workspace)
        if attach_url:
            print(f"Reusing existing OpenCode server: {attach_url}", flush=True)
        else:
            if args.no_auto_serve:
                print(
                    "No --attach provided, no reusable server found, and --no-auto-serve enabled.",
                    file=sys.stderr,
                )
                return 2
            print("Starting temporary OpenCode server...", flush=True)
            attach_url, server_proc = start_temp_server(args.workspace)
            print(f"Using temporary server: {attach_url}", flush=True)

        def _cleanup_server():
            if server_proc and server_proc.poll() is None:
                server_proc.terminate()
                try:
                    server_proc.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    server_proc.kill()

        atexit.register(_cleanup_server)

    if args.jobs == 1:
        results = [run_case(case, args, attach_url) for case in selected]
    else:
        results = [None] * len(selected)
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as ex:
            future_to_idx = {
                ex.submit(run_case, case, args, attach_url): idx
                for idx, case in enumerate(selected)
            }
            for future in concurrent.futures.as_completed(future_to_idx):
                idx = future_to_idx[future]
                results[idx] = future.result()
    summary = summarize(results)

    payload = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "args": vars(args),
        "summary": summary,
        "results": results,
    }

    if args.compare_baseline:
        payload["baseline_comparison"] = compare_to_baseline(summary, baseline_path)

    summary_json, summary_md = write_reports(out_dir, payload)

    if args.set_baseline:
        baseline_path.parent.mkdir(parents=True, exist_ok=True)
        baseline_path.write_text(
            summary_json.read_text(encoding="utf-8"), encoding="utf-8"
        )

    print(f"Wrote: {summary_json}")
    print(f"Wrote: {summary_md}")
    if args.set_baseline:
        print(f"Baseline updated: {baseline_path}")

    if server_proc and server_proc.poll() is None:
        server_proc.terminate()
        try:
            server_proc.wait(timeout=3)
        except subprocess.TimeoutExpired:
            server_proc.kill()

    return 0 if summary["failed"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
