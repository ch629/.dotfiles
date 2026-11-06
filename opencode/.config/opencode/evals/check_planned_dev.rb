require 'yaml'
require 'json'

# Static contract checks only: they cannot establish model behavior or runtime denial.
root = File.expand_path('..', __dir__)
failures = []
checks = 0
check = lambda do |name, condition|
  checks += 1
  failures << name unless condition
end
read = lambda do |path|
  full = File.join(root, path)
  File.file?(full) ? File.read(full) : ''
end
agent = lambda do |name|
  text = read.call("agents/#{name}.md")
  parts = text.split(/^---\s*$\n?/, 3)
  config = parts.length == 3 ? YAML.safe_load(parts[1]) : {}
  [config || {}, parts[2].to_s]
rescue Psych::Exception => e
  failures << "#{name}: invalid YAML: #{e.message}"
  [{}, '']
end
has = lambda do |text, *patterns|
  text.split(/\n\s*\n/).any? { |block| patterns.all? { |pattern| block.match?(pattern) } }
end
rule = lambda do |label, text, *patterns|
  check.call(label, has.call(text, *patterns))
end

planned, body = agent.call('planned-dev')
check.call('planned-dev: valid primary', planned['mode'] == 'primary')
permission = planned['permission'].is_a?(Hash) ? planned['permission'] : {}
check.call('planned-dev: edit denied', permission['edit'] == 'deny')
tasks = permission['task'].is_a?(Hash) ? permission['task'] : {}
allowed = %w[feature-developer code-reviewer code-reviewer-lite security-scanner db-reviewer migration-reviewer infra-reviewer]
expected_tasks = [['*', 'deny']] + allowed.map { |name| [name, 'allow'] }
valid_tasks = lambda { |map| map.to_a == expected_tasks }
check.call('planned-dev: ordered task deny-all and named workers only',
           valid_tasks.call(tasks))
%w[security-scanner db-reviewer migration-reviewer infra-reviewer].each do |name|
  check.call("planned-dev: missing #{name} rejected", valid_tasks.call(expected_tasks.to_h) && !valid_tasks.call(expected_tasks.to_h.reject { |key, _| key == name }))
end
rule.call('planned-dev: ordinary request authorizes in-scope execution', body, /ordinary|normal/i, /request/i, /authoriz/i, /implement|execut/i)
rule.call('planned-dev: compact internal planning without routine ceremonies', body, /internal/i, /plan/i, /no|not|without/i, /brief|approval/i)
rule.call('planned-dev: ask on material uncertainty or authority blockers', body, /ask|clarif/i, /ambig|uncertain/i, /scope|risk/i, /authorit|block/i)
rule.call('planned-dev: delegates implementation and tests', body, /feature-developer/i, /delegat/i, /implement|develop/i, /test/i)
rule.call('planned-dev: independent review with risk routing', body, /independent/i, /code.review/i, /risk/i)
rule.call('planned-dev: specialist review when applicable', body, /security/i, /db|database/i, /migration/i, /infra/i, /review/i)
rule.call('planned-dev: bounded repairs and blocked completion', body, /(?:two|2)/i, /repair|fix/i, /re.review|recheck/i, /block|stop/i)
rule.call('planned-dev: missing evidence or required findings block completion', body, /missing|unresolved/i, /evidence/i, /finding|fix/i, /block/i)
rule.call('planned-dev: high risk escalation without permission bypass', body, /high.risk|full.governance/i, /ticket-orchestrator/i, /deni|forbid/i, /bypass|manual/i)
rule.call('planned-dev: infrastructure playbook and authority', body, %r{playbooks/infrastructure\.md}, /infra/i, /authorit|target/i, /verif|validat/i)
rule.call('planned-dev: supplied brief retains resumption and approval', body, /supplied|provided/i, /brief/i, /resum/i, /approv/i, /revision|digest|content/i)
rule.call('planned-dev: action authority separate from implementation', body, /commit/i, /push/i, /PR|pull request/i, /deploy/i, /separate|explicit/i, /authoriz|authority/i)

