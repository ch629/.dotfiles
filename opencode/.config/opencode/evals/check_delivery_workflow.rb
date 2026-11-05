require 'yaml'
require 'json'
require 'digest'

# Static prompt-contract checks, NOT evidence of model execution. Authority:
# policies/delivery-brief.md. Run: ruby opencode/.config/opencode/evals/check_delivery_workflow.rb
# Inspect active bodies only: a passive policy link cannot satisfy these checks.
# Match concepts within a paragraph/list block, not exact sentences or whole-file
# keyword bags. Live routing/permission behavior still needs model eval evidence.
root = File.expand_path('..', __dir__)
failures = []
checks = 0
check = lambda do |name, condition|
  checks += 1
  failures << name unless condition
end

# Ordered permission-map snapshots from 50ebb8ffcab9fe2150e089ccb182fa1835651261.
# YAML formatting may change; values AND rule ordering must not. No Git/network
# dependency at test runtime and no broadening permissions to enable routing.
permissions = {
  'product-planner-personal' => 'b5dddeacd52a8ee8b7b396aa193d5110b372b43919176ff5f03b97b151d3c4a0',
  'ticket-orchestrator' => '2a2270f374798493091f626b8988d3f79c162f6d4459a97cc78a9fff5b13d5e3',
  'developer-personal' => 'd99de819f15cb36f1014502753ed0b7575f18ce6f98c28fdeb8886d1c3c40248',
  'quick-dev' => '5461200639f15dfa145fe8365fa49dceea5de69c3169fc1f075d1f47674435ca',
  'ticket-clarifier' => '9f813008f762ffd089784bee90a5c01db2df6e521fc17f4b488c07b04e1aaead',
  'ticket-researcher' => '2f0b28a5d51f8ad3211b765cd08c4be84fd6a15ef12aef6ca67759f6c079c979',
  'implementation-planner' => '76b1ad17c1dadb5dc1d1978ce37b268606d870326107ee3af96a1cb23b7d816d',
  'completion-reviewer' => '58c03c92c8fb81586e618759936c72f090a8f3ad33776af5922972b85534e227',
  'pr-description-writer' => '64f4f21d68af66b3ab12c45cd7fb537f7cde9df633ea193b25a38c38294fc066'
}
bodies = {}
permissions.each do |agent, digest|
  text = File.read(File.join(root, 'agents', "#{agent}.md"))
  _, frontmatter, body = text.split(/^---\s*$\n?/, 3)
  config = YAML.safe_load(frontmatter)
  check.call("#{agent}: permissions unchanged", Digest::SHA256.hexdigest(JSON.generate(config.fetch('permission'))) == digest)
  bodies[agent] = body
end

has = lambda do |agent, *patterns|
  bodies.fetch(agent).split(/\n\s*\n/).any? do |block|
    patterns.all? { |pattern| block.match?(pattern) }
  end
end
rule = lambda do |agent, name, *patterns|
  check.call("#{agent}: #{name}", has.call(agent, *patterns))
