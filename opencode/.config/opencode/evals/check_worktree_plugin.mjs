// Run with Bun and the extracted v0.7.0 release's dist/index.js as argument.
// Exercises the real plugin and Git; mocked event transport is not a live TUI test.
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtemp, mkdir, writeFile, rm, access, realpath } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

assert(process.argv[2], 'Pass the extracted release dist/index.js');
const sandbox = await realpath(await mkdtemp(join(tmpdir(), 'opencode-worktree-check-')));
const originalStateHome = process.env.XDG_STATE_HOME;
process.env.XDG_STATE_HOME = join(sandbox, 'state');
const repo = join(sandbox, 'repo');
const git = (...args) => execFileSync('git', args, { cwd: repo, encoding: 'utf8' }).trim();
const replies = [];
const client = {
  app: { log: async () => ({}) },
  postSessionIdPermissionsPermissionId: async input => { replies.push(input); return {}; },
  session: new Proxy({}, { get() { throw new Error('Must not fork or launch a session'); } }),
};
try {
  await mkdir(repo);
  git('init', '-b', 'main');
  await writeFile(join(repo, 'seed'), 'test\n');
  git('add', 'seed');
  git('-c', 'user.name=Plugin Check', '-c', 'user.email=check@example.invalid', 'commit', '-m', 'seed');
  const { default: plugin } = await import(pathToFileURL(resolve(process.argv[2])).href);
  const hooks = await plugin.server({ client, directory: repo }, { permissionMode: 'pedantic' });
  const config = { permission: { external_directory: { '*': 'ask' } } };
  await hooks.config(config);
  assert.deepEqual(config.permission.external_directory, { '*': 'ask' }, 'No static broad allow');
  const args = { repo_short: 'trial', source_branch: 'mq-999-test', target_branch: 'main' };
  const context = { directory: repo, worktree: repo, sessionID: 'parent', metadata() {}, ask() { throw new Error('Unexpected setup approval'); } };
  const created = await hooks.tool.worktree_create.execute(args, context);
  assert.match(created.output, /Worktree created successfully/);
  const tree = git('worktree', 'list', '--porcelain').split('\n').find(line => line.startsWith('worktree ') && line !== `worktree ${repo}`).slice(9);
  assert.equal(git('branch', '--show-current'), 'main', 'Original workspace must not switch');
  const request = async (sessionID, patterns, permission = 'external_directory') => {
    const before = replies.length;
    await hooks.event({ event: { type: 'permission.asked', properties: { id: `request-${before}`, sessionID, permission, patterns, always: [] } } });
    return replies.slice(before);
  };
  for (const session of ['parent', 'delegated-worker']) {
    const result = await request(session, [`${tree}/*`]);
    assert.equal(result.length, 1);
    assert.equal(result[0].path.id, session);
    assert.equal(result[0].body.response, 'once');
  }
  assert.equal((await request('parent', [`${tree}-sibling/*`])).length, 0);
  assert.equal((await request('parent', [`${tree}/*`, `${repo}/*`])).length, 0);
  assert.equal((await request('parent', [`${tree}/*`], 'bash')).length, 0);
  await writeFile(join(tree, 'uncommitted'), 'must survive\n');
  await hooks.tool.worktree_remove.execute(args, context);
  await access(join(tree, 'uncommitted')); // Dirty removal must refuse.
  await rm(join(tree, 'uncommitted'));
  const removed = await hooks.tool.worktree_remove.execute(args, context);
  assert.match(removed.output, /Worktree removed successfully/);
  assert.equal(git('show-ref', '--verify', '--hash', 'refs/heads/mq-999-test').length, 40, 'Preserve PR branch');
  assert.equal((await request('parent', [`${tree}/*`])).length, 0);
  console.log('Worktree plugin checks passed (Git lifecycle, parent/worker events, scoped approvals, dirty refusal, branch retention).');
} finally {
  if (originalStateHome === undefined) delete process.env.XDG_STATE_HOME;
  else process.env.XDG_STATE_HOME = originalStateHome;
  await rm(sandbox, { recursive: true, force: true });
}
