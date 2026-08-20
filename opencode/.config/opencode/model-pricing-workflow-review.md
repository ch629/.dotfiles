# Ticket workflow model pricing review

Source: OpenRouter model API, fetched 2026-06-19. Prices are USD per 1M tokens and can change by router/provider.

## Current baseline

| Model id | Model | Context | Input / 1M | Output / 1M |
|---|---:|---:|---:|---:|
| `anthropic/claude-sonnet-4.6` | Claude Sonnet 4.6 | 1,000,000 | $3.00 | $15.00 |
| `anthropic/claude-haiku-4.5` | Claude Haiku 4.5 | 200,000 | $1.00 | $5.00 |
| `anthropic/claude-opus-4.8` | Claude Opus 4.8 | 1,000,000 | $5.00 | $25.00 |
| `x-ai/grok-4.3` | Grok 4.3 | 1,000,000 | $1.25 | $2.50 |
| `mistralai/codestral-2508` | Codestral 2508 | 256,000 | $0.30 | $0.90 |
| `deepseek/deepseek-r1-0528` | DeepSeek R1 0528 | 163,840 | $0.50 | $2.15 |

## Chinese/value candidates

| Model id | Model | Context | Input / 1M | Output / 1M | Best fit |
|---|---:|---:|---:|---:|---|
| `qwen/qwen3.7-plus` | Qwen3.7 Plus | 1,000,000 | $0.32 | $1.28 | Research, planning, lite review, PR text |
| `qwen/qwen3.7-max` | Qwen3.7 Max | 1,000,000 | $1.25 | $3.75 | Planner/reviewer fallback below Sonnet |
| `qwen/qwen3.6-flash` | Qwen3.6 Flash | 1,000,000 | $0.19 | $1.13 | Cheap summarization/completion |
| `qwen/qwen3-coder-plus` | Qwen3 Coder Plus | 1,000,000 | $0.65 | $3.25 | Feature dev, test writer |
| `qwen/qwen3-coder` | Qwen3 Coder 480B | 1,048,576 | $0.22 | $1.80 | Best-value feature dev candidate |
| `qwen/qwen3-coder-flash` | Qwen3 Coder Flash | 1,000,000 | $0.20 | $0.98 | Cheap tests/small fixes |
| `qwen/qwen3-coder-next` | Qwen3 Coder Next | 262,144 | $0.11 | $0.80 | Cheap coding where context fits |
| `qwen/qwen3-max` | Qwen3 Max | 262,144 | $0.78 | $3.90 | Standard planning/review |
| `qwen/qwen3-max-thinking` | Qwen3 Max Thinking | 262,144 | $0.78 | $3.90 | DB/security/migration reasoning |
| `qwen/qwen-plus` | Qwen Plus | 1,000,000 | $0.26 | $0.78 | Strong cheap default for low-risk agents |
| `moonshotai/kimi-k2.7-code` | Kimi K2.7 Code | 262,144 | $0.74 | $3.50 | Coding/research alternative |
| `moonshotai/kimi-k2.6` | Kimi K2.6 | 262,144 | $0.67 | $3.50 | Research and synthesis |
| `moonshotai/kimi-k2-thinking` | Kimi K2 Thinking | 262,144 | $0.60 | $2.50 | Reasoning-heavy review candidate |
| `moonshotai/kimi-k2` | Kimi K2 0711 | 131,072 | $0.57 | $2.30 | Older cheaper Kimi route |
| `deepseek/deepseek-v4-pro` | DeepSeek V4 Pro | 1,048,576 | $0.44 | $0.87 | High-value general/developer candidate |
| `deepseek/deepseek-v4-flash` | DeepSeek V4 Flash | 1,048,576 | $0.09 | $0.18 | Very cheap low-risk agents |
| `deepseek/deepseek-v3.2` | DeepSeek V3.2 | 131,072 | $0.23 | $0.34 | Cheap general coding/review |
| `deepseek/deepseek-chat` | DeepSeek V3 | 131,072 | $0.20 | $0.80 | Cheap dev/test/research |
| `deepseek/deepseek-r1` | DeepSeek R1 | 163,840 | $0.70 | $2.50 | Reasoning fallback |
| `z-ai/glm-5.2` | GLM 5.2 | 1,048,576 | $1.20 | $4.10 | Long-context planner/reviewer |
| `z-ai/glm-5.1` | GLM 5.1 | 202,752 | $0.98 | $3.08 | Standard planner/reviewer |
| `z-ai/glm-5` | GLM 5 | 202,752 | $0.60 | $1.92 | Good general replacement candidate |
| `z-ai/glm-4.7` | GLM 4.7 | 202,752 | $0.40 | $1.75 | Cheap review/research |
| `z-ai/glm-4.7-flash` | GLM 4.7 Flash | 202,752 | $0.06 | $0.40 | PR writer, completion, clarifier |
| `z-ai/glm-4.5` | GLM 4.5 | 131,072 | $0.60 | $2.20 | Older general fallback |
| `z-ai/glm-4.5-air` | GLM 4.5 Air | 131,072 | $0.13 | $0.85 | Lite review/summarization |

