# Run: ruby opencode/.config/opencode/evals/check_reviewers.rb
# Static wiring/authority checks only; not a model-quality or runtime sandbox test.
require 'yaml'

root = File.expand_path('..', __dir__)
shared = '~/.config/opencode/playbooks/code-review.md'
prompt = '~/.config/opencode/prompts/code-review.md'
reviewers = Dir.glob(File.join(root, 'agents', '*reviewer*.md')) +
            [File.join(root, 'agents', 'security-scanner.md')]

reviewers.each do |path|
  text = File.read(path)
  config = YAML.safe_load(text.split('---', 3)[1])
  permissions = config.fetch('permission')
  raise "Invalid reviewer: #{path}" unless config['description'] && config['mode'] == 'subagent'
  raise "Reviewer can edit/delegate: #{path}" unless permissions['edit'] == 'deny' && permissions['task'] == 'deny'
  if File.basename(path).match?(/\Acode-reviewer(?:-lite)?\.md\z/)
    raise "Missing explicit shared prompt: #{path}" unless text.include?(prompt)
    text = File.read(File.join(root, 'prompts/code-review.md'))
  end
  raise "Missing review guidance: #{path}" unless text.include?(shared)
  permissions.fetch('bash', {}).each do |command, action|
    next unless action == 'allow'
    raise "Reviewer auto-executes code: #{path}: #{command}" if command.match?(/\A(?:go|cargo|rustc|clippy|golangci-lint|ctx7|terraform|helm|kubectl)\b/)
  end
end

%w[code-reviewer go-financial-code-reviewer database-admin-reviewer rust-systems-code-reviewer platform-infra-reviewer].each do |base|
  text = File.read(File.join(root, 'agents', "#{base}-betika.md"))
  raise "Betika does not explicitly load base: #{base}" unless text.include?("~/.config/opencode/agents/#{base}.md")
  config = YAML.safe_load(text.split('---', 3)[1])
  raise "Betika routing drift: #{base}" unless config['model'].start_with?('gateframe/')
end

guide = File.read(File.join(root, 'playbooks/code-review.md'))
review_prompt = File.read(File.join(root, 'prompts/code-review.md'))
['For `light` reviews, return only:', 'no per-AC table',
 'Risk escalation uses the standard/deep contract', 'affected checks Unknown'].each do |rule|
  raise "Missing compact review rule: #{rule}" unless review_prompt.include?(rule)
end
lite = File.read(File.join(root, 'agents/code-reviewer-lite.md'))
raise 'Lite reviewer lacks light default' unless lite.include?('Use `review_depth: light` by default')
raise 'Lite reviewer lacks escalation' unless lite.include?('do not approve it as lightweight')
raise 'Lite reviewer duplicates full review on escalation' unless lite.include?('then stop. Do not complete a duplicate full review.')
# Every agent allowed to dispatch both tiers must choose one and serialize escalation.
Dir.glob(File.join(root, 'agents', '*.md')).each do |path|
  text = File.read(path)
  config = YAML.safe_load(text.split('---', 3)[1])
  tasks = config.fetch('permission', {}).fetch('task', {})
  next unless tasks.is_a?(Hash) && %w[code-reviewer code-reviewer-lite].all? { |name| tasks[name] == 'allow' }
  ['never dispatch lite and full together', 'wait for its escalation handoff',
   'selected tier for re-review', 'specialist reviews remain independent'].each do |rule|
    raise "Missing exclusive reviewer routing: #{path}: #{rule}" unless text.include?(rule)
  end
end
sections = ['Review method', 'Go and financial systems', 'Database and migrations',
            'Infrastructure', 'Rust systems', 'Security', 'Completion gate', 'Sources']
sections.each { |section| raise "Missing domain: #{section}" unless guide.include?("## #{section}\n") }
# Shared references must resolve on disk, including transitive base-agent/prompt reads.
files = reviewers + [File.join(root, 'prompts/code-review.md'),
                     File.join(root, 'playbooks/go-financial.md')]
files.each do |path|
  File.read(path).scan(%r{~/.config/opencode/([\w/.-]+\.md)}).flatten.each do |relative|
    raise "Broken shared reference: #{path}: #{relative}" unless File.file?(File.join(root, relative))
  end
end
raise 'Go concern playbook bypasses shared review' unless File.read(files.last).include?(shared)
puts "Reviewer checks passed (#{reviewers.size} agents, explicit shared/base loading, read-only authority, references)."
