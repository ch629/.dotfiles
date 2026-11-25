require 'yaml'

root = File.expand_path('..', __dir__)
text = File.read(File.join(root, 'agents/quick-dev.md'))
config = YAML.safe_load(text.split('---', 3)[1])
permission = config.fetch('permission')
raise 'Unexpected delegation' unless permission.fetch('task') == {
  '*' => 'deny', 'code-reviewer' => 'allow', 'code-reviewer-lite' => 'allow'
}
shell = permission.fetch('bash')
raise 'Default shell approval missing' unless shell['*'] == 'ask'
['git switch topic', 'git add file', 'git commit -m fix', 'git push origin topic',
 'git push --force', 'gh pr create --draft', 'gh pr edit 51 --title fix'].each do |command|
  matches = shell.select { |pattern, _| File.fnmatch?(pattern, command) }
  raise "Mutation not approval-gated: #{command}" unless matches.values.last == 'ask'
end
raise 'Redundant directory overrides' if permission.key?('external_directory')
[
  'Several implementation/test steps are normal', 'stop and recommend switching',
  'record starting HEAD, dirty files', 'preserve unrelated edits',
  '~/.config/opencode/policies/governance-profiles.md',
  '~/.config/opencode/playbooks/infrastructure.md',
  'financial-domain requirements only when relevant',
  'Blocked/not run', 'Separate pre-existing failures',
  'permissions, money, migrations, concurrency', 'regardless of line count',
  'including new files', 'reviewed working-tree snapshot',
  'at most two repair/re-review cycles', 'Stage only task-owned changes',
  'a commit request is not a push request', 'suggestions are not authoritative'
].each { |rule| raise "Missing quick-dev rule: #{rule}" unless text.include?(rule) }
%w[go-financial rust-systems frontend-web].each do |book|
  raise "Missing installed playbook: #{book}" unless text.include?("~/.config/opencode/playbooks/#{book}.md")
  raise "Missing playbook file: #{book}" unless File.file?(File.join(root, "playbooks/#{book}.md"))
end
review = File.read(File.join(root, 'prompts/code-review.md'))
brief = File.read(File.join(root, 'policies/delivery-brief.md'))
raise 'Missing conditional brief loading' unless text.include?('For a supplied delivery brief or brief-based resumption, read `~/.config/opencode/policies/delivery-brief.md` before acting')
['## Quick-dev continuation', 'exact revision and content digest/blob',
 'only `ticket-orchestrator` publishes', 'never delegate through reviewers',
 'full brief path'].each { |rule| raise "Missing extracted brief rule: #{rule}" unless brief.include?(rule) }
raise 'Missing concise response contract' unless text.include?('Omit empty sections, repeated summaries')
['scoped working-tree patch/snapshot', 'new/untracked files',
 'Bind the verdict to that snapshot', 'mark the affected criteria Unknown'].each do |rule|
  raise "Missing shared review rule: #{rule}" unless review.include?(rule)
end
puts 'Quick-dev policy checks passed (permissions, scope, verification, snapshot review).'