## Bigger flagship models

Use these as premium fallbacks or A/B baselines, not blanket defaults.

| Model id | Model | Context | Input / 1M | Output / 1M | Best fit |
|---|---:|---:|---:|---:|---|
| `openai/gpt-5.5-pro` | GPT-5.5 Pro | 1,050,000 | $30.00 | $180.00 | Expensive deep fallback only |
| `openai/gpt-5.5` | GPT-5.5 | 1,050,000 | $5.00 | $30.00 | Premium planner/reviewer A/B |
| `openai/gpt-5.4` | GPT-5.4 | 1,050,000 | $2.50 | $15.00 | Sonnet-price-class alternative |
| `openai/gpt-5.3-codex` | GPT-5.3 Codex | 400,000 | $1.75 | $14.00 | Coding baseline |
| `openai/gpt-5.1-codex` | GPT-5.1 Codex | 400,000 | $1.25 | $10.00 | Coding baseline/value premium |
| `openai/gpt-5` | GPT-5 | 400,000 | $1.25 | $10.00 | General premium alternative |
| `openai/o3` | o3 | 200,000 | $2.00 | $8.00 | Reasoning review/planning |
| `openai/o3-pro` | o3 Pro | 200,000 | $20.00 | $80.00 | Rare deep reasoning fallback |
| `google/gemini-3.1-pro-preview` | Gemini 3.1 Pro Preview | 1,048,576 | $2.00 | $12.00 | Long-context planner/reviewer A/B |
| `google/gemini-3.5-flash` | Gemini 3.5 Flash | 1,048,576 | $1.50 | $9.00 | Long-context mid-premium utility |
| `google/gemini-2.5-pro` | Gemini 2.5 Pro | 1,048,576 | $1.25 | $10.00 | Long-context premium alternative |
| `x-ai/grok-4.20` | Grok 4.20 | 2,000,000 | $1.25 | $2.50 | Very long-context research |
| `x-ai/grok-4.20-multi-agent` | Grok 4.20 Multi-Agent | 2,000,000 | $1.25 | $2.50 | Research/orchestration experiment |
| `anthropic/claude-opus-4.8` | Claude Opus 4.8 | 1,000,000 | $5.00 | $25.00 | Premium final review/fallback |
| `anthropic/claude-opus-4.8-fast` | Claude Opus 4.8 Fast | 1,000,000 | $10.00 | $50.00 | Only if latency matters more than cost |
| `anthropic/claude-sonnet-4.6` | Claude Sonnet 4.6 | 1,000,000 | $3.00 | $15.00 | Current flagship default |

## Recommended swaps to test first

