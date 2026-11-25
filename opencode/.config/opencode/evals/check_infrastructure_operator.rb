# Static contract check; not a runtime approval or sandbox test.
require 'yaml'
require 'json'

root = File.expand_path('..', __dir__)
text = File.read(File.join(root, 'agents/infrastructure-operator.md'))
agent = YAML.safe_load(text.split('---', 3)[1])
permission = agent.fetch('permission')
{
  'autonomous preparation' => ['safe authorized read-only investigation', 'finish independent preparation', 'never make speculative operations or infrastructure changes', 'Default reasonable non-consequential choices', 'Do not ask for routine feedback or confirmations for approved steps'],
  'batched decisions' => ['batch related missing information, check waivers and approval of the disclosed exact operation', 'distinguishing each decision and its exact content', 'Never infer a waiver or treat a generic yes as approval of undisclosed content'],
  'bounded progress' => ['multiple bounded steps and checks', 'do not seek repeated approval while their verified preconditions hold', 'Ask immediately when uncertainty or authority prevents safe progress', 'never delay mandatory pre-mutation approval', 'does not bypass per-tool approvals, identity, secrets, destructive boundaries or stop conditions'],
  'planning initiative' => ['Never ask permission merely to plan', 'proactively propose ideas and options without treating them as authorization to act'],
  'concrete preparation' => ['draft the concrete command sequence and inputs', 'compute the operation plan digest itself', 'validate safely where possible', 'do not execute consequential mutations merely to validate the plan', 'Present the prepared proposal and seek required approval', 'report the specific actual blocker only after exhausting safe independent steps'],
  'diagnosed retry' => ['Automatically retry a specific failed step only after diagnosing the failure', 'verifying that it had no effect', 'target, effects, scope and preconditions are unchanged', 'original authorization remains valid', 'count retries within the two scoped fix-and-recheck cycles', 'Do not repeatedly ask for approval when those conditions hold', 'Never retry a mutation after partial or unknown state', 'or bypass a permission denial', 'stop on uncertain state, changed effects or scope'],
  'denied access' => ['stop the affected work and ask', 'Continue only safe, independent authorized work unrelated to the denial, and report the blocker', 'never use shell or indirect access to work around a denial']
}.each do |scenario, rules|
  rules.each { |rule| raise "Missing #{scenario} contract: #{rule}" unless text.include?(rule) }
end
raise 'Not a primary' unless agent['mode'] == 'primary'
reviewers = %w[code-reviewer code-reviewer-lite security-scanner infra-reviewer db-reviewer migration-reviewer]
expected_tasks = { '*' => 'deny' }.merge(reviewers.each_with_object({}) { |name, allowed| allowed[name] = 'allow' })
raise 'Reviewer allowlist or ordering changed' unless permission['task'].to_a == expected_tasks.to_a
reviewers.each do |name|
  reviewer = YAML.safe_load(File.read(File.join(root, 'agents', "#{name}.md")).split('---', 3)[1])
  raise "#{name} is not a read-only subagent" unless reviewer['mode'] == 'subagent' && reviewer.fetch('permission')['edit'] == 'deny'
end
[
  'never delegate operations', 'selecting expertise and review depth appropriate to the risk',
  'only for trivial low-risk diffs', 'sanitized scoped evidence and provenance',
  'never share secrets, credentials, sensitive state or saved plan contents',
  'not to execute validation, providers, scripts or infrastructure commands',
  'mutate files, infrastructure or remote state', 'No operational authority transfers',
  'must not approve an operation on the user\'s behalf',
  'reviewer verdict does not replace explicit user approval',
  'Do not make optional reviews mandatory', 'under its own contract'
].each { |rule| raise "Missing reviewer boundary: #{rule}" unless text.include?(rule) }
raise 'Agent must inherit shell and directory restrictions' if permission.key?('bash') || permission.key?('external_directory') || permission.key?('edit')
global = JSON.parse(File.read(File.join(root, 'opencode.json')))
raise 'Global merge denial changed' unless global.fetch('permission')['worktree_merge'] == 'deny'
[
  'explicit user approval of that exact plan and artifact digest',
  'tool permission prompts are not user approval', 'resource-level destructive boundaries',
  'Verify identity and target', 'saved plan', '-detailed-exitcode',
  'reverify identity, target, source tree, artifact digest',
  'invalidates approval', 'generate a new preview', 'never silently regenerate',
  'Never retry a mutation blindly', 'At most two scoped fix-and-recheck cycles',
  'Rollback is a mutation', 'fresh explicit content-bound approval',
  'not a sandbox', 'Never disclose credentials'
].each { |rule| raise "Missing operation boundary: #{rule}" unless text.include?(rule) }
{
  'approved destructive step' => ['An explicitly approved destructive step may proceed only within its approved boundaries and verified preconditions'],
  'out-of-bound destructive action' => ['destructive action outside approved boundaries requires a new plan and fresh explicit content-bound approval'],
  'expected state transition' => ['state transitions actually verified from earlier approved steps are expected, not drift', 'next approved artifact and its preconditions remain valid'],
  'unexpected drift' => ['Unexpected state, unverifiable transitions or invalidated artifact preconditions require stopping and replanning with fresh approval'],
  'rollback' => ['its exact action, trigger, effects and destructive boundaries were included in the approved plan and still match reality', 'Otherwise stop, assess current state, replan and seek fresh approval'],
  'bounded diagnosis' => ['limited to safe, non-destructive actions within the approved target, effects and boundaries', 'At most two scoped fix-and-recheck cycles', 'stop on uncertainty or repeated failure']
}.each do |scenario, rules|
  rules.each { |rule| raise "Missing #{scenario} contract: #{rule}" unless text.include?(rule) }
