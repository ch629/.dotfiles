# Run: ruby opencode/.config/opencode/evals/check_shared_access.rb
# Static last-match checks; not a runtime permission or shell sandbox test.
require "json"
require "yaml"

root = File.expand_path("..", __dir__)
rules = JSON.parse(File.read(File.join(root, "opencode.json"))).fetch("permission")
references = %w[agents playbooks policies newagents/prompts newagents/playbooks newagents/policies skills]
paths = references.flat_map { |path| ["~/.config/opencode/#{path}", "~/.dotfiles/opencode/.config/opencode/#{path}"] }
paths << "~/.claude/skills"

def evaluate(rules, path, default)
  rules = { "*" => rules } if rules.is_a?(String)
  rules.reduce(default) { |result, (pattern, action)| File.fnmatch?(pattern.sub(/^~/, Dir.home), path.sub(/^~/, Dir.home)) ? action : result }
end

raise "Unexpected tool permissions" unless rules.keys.sort == %w[edit external_directory]
raise "Allowlist drift" unless rules.fetch("external_directory") == { "*" => "ask" }.merge(paths.to_h { |path| ["#{path}/*", "allow"] })
raise "Edit protections drift" unless rules.fetch("edit") == paths.to_h { |path| ["#{path}/*", "ask"] }

paths.each do |path|
  raise "Reference blocked: #{path}" unless evaluate(rules["external_directory"], "#{path}/nested/*", "ask") == "allow"
end
%w[~/.claude/projects/* ~/.claude/credentials.json ~/.config/opencode/logs/* ~/.config/opencode/opencode.json ~/.ssh/*].each do |path|
  raise "Unrelated access allowed: #{path}" unless evaluate(rules["external_directory"], path, "ask") == "ask"
end

Dir.glob(File.join(root, "agents/*.md")).each do |file|
  agent = YAML.safe_load(File.read(file).split("---", 3)[1]).fetch("permission", {})
  %w[~/.claude/projects/* ~/.config/opencode/logs/* ~/.config/opencode/opencode.json ~/.ssh/*].each do |path|
    # Match OpenCode's home expansion, including existing absolute agent patterns.
    external = agent.fetch("external_directory", {}).to_h.transform_keys { |key| key.sub(/^~/, Dir.home) }
    raise "#{file}: unrelated access allowed" if evaluate(external, path.sub(/^~/, Dir.home), "ask") == "allow"
  end
  paths.each do |path|
    target = "#{path}/nested/file.md"
    external = evaluate(agent.fetch("external_directory", {}), "#{path}/nested/*", evaluate(rules["external_directory"], "#{path}/nested/*", "ask"))
    edit = evaluate(agent.fetch("edit", {}), target, evaluate(rules["edit"], target, "allow"))
    raise "#{file}: reference access regressed" unless external == "allow"
    raise "#{file}: silently edits shared references" unless %w[ask deny].include?(edit)
  end
end
puts "Shared access checks passed (aliases, backing paths, unrelated paths, agent overrides)."