_, quick = agent.call('quick-dev')
rule.call('quick-dev: coherent delegated work routes to planned-dev', quick, /planned-dev/i, /delegat|coherent/i)
rule.call('quick-dev: high-risk or governed work routes to ticket-orchestrator', quick, /high.risk|governance/i, /ticket-orchestrator/i)
check.call('quick-dev: remains default', JSON.parse(read.call('opencode.json'))['default_agent'] == 'quick-dev')
_, developer = agent.call('feature-developer')
rule.call('feature-developer: caller-selected supplied and developer-owned tests', developer, /supplied|pre.written/i, /developer.owned|developer.authored/i, /test/i, /mode/i)
rule.call('feature-developer: verifies tests in both modes', developer, /test/i, /verif|run/i)
rule.call('feature-developer: commits only with explicit authority', developer, /commit/i, /only|unless|without/i, /authoriz|authority|request/i)
check.call('feature-developer: no unconditional implement or fix commits',
           !developer.match?(/once all clean, commit|commit each logical fix separately/i))
rule.call('feature-developer: handoff includes workspace scope checks and action authority', developer, /worktree|workspace/i, /scope/i, /commands|checks/i, /authorit/i)
rule.call('feature-developer: infra rules retained', developer, %r{playbooks/infrastructure\.md}, /target/i, /authorit/i, /verif/i)
_, ticket = agent.call('ticket-orchestrator')
rule.call('ticket-orchestrator: test-writer-first retained', ticket, /test-writer/i, /failing|red/i, /implement|feature-developer|test/i)
rule.call('ticket-orchestrator: planned-dev routing distinction', ticket, /planned-dev/i, /governance|lighter|ordinary|scope/i)
policy = read.call('policies/delivery-brief.md')
rule.call('delivery policy: ordinary planned-dev exempt from required saved brief', policy, /planned-dev/i, /ordinary/i, /not|no|without|exempt/i, /brief/i)
rule.call('delivery policy: supplied brief retains approval and resumption', policy, /supplied|provided/i, /brief/i, /approv/i, /resum/i)
rule.call('delivery policy: orchestrator retains full gates', policy, /ticket-orchestrator/i, /brief/i, /approv|contract/i)

%w[planned-dev feature-developer security-scanner db-reviewer migration-reviewer].each do |name|
  config, text = agent.call(name)
  bash = config.fetch('permission', {}).fetch('bash', {})
  ['rg --pre /bin/sh pattern .', 'rg --pre=/bin/sh pattern .', 'rg pattern .'].each do |command|
    action = bash.is_a?(Hash) ? bash.select { |pattern, _| File.fnmatch?(pattern, command) }.values.last : bash
    check.call("#{name}: #{command} requires ask (including configured rg)", action == 'ask')
  end
  check.call("#{name}: unknown shell commands require ask", bash.is_a?(Hash) && bash['*'] == 'ask')
  %w[diff log].each do |subcommand|
    command = "git #{subcommand} --output=path"
    action = bash.is_a?(Hash) ? bash.select { |pattern, _| File.fnmatch?(pattern, command) }.values.last : bash
    check.call("#{name}: #{subcommand} output not silently allowed", action != 'allow')
  end
  rule.call("#{name}: no permission bypass via writes", text, /shell|tool/i, /write/i, /bypass/i, /deni/i)
end

%w[security-scanner db-reviewer migration-reviewer].each do |name|
  config, text = agent.call(name)
  check.call("#{name}: read-only", config.fetch('permission', {})['edit'] == 'deny')
  rule.call("#{name}: accepts immutable range or uncommitted snapshot", text, /immutable/i, /range/i, /uncommitted/i, /snapshot/i)
  rule.call("#{name}: snapshot provenance", text, /worktree/i, /starting HEAD/i, /patch/i, /digest/i, /untracked/i, /pre.existing/i, /verification/i)
  rule.call("#{name}: missing provenance blocks", text, /missing/i, /provenance/i, /block/i)
  rule.call("#{name}: no origin main substitution", text, /never/i, /origin\/main/i, /substitut/i)
  rule.call("#{name}: no executable validation", text, /never/i, /execut/i, /validation|tests/i)
end

failures.each { |failure| warn "FAIL: #{failure}" }
puts "Planned-dev static checks: #{checks - failures.length}/#{checks} passed; #{failures.length} failed."
puts 'Static prompt/config contracts only; model behavior and runtime enforcement are not evaluated.'
exit(failures.empty? ? 0 : 1)
