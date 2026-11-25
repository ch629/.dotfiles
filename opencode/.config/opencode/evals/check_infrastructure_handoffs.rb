require 'yaml'

# Static contracts only; these do not test model behavior or runtime permissions.
root = File.expand_path('..', __dir__)
agents = %w[planned-dev quick-dev ticket-orchestrator developer-personal developer-betika linear-parallel-work-orchestrator]
patterns = [/live infrastructure change.*requested/i, /stop before any remote mutation/i,
            /manual primary switch to `infrastructure-operator`/i, /not task delegation/i,
            /copyable continuation/i, /known target/i, /requested effects/i, /prepared work and evidence/i,
            /unknowns/i, /omit secrets/i, /no authority transfers/i,
            /operator independently makes its plan/i, /explicit approval before any operation/i]
failures = []
agents.each do |agent|
  _, frontmatter, body = File.read(File.join(root, 'agents', "#{agent}.md")).split(/^---\s*$\n?/, 3)
  config = YAML.safe_load(frontmatter)
  tasks = config.fetch('permission').fetch('task')
  action = tasks.select { |pattern, _| File.fnmatch?(pattern, 'infrastructure-operator') }.values.last
  failures << "#{agent}: operator task must be denied" unless action == 'deny'
  failures << "#{agent}: incomplete handoff contract" unless body.split(/\n\s*\n/).any? { |block| patterns.all? { |pattern| block.match?(pattern) } }
end
failures.each { |failure| warn "FAIL: #{failure}" }
puts "Infrastructure handoff static checks: #{agents.length * 2 - failures.length}/#{agents.length * 2} passed; #{failures.length} failed."
puts 'Static prompt/config contracts only; model behavior and runtime enforcement are not evaluated.'
exit(failures.empty? ? 0 : 1)