| Agent | Current | First value test | Safer fallback | Why |
|---|---|---|---|---|
| `pr-description-writer` | Haiku 4.5 | `z-ai/glm-4.7-flash` | `qwen/qwen-plus` | Pure summarization; biggest no-brainer cost cut. |
| `completion-reviewer` | Haiku 4.5 | `qwen/qwen-plus` | `z-ai/glm-4.5-air` | Needs checklist discipline, not premium reasoning. |
| `code-reviewer-lite` | Haiku 4.5 | `qwen/qwen-plus` | `z-ai/glm-4.5-air` | Low-risk review pass only. |
| `ticket-clarifier` | Haiku 4.5 | `deepseek/deepseek-v4-flash` | `qwen/qwen-plus` | Cheap questioning/classification. |
| `ticket-researcher` | Grok 4.3 | `qwen/qwen3.7-plus` | `moonshotai/kimi-k2.6` | Needs long context + synthesis. |
| `test-writer` | Codestral | `qwen/qwen3-coder-flash` | `qwen/qwen3-coder` | Similar cost target, better workflow fit if evals pass. |
| `feature-developer` | DeepSeek R1 0528 | `qwen/qwen3-coder` | `deepseek/deepseek-v4-pro` | Main cost/value battle; keep R1/Sonnet fallback for hard reasoning. |
| `db-reviewer` | DeepSeek R1 0528 | `qwen/qwen3-max-thinking` | `deepseek/deepseek-r1` | Reasoning matters; do not use flash/air. |
| `migration-reviewer` | Haiku 4.5 | `qwen/qwen3-max-thinking` | `z-ai/glm-5` | Higher-risk than current cheap model suggests. |
| `security-scanner` | Haiku 4.5 | `qwen/qwen3-max-thinking` | `moonshotai/kimi-k2-thinking` | Security needs reasoning; avoid flash routes. |
| `implementation-planner` | Sonnet 4.6 | `qwen/qwen3.7-max` | `z-ai/glm-5.2` | Try only on standard tickets first. |
| `code-reviewer` | Sonnet 4.6 | `qwen/qwen3.7-max` | `z-ai/glm-5.2` | Good savings if it catches regressions in local evals. |
| `infra-reviewer` | Sonnet 4.6 | `qwen/qwen3.7-max` | `z-ai/glm-5.2` | Keep Sonnet for auth/network/production-risk diffs. |
| `ticket-orchestrator` | Sonnet 4.6 | `qwen/qwen3.7-max` | keep Sonnet | Last thing to swap; tool routing failures are expensive. |

## Preferred mixed routing

Keep flagship models where a bad call poisons the whole workflow, then spend cheap tokens on execution/checklist work.

| Agent group | Preferred model tier | Suggested model |
|---|---|---|
| Orchestration | Flagship | `anthropic/claude-sonnet-4.6` |
| Implementation planning | Flagship | `anthropic/claude-sonnet-4.6` |
| Final/standard code review | Flagship by default | `anthropic/claude-sonnet-4.6` |
| High-risk infra/security/db review | Flagship or reasoning alternative | Sonnet, or A/B `qwen/qwen3-max-thinking` |
| Feature implementation | Value coder | A/B `qwen/qwen3-coder` vs current `deepseek/deepseek-r1-0528` |
| Test writing | Value coder | `qwen/qwen3-coder-flash` or Codestral if it wins evals |
| Ticket research | Value long-context | `qwen/qwen3.7-plus` |
| Clarifier/lite reviewer/completion/PR text | Cheap utility | `qwen/qwen-plus`, `z-ai/glm-4.7-flash`, or `deepseek/deepseek-v4-flash` |

Lazy default: keep `ticket-orchestrator`, `implementation-planner`, and `code-reviewer` on Sonnet; move the rest only where evals show no contract drift.

## Cost notes

- Haiku 4.5 is not that cheap here: $1 input / $5 output. GLM Flash, Qwen Plus, DeepSeek V4 Flash, and Qwen Coder Flash are materially cheaper.
- Qwen Plus is the best lazy default to test for low-risk text/checklist agents: 1M context, $0.26 input / $0.78 output.
- Qwen3 Coder 480B is the most interesting `feature-developer` challenger: 1M context, $0.22 input / $1.80 output.
- DeepSeek V4 Pro looks extremely strong on price if tool behavior is stable: 1M context, $0.44 input / $0.87 output.
- GLM 5.2 is cheaper than Sonnet, but not the cheapest Chinese option; use it where long-context quality beats raw price.

## Evaluation order

1. Swap only `pr-description-writer`, `completion-reviewer`, `code-reviewer-lite`, and `ticket-clarifier`; run local evals.
2. A/B `ticket-researcher`: `qwen/qwen3.7-plus` vs `moonshotai/kimi-k2.6`.
3. A/B `feature-developer`: current DeepSeek R1 0528 vs `qwen/qwen3-coder` vs `deepseek/deepseek-v4-pro`.
4. Test reasoning reviewers: `qwen/qwen3-max-thinking` for DB/security/migration.
5. Only after those pass, test `implementation-planner`, `code-reviewer`, and `ticket-orchestrator` against Sonnet.

## Keep premium models for

- Ticket orchestration until local evals prove tool routing is safe.
- High-risk finance/auth/security/concurrency work.
- Final review on standard/high-risk production diffs.
- Any model that gets cheaper but starts ignoring agent contracts.