end
{
  'saved Terraform path' => ['For Terraform, produce a saved plan', 'inspect its complete change summary including adds, updates, deletes and replacements', 'For an artifact-based operation, request explicit user approval of that exact plan and artifact digest', 'Use the exact approved saved artifact and command'],
  'non-artifact approval' => ['disclose why an artifact cannot be used', 'explicit approval bound to the exact disclosed commands, inputs, target, intended impact and destructive limits', 'including recovery actions and triggers'],
  'non-artifact safety' => ['safe target-specific checks and available observability', 'a separate testing environment is not mandatory', 'does not waive the controlled execution environment', 'essential evidence, effects, destructive scope or side effects cannot be verified', 'recheck the baseline, exact commands and inputs, and changed conditions', 'invalidated command preconditions'],
  'narrow waiver' => ['nonessential safety check not mandated by the shared playbook', 'exact check and target', 'potential data loss or corruption', 'concrete alternatives', 'explicit informed user waiver naming that check and target', 'a user attestation is not proof', 'waiver is separate from', 'mounting may proceed without a fresh filesystem consistency check', 'choose read-only where requested or appropriate', 'do not repair, format', 'Never waive target identity, authority, explicit mutation approval, tool denials', 'unknown command effects', 'required shared validation check cannot be performed, stop and report Blocked', 'identify waived checks as skipped, not passed'],
  'isolated exception' => ['does not change the deployment owner/CI saved-plan requirements or authority of other agents', 'not a sandbox or an independent approval enforcement mechanism']
}.each do |scenario, rules|
  rules.each { |rule| raise "Missing #{scenario} contract: #{rule}" unless text.include?(rule) }
end
[
  'explicitly authorized supported credential provider or tool-managed credential store',
  'user-provided authenticated session', 'authorized non-disclosing channel',
  'without requiring an artificial denial', 'environment variables are not inherently secret',
  'argv, shell tracing, URLs, history, diagnostics and insecure temporary files',
  'never use shell or indirect access to work around a denial',
  'request exact permission or user-operated supported authentication',
  'stop and report the exposure and need for credential rotation'
].each { |rule| raise "Missing credential boundary: #{rule}" unless text.include?(rule) }
policy = File.read(File.join(root, 'playbooks/infrastructure.md'))
{
  'command-only provenance' => ['base/head are N/A only for genuinely command-only operations with no relevant source revision', 'verified baseline', 'tool versions, exact commands and inputs', 'every consequential/live operation report the operation plan digest', 'artifact digest only where applicable'],
  'known no-effect failure' => ['verifying that it had no effect', 'target, effects, scope and preconditions are unchanged', 'original authorization remains valid', 'count retries within the two scoped fix-and-recheck cycles'],
  'timeout with unknown state' => ['timeout, lost lock', 'means stop mutations', 'Safe authorized read-only diagnosis may continue', 'Never retry a mutation after partial or unknown state', 'replan and obtain fresh approval when required']
}.each do |scenario, rules|
  rules.each { |rule| raise "Missing #{scenario} contract: #{rule}" unless text.include?(rule) }
end
raise 'Shared command-only provenance missing' unless policy.include?('base/head are N/A only for genuinely command-only operations with no relevant source revision')
raise 'Shared operation plan digest missing' unless policy.include?('consequential/live operation report the operation plan digest')
review_section = text.split('## Reviewer delegation', 2).last.split('## Plan and approval', 2).first
raise 'General credential policy belongs outside reviewer delegation' if review_section.include?('For authenticated operations')
raise 'Shared no-apply policy missing' unless policy.include?('Never apply,')
raise 'Exception must be isolated' unless policy.include?('this exception does not') && policy.include?('transfer to other agents')
{
  'lab authority' => ['sufficiently explicit bounded scope', 'create, test, reset and cleanup', 'no repeated exact plan or digest approval', 'ask for missing scope or authority'],
  'lab isolation' => ['exact target and ownership', 'local client', 'live credentials', 'valuable data', 'shared consumers', 'public exposure', 'host-sensitive mounts', 'uncontrolled effects'],
  'lab execution' => ['before potentially destructive effects', 'recheck on material context changes', 'stop and escalate', 'minimal suitable checks', 'experiment results are not deployment authorization or PR readiness'],
  'live path' => ['consequential/live path', 'content-bound operation approval']
}.each do |scenario, rules|
  rules.each { |rule| raise "Missing #{scenario} contract: #{rule}" unless text.include?(rule) }
end
raise 'Shared lab exception missing' unless policy.include?('verified isolated disposable lab') && policy.include?('consequential/live path')
raise 'Lab verification exception missing' unless policy.include?('minimal suitable verification and reporting instead of the plan,') && policy.include?("does not alter other agents' requirements")
puts 'Infrastructure operator static contract checks passed.'