end
ticketless = /ticketless|without (?:a )?ticket|no ticket|ticket[- ]optional/i
negative = /\b(?:no|not|never|skip|avoid|do not|don't)\b/i

# AC1: explicit ticketless inputs through every stage, not just a new policy link.
permissions.each_key do |agent|
  rule.call(agent, 'accept ticketless request or delivery brief', ticketless, /request|brief|input|intake|resume/i)
end
%w[ticket-orchestrator developer-personal completion-reviewer].each do |agent|
  rule.call(agent, 'ticketless mode skips Linear lookup AND mutation', ticketless, /Linear/i,
            negative, /lookup|fetch|read|query|view/i, /mutat|write|start|state change/i)
end
rule.call('ticket-orchestrator', 'ticketed intake still fetches supplied key', /ticketed|if.*(?:ticket|key)|when.*(?:ticket|key)/i, /linear issue view/)
rule.call('ticket-orchestrator', 'ticket state mutation requires separate authority',
          /(?:linear issue start|ticket[^.\n]*(?:mutat|state))[^.\n]*(?:explicit|authoriz)|(?:explicit|authoriz)[^.\n]*(?:linear issue start|ticket[^.\n]*(?:mutat|state))/i)
rule.call('completion-reviewer', 'ticketed requirements still reconciled', /ticket/i, /reconcil|divergence|drift/i, /requirements|criteria/i)
rule.call('pr-description-writer', 'omit absent key rather than invent linkage', ticketless, negative, /invent|fabricat|key|link/i)
rule.call('pr-description-writer', 'retain supplied ticket traceability', /ticket|key/i, /supplied|provided|when present|if present/i, /title|link|traceability/i)

# AC2: primary entry/resumption points enforce the lifecycle. Quick-dev's ordinary
# bounded path is exempt; lifecycle checks apply to its brief/resumption path.
primaries = %w[product-planner-personal ticket-orchestrator developer-personal quick-dev]
primaries.each do |agent|
  rule.call(agent, 'resume by reading index and brief and reconciling status', /resum/i,
            /read|load|inspect/i, /index|README/, /brief/i, /status|dirty|repository/i, /approval/i)
  rule.call(agent, 'approval binds exact revision AND content', /approv/i, /exact|specific/i,
            /revision/i, /content|digest|blob|hash/i)
  rule.call(agent, 'material change renews revision and explicit approval', /material/i,
            /new|renew|fresh/i, /revision/i, /approv/i)
  rule.call(agent, 'publication is separately authorized', /publication|push|PR creation/i,
            /separate/i, /authoriz|approval/i)
end
%w[product-planner-personal ticket-orchestrator].each do |agent|
  ['Discovery', 'Proposed delivery', 'Blocked', 'Approved delivery', 'Superseded'].each do |state|
    rule.call(agent, "lifecycle state #{state}", /#{Regexp.escape(state)}/i, /state|lifecycle/i)
  end
  rule.call(agent, 'ambiguous approval cannot start implementation', /ambiguous|unclear|keep exploring/i,
            /approv/i, /clarify|ask|not|never/i, /implement|delivery/i)
  rule.call(agent, 'unblocking does not automatically approve', /block/i, /not|never|no/i,
            /automatic|restore|inherit|transfer/i, /approv/i)
end

# AC3: durable paths and safe persistence, including unsaved and dirty edge cases.
%w[product-planner-personal ticket-orchestrator].each do |agent|
  rule.call(agent, 'repository-local index and versioned brief', /docs\/work-plans\//,
            /README\.md/, /brief-v.*\.md/)
  rule.call(agent, 'inspect destination and Git status before saving', /before/i,
            /sav(?:e|ing)|persist|writ(?:e|ing)/i, /destination|existing|path/i, /(?:git )?status/i)
  rule.call(agent, 'preserve dirty brief and clarify newer decisions', /dirty/i,
            /brief/i, /preserve|not overwrite|never overwrite/i, /compar|clarif/i)
  rule.call(agent, 'preserve unrelated staged and unstaged work', /unrelated|user work/i,
            /staged/i, /unstaged/i, /preserve|never|do not/i)
  rule.call(agent, 'unsaved fallback includes full copyable content', /not saved|unsaved/i,
            /full|complete/i, /copyable|copy.*paste/i)
  rule.call(agent, 'preserve predecessor and successor history', /preserv|retain/i,
            /predecessor/i, /successor/i)
end

# AC4: a continuation carries enough information to survive a primary switch.
primaries.each do |agent|
  rule.call(agent, 'manual primary switch when permissions deny handoff', /denied|forbidden|not allowed|permission/i,
            /manual|user.*switch/i, /primary|agent|switch/i, /handoff|continuation/i)
  rule.call(agent, 'handoff includes path summary state approval evidence and next action',
            /path/i, /summary/i, /state/i, /revision/i, /approval/i, /evidence/i, /next action/i)
end
%w[ticket-clarifier ticket-researcher implementation-planner completion-reviewer pr-description-writer].each do |agent|
  rule.call(agent, 'stage carries brief path and revision', /brief/i, /path/i, /revision/i)
end
rule.call('ticket-clarifier', 'readiness is not delivery approval', /readiness|ready/i, /not|never/i, /approv/i)
rule.call('ticket-researcher', 'research cannot invent approval', /not|never/i, /invent|grant|claim|infer/i, /approv/i)
rule.call('implementation-planner', 'changed plan triggers renewed approval', /chang|material/i, /approv/i, /renew|new|again/i)
rule.call('completion-reviewer', 'ticketless completion checks approved brief evidence', ticketless, /brief/i, /approv/i, /evidence|criteria/i)
rule.call('completion-reviewer', 'missing evidence blocks completion', /missing|no evidence/i, /Unknown|Fail|Incomplete|Blocked/i)
rule.call('pr-description-writer', 'description does not authorize publication', /not|never|only/i, /publication|open.*PR|run.*gh/i)

# AC5: bounded quick-dev remains a fast path, not mandatory orchestration.
rule.call('quick-dev', 'direct bounded work remains supported', /direct|yourself/i, /bounded|contained|small/i)
rule.call('quick-dev', 'no mandatory ticket lookup or planning pipeline', /no mandatory|not require/i, /ticket/i, /planning|pipeline/i)
rule.call('quick-dev', 'uncertain or multi-stream work escalates', /uncertain|multi.stream|independent workstreams/i,
          /stop|escalat/i, /ticket-orchestrator/)
rule.call('quick-dev', 'escalation cannot bypass task denial', /not.*delegate|never.*delegate/i, /reviewers|task targets|permission/i)
rule.call('developer-personal', 'ticketed Linear specialist routing retained', /Linear ticket/i, /delegate/i, /linear-ticket-researcher/)

failures.each { |failure| warn "FAIL: #{failure}" }
puts "Delivery workflow static checks: #{checks - failures.length}/#{checks} passed; #{failures.length} failed."
puts 'Static prompt contracts only; model behavior and integration are not evaluated.'
exit(failures.empty? ? 0 : 1)
