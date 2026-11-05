# Run: ruby opencode/.config/opencode/evals/check_infra_policy.rb
# Static policy regression checks, not an OpenCode runtime/sandbox test.
require "yaml"
require "json"

root = File.expand_path("..", __dir__)
agents = File.join(root, "agents")
playbook = File.read(File.join(root, "playbooks/infrastructure.md"))

def check(condition, message)
  raise message unless condition
end

def permission(rules, command)
  rules.reduce(nil) { |value, (pattern, action)| File.fnmatch?(pattern, command) ? action : value }
end

Dir.glob(File.join(agents, "*.md")).each do |path|
  data = YAML.safe_load(File.read(path).split("---", 3)[1])
  check(data.is_a?(Hash) && data["description"] && data["mode"], "Invalid frontmatter: #{path}")
end

%w[infra-reviewer platform-infra-reviewer platform-infra-reviewer-betika].each do |name|
  text = File.read(File.join(agents, "#{name}.md"))
  rules = YAML.safe_load(text.split("---", 3)[1]).fetch("permission")
  check(rules["edit"] == "deny" && rules["task"] == "deny", "#{name}: editing/delegation")
  check(rules.fetch("bash")["*"] == "deny", "#{name}: shell must default deny")
  check(text.include?("~/.config/opencode/playbooks/infrastructure.md"), "#{name}: missing shared policy")
  diff = "git --no-pager diff --no-ext-diff --no-textconv abc...def -- infra/main.tf"
  check(rules["bash"].values.all? { |action| action == "deny" }, "#{name}: shell access granted")
  [diff, "#{diff} -o /tmp/review-output", "terraform fmt", "terraform apply", "helm template chart --output-dir out",
   "kubectl apply -f manifest.yaml", "sed -i x file", "rg --pre malicious x",
   "#{diff} --output=leak", "#{diff} --ext-diff", "#{diff} --textconv"].each do |command|
    check(permission(rules["bash"], command) == "deny", "#{name}: allowed #{command}")
  end
end

%w[ticket-orchestrator ticket-researcher implementation-planner test-writer
   feature-developer completion-reviewer security-scanner developer-personal
   developer-betika linear-parallel-work-orchestrator].each do |name|
  check(File.read(File.join(agents, "#{name}.md")).include?("~/.config/opencode/playbooks/infrastructure.md"),
        "#{name}: shared policy not loaded")
end

orchestrator = File.read(File.join(agents, "ticket-orchestrator.md"))
shell = YAML.safe_load(orchestrator.split("---", 3)[1]).fetch("permission").fetch("bash")
["gh pr merge", "gh repo delete"].each do |command|
  check(permission(shell, command) != "allow", "Orchestrator grants #{command}")
end
check(!shell.key?("sed *") && !shell.key?("find *"), "Orchestrator has write-capable shell shortcuts")
scanner = YAML.safe_load(File.read(File.join(agents, "security-scanner.md")).split("---", 3)[1])
check(!scanner.fetch("permission").fetch("bash").key?("sed *"), "Scanner permits sed -i")
%w[base_sha head_sha].each { |field| check(orchestrator.include?(field), "Missing #{field}") }
check(orchestrator.include?("not the generic size thresholds"), "Infra tiering must override generic size thresholds")
review = File.read(File.join(root, "newagents/prompts/code-review.md"))
check(review.include?("<base_sha>...<head_sha>") && !review.include?("origin/main...HEAD") &&
      !review.include?("exactly one scoped diff"), "Code review has a stale diff contract")
["**high-risk**", "**Blocked**", "-detailed-exitcode", "including previously passing",
 "Only open a blocked **draft PR**"].each do |rule|
  check(playbook.include?(rule), "Missing infra rule: #{rule}")
end

cases = JSON.parse(File.read(File.join(__dir__, "cases.json")))
ids = cases.map { |item| item.fetch("id") }
check(ids.uniq == ids, "Duplicate eval case IDs")
%w[infra-risk-one-line-iam infra-missing-plan infra-stale-review infra-simple-change].each do |id|
  check(ids.include?(id), "Missing behavioral eval: #{id}")
end
puts "Infrastructure policy checks passed (frontmatter, configured shell rules, shared policy, eval cases)."
