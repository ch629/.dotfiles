# Run: ruby opencode/.config/opencode/evals/check_reviewers.rb
# Static wiring/authority checks only; not a model-quality or runtime sandbox test.
require 'yaml'

root = File.expand_path('..', __dir__)
shared = '~/.config/opencode/playbooks/code-review.md'
prompt = '~/.config/opencode/newagents/prompts/code-review.md'
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
    text = File.read(File.join(root, 'newagents/prompts/code-review.md'))
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
sections = ['Review method', 'Go and financial systems', 'Database and migrations',
            'Infrastructure', 'Rust systems', 'Security', 'Completion gate', 'Sources']
sections.each { |section| raise "Missing domain: #{section}" unless guide.include?("## #{section}\n") }
# Shared references must resolve on disk, including transitive base-agent/prompt reads.
files = reviewers + [File.join(root, 'newagents/prompts/code-review.md'),
                     File.join(root, 'newagents/playbooks/go-financial.md')]
files.each do |path|
  File.read(path).scan(%r{~/.config/opencode/([\w/.-]+\.md)}).flatten.each do |relative|
    raise "Broken shared reference: #{path}: #{relative}" unless File.file?(File.join(root, relative))
  end
end
raise 'Go concern playbook bypasses shared review' unless File.read(files.last).include?(shared)
puts "Reviewer checks passed (#{reviewers.size} agents, explicit shared/base loading, read-only authority, references)."
