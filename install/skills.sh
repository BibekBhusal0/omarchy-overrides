SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/clone.sh"
source "$SCRIPT_DIR/../utils/symlink.sh"

clone skills ~/Code/skills

SKILLS_DIR="$HOME/Code/skills"

create_symlink "$SKILLS_DIR/AGENTS.global.md" "$HOME/.config/opencode/AGENTS.md"
create_symlink "$SKILLS_DIR/AGENTS.global.md" "$HOME/.codex/AGENTS.md"
create_symlink "$SKILLS_DIR/AGENTS.global.md" "$HOME/.claude/CLAUDE.md"

GEMINI_RULES_DIR="$HOME/.gemini/config/rules"

# T3 gives each Antigravity instance a private GEMINI_HOME; link global rules into existing profiles.
for profile in "$HOME"/.t3/userdata/providers/antigravity/*/; do
  [[ -d "$profile" ]] || continue
  create_symlink "$GEMINI_RULES_DIR" "$profile/config/rules"
done
create_symlink "$SKILLS_DIR/AGENTS.global.md" "$GEMINI_RULES_DIR/AGENTS.md"

for skill_dir in "$SKILLS_DIR"/*/; do
  [[ -f "$skill_dir/SKILL.md" ]] || continue
  skill="$(basename "$skill_dir")"
  create_symlink "$skill_dir" "$HOME/.config/opencode/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.agents/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.claude/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.codex/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.gemini/config/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.gemini/antigravity-cli/skills/$skill"
done

OPENCODE_JSON="$HOME/.config/opencode/opencode.json"
mkdir -p "$(dirname "$OPENCODE_JSON")"
[[ -f "$OPENCODE_JSON" ]] || echo '{}' >"$OPENCODE_JSON"
jq '.permission.external_directory["~/Code/skills"] = "allow"
  | .permission.external_directory["~/Code/skills/**"] = "allow"
  | .permission.external_directory["~/Code/random/opencode"] = "allow"
  | .permission.external_directory["~/Code/random/opencode/**"] = "allow"' "$OPENCODE_JSON" >"$OPENCODE_JSON.tmp" && mv "$OPENCODE_JSON.tmp" "$OPENCODE_JSON"
