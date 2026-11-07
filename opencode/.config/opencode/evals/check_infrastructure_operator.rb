# Static contract check; not a runtime approval or sandbox test.
require 'yaml'
require 'json'

root = File.expand_path('..', __dir__)
text = File.read(File.join(root, 'agents/infrastructure-operator.md'))
agent = YAML.safe_load(text.split('---', 3)[1])
permission = agent.fetch('permission')
raise 'Not a primary' unless agent['mode'] == 'primary'
raise 'Delegation enabled' unless permission['task'] == 'deny'
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
policy = File.read(File.join(root, 'playbooks/infrastructure.md'))
raise 'Shared no-apply policy missing' unless policy.include?('Never apply,')
raise 'Exception must be isolated' unless policy.include?('this exception does not') && policy.include?('transfer to other agents')
puts 'Infrastructure operator static contract checks passed.'
