# Static routing checks; no external services or model calls.
require 'yaml'
require 'json'

root = File.expand_path('..', __dir__)
agents = Dir.glob(File.join(root, 'agents/*.md')).to_h do |path|
  [File.basename(path, '.md'), YAML.safe_load(File.read(path).split(/^---\s*$\n?/, 3)[1])]
end
%w[agents commands policies playbooks skills].each do |directory|
  Dir.glob(File.join(root, directory, '**/*.md')).each do |path|
    raise "Obsolete ticket integration: #{path}" if File.read(path).match?(/jira/i) || path.match?(/jira/i)
  end
end
agents.each do |name, config|
  tasks = config.fetch('permission', {}).fetch('task', {})
  next unless tasks.is_a?(Hash)
  tasks.each do |target, action|
    next unless action == 'allow' && !target.include?('*')
    raise "Missing task target #{target} in #{name}" unless agents.key?(target) || %w[general explore].include?(target)
  end
end
%w[linear-ticket-researcher linear-ticket-validator linear-parallel-work-orchestrator].each do |name|
  betika = "#{name}-betika"
  config = agents.fetch(betika)
  raise "Wrong provider: #{betika}" unless config.fetch('model') == 'gateframe/gateframe/qwen3.6-plus'
  raise "Writable wrapper: #{betika}" unless config.fetch('permission').fetch('edit') == 'deny'
  body = File.read(File.join(root, 'agents', "#{betika}.md"))
  raise "Missing shared contract: #{betika}" unless body.include?("~/.config/opencode/agents/#{name}.md")
  raise "Missing work route: #{betika}" unless agents.fetch('developer-betika').fetch('permission').fetch('task')[betika] == 'allow'
end
%w[parallel-linear-plan parallel-linear-plan-betika].each do |name|
  config = YAML.safe_load(File.read(File.join(root, 'commands', "#{name}.md")).split(/^---\s*$\n?/, 3)[1])
  expected = name.end_with?('-betika') ? 'linear-parallel-work-orchestrator-betika' : 'linear-parallel-work-orchestrator'
  raise "Wrong command route: #{name}" unless config.fetch('agent') == expected
end
JSON.parse(File.read(File.join(root, 'evals/cases.json'))).each do |test|
  %w[agent invoke_subagent].each do |field|
    raise "Missing eval agent: #{test[field]}" if test[field] && !agents.key?(test[field])
  end
end
confluence = File.read(File.join(root, 'skills/betika-cloudsql-access/SKILL.md'))
raise 'Confluence reference missing' unless confluence.include?('acli confluence page view')
puts 'Linear migration checks passed (routes, Gateframe, commands, evals, Confluence reference).'
