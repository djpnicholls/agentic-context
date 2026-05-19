#!/usr/bin/env bash
# scripts/validate-postmortem-playbook.sh
# Run from the agentic-context repo root.
# Requires: bash 4+, grep, chmod +x on this file

set -euo pipefail

# Working-directory guard
[[ -f "deploy.sh" ]] || { echo "Run this script from the agentic-context repo root."; exit 1; }

PLAYBOOK="playbooks/investigate/postmortem.md"
INDEX="core/.context/index.md"
REVIEWER="agents/investigation-reviewer/AGENT.md"
WRITER="agents/postmortem-writer/AGENT.md"

fail() { echo "FAIL: $1"; exit 1; }

# 1. Required files exist
for f in "$PLAYBOOK" "$INDEX" "$REVIEWER" "$WRITER"; do
  [[ -f "$f" ]] || fail "Missing file: $f"
done

# 2. Playbook YAML frontmatter fields present
for field in "^name: " "^description: " "^keywords: "; do
  grep -q "$field" "$PLAYBOOK" || fail "Playbook missing frontmatter field matching: $field"
done

# 3. Index references the new playbook
grep -q "investigate/postmortem.md" "$INDEX" || fail "Playbook not referenced in index.md"

# 4. Agent files have required frontmatter
for agent in "$REVIEWER" "$WRITER"; do
  grep -q "^name: " "$agent"          || fail "Missing 'name' in $agent"
  grep -q "^allowed-tools:" "$agent"  || fail "Missing 'allowed-tools' in $agent"
done

# 5. postmortem-writer must have Write in allowed-tools (not just in a comment)
grep -q "^allowed-tools:.*Write" "$WRITER" || fail "postmortem-writer must include Write in allowed-tools"

# 6. deploy.sh actually copies agents/ to .devin/agents/
# Note: use > /dev/null instead of -q in pipes to avoid SIGPIPE with pipefail
grep -v '^\s*#' deploy.sh \
  | grep 'copy_dir_contents.*agents.*\.devin/agents\|\.devin/agents.*copy_dir_contents.*agents' > /dev/null \
  || fail "deploy.sh does not copy agents/ to .devin/agents/"

# 7. agents copy is inside the devin guard (structural extraction, not proximity)
awk '/if agent_enabled devin/,/^fi$/' deploy.sh | grep 'copy_dir_contents.*agents' > /dev/null \
  || fail "agents copy is not inside the agent_enabled devin guard in deploy.sh"

# 8. README.md documents new directories
grep -q "agents/" README.md     || fail "README.md does not document agents/ directory"
grep -q "investigate/" README.md || fail "README.md does not document investigate/ playbook category"

# 9. investigate skill-generation loop is present inside the claude/copilot guard
grep -A60 'agent_enabled claude || agent_enabled copilot' deploy.sh \
  | grep 'playbooks/investigate' > /dev/null \
  || fail "investigate skill loop not found inside the claude/copilot guard in deploy.sh"

# 10. investigation-reviewer must NOT have Write or Bash access
if grep -q "^allowed-tools:.*\(Write\|Bash\)" "$REVIEWER"; then
  fail "investigation-reviewer must not have Write or Bash in allowed-tools"
fi

echo "All structural checks passed."
