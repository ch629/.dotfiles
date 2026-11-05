require 'yaml'

root = File.expand_path('..', __dir__)
agents = File.join(root, 'agents')
reviewer = 'go-financial-code-reviewer-betika'
retired = "#{reviewer}-premium"
raise 'Premium reviewer still exists' if File.exist?(File.join(agents, "#{retired}.md"))

Dir.glob(File.join(agents, '*.md')).each do |path|
  raise "Stale premium reviewer reference: #{path}" if File.read(path).include?(retired)
end

developer = File.read(File.join(agents, 'developer-betika.md'))
config = YAML.safe_load(developer.split('---', 3)[1])
tasks = config.fetch('permission').fetch('task')
raise 'Default delegation denial missing' unless tasks['*'] == 'deny'
raise 'Single code reviewer not allowed' unless tasks[reviewer] == 'allow'
raise 'Multiple code reviewer routes' unless tasks.keys.grep(/code-reviewer/) == [reviewer]

[
  'payments, settlement, ledger posting, reconciliation, rounding/precision, idempotency, or monetary calculations',
  'schema/migration/query behavior that can affect financial balances or posting correctness',
  'Financial correctness, Functional correctness, `GoogleStyle`, and `100go`',
  'low confidence, unresolved ambiguity, or conflicting findings',
  'block sign-off',
  "Run `#{reviewer}` before sign-off",
  'Follow the same engineering, testing, governance, and reporting standards'
].each { |rule| raise "Missing review gate: #{rule}" unless developer.include?(rule) }

text = File.read(File.join(agents, "#{reviewer}.md"))
config = YAML.safe_load(text.split('---', 3)[1])
raise 'Reviewer model changed' unless config['model'] == 'gateframe/gateframe/qwen3.6-plus'
raise 'Reviewer must remain a subagent' unless config['mode'] == 'subagent'
raise 'Reviewer must remain read-only' unless config.fetch('permission')['edit'] == 'deny'
raise 'Shared review contract missing' unless text.include?('exact same behavior and output contract as `go-financial-code-reviewer`')
puts 'Betika reviewer checks passed (single route, financial gates, shared contract).'
