SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/clone.sh"
source "$SCRIPT_DIR/../utils/symlink.sh"

clone skills ~/Code/skills

SKILLS_DIR="$HOME/Code/skills"

create_symlink "$SKILLS_DIR/AGENTS.global.md" "$HOME/.config/opencode/AGENTS.md"
create_symlink "$SKILLS_DIR/AGENTS.global.md" "$HOME/.codex/AGENTS.md"
create_symlink "$SKILLS_DIR/AGENTS.global.md" "$HOME/.claude/CLAUDE.md"

for skill_dir in "$SKILLS_DIR"/*/; do
  [[ -f "$skill_dir/SKILL.md" ]] || continue
  skill="$(basename "$skill_dir")"
  create_symlink "$skill_dir" "$HOME/.config/opencode/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.agents/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.claude/skills/$skill"
  create_symlink "$skill_dir" "$HOME/.codex/skills/$skill"
done
