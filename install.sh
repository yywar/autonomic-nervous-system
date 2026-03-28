#!/bin/bash
# ==============================================================================
# SYSTEME NERVEUX AUTONOME — Installeur complet
# ==============================================================================
# Installe le systeme d'enforcement qualite pour Claude Code.
#
# Usage : bash install.sh
#
# Ce que fait l'installeur :
#   1. Copie les hooks globaux dans ~/.claude/hooks/
#   2. Installe les skills (jeyant v2, checkpoint, rodin)
#   3. Injecte la config hooks dans ~/.claude/settings.json
#   4. Active les 13 plugins dans settings.json
#   5. Ajoute les deny rules de securite
#   6. Desactive les skills legacy (brainstorming, planification)
#   7. Installe le template projet (deploy-to-project.sh)
#
# Prerequis :
#   - Claude Code installe
#   - jq installe (apt install jq / brew install jq)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SKILLS_DIR="$CLAUDE_DIR/skills"
SETTINGS="$CLAUDE_DIR/settings.json"
TEMPLATE_DIR="$CLAUDE_DIR/project-template"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   AUTONOMIC NERVOUS SYSTEM — Full Installation  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ─────────────────────────────────────────────
# Verifications
# ─────────────────────────────────────────────
if [ ! -d "$CLAUDE_DIR" ]; then
  echo -e "${RED}Error: $CLAUDE_DIR does not exist. Is Claude Code installed?${NC}"
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  echo -e "${RED}Error: python3 is required.${NC}"
  exit 1
fi

# ─────────────────────────────────────────────
# 1. Hooks globaux
# ─────────────────────────────────────────────
echo -e "${CYAN}[1/7]${NC} ${YELLOW}Installing global hooks...${NC}"
mkdir -p "$HOOKS_DIR"

HOOK_COUNT=0
for hook in "$SCRIPT_DIR"/hooks/*.sh; do
  [ -f "$hook" ] || continue
  BASENAME=$(basename "$hook")
  if [ -f "$HOOKS_DIR/$BASENAME" ]; then
    cp "$HOOKS_DIR/$BASENAME" "$HOOKS_DIR/$BASENAME.bak"
  fi
  cp "$hook" "$HOOKS_DIR/$BASENAME"
  chmod +x "$HOOKS_DIR/$BASENAME"
  HOOK_COUNT=$((HOOK_COUNT + 1))
  echo -e "  ${GREEN}+${NC} $BASENAME"
done
echo -e "  ${GREEN}$HOOK_COUNT hooks installed${NC}"

# ─────────────────────────────────────────────
# 2. Skills (jeyant v2 + checkpoint + rodin)
# ─────────────────────────────────────────────
echo -e "${CYAN}[2/7]${NC} ${YELLOW}Installing skills...${NC}"
mkdir -p "$SKILLS_DIR"

SKILL_COUNT=0
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
  [ -d "$skill_dir" ] || continue
  SKILL_NAME=$(basename "$skill_dir")
  TARGET="$SKILLS_DIR/$SKILL_NAME"

  if [ -d "$TARGET" ] && [ -f "$TARGET/SKILL.md" ]; then
    # Skill existe deja — backup et mise a jour
    cp -r "$TARGET" "$TARGET.bak"
    echo -e "  ${YELLOW}~${NC} $SKILL_NAME (updated, backup saved)"
  else
    echo -e "  ${GREEN}+${NC} $SKILL_NAME"
  fi

  mkdir -p "$TARGET"
  cp -r "$skill_dir"* "$TARGET/" 2>/dev/null || true
  # Copier aussi les sous-dossiers caches
  find "$skill_dir" -mindepth 1 -maxdepth 1 -type d | while read subdir; do
    cp -r "$subdir" "$TARGET/" 2>/dev/null || true
  done
  SKILL_COUNT=$((SKILL_COUNT + 1))
done
echo -e "  ${GREEN}$SKILL_COUNT skills installed${NC}"

# ─────────────────────────────────────────────
# 3. Configuration settings.json — hooks
# ─────────────────────────────────────────────
echo -e "${CYAN}[3/7]${NC} ${YELLOW}Configuring hooks in settings.json...${NC}"

if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

cp "$SETTINGS" "$SETTINGS.bak"
echo -e "  ${YELLOW}~${NC} settings.json backed up"

python3 << PYEOF
import json

settings_path = "$SETTINGS"
hooks_dir = "$HOOKS_DIR"

with open(settings_path) as f:
    settings = json.load(f)

# Define our hooks
our_hooks = {
    "SessionStart": [{
        "matcher": "",
        "hooks": [{"type": "command", "command": f"bash {hooks_dir}/session-context.sh"}]
    }],
    "UserPromptSubmit": [{
        "matcher": "",
        "hooks": [{"type": "command", "command": f"bash {hooks_dir}/enforce-pipeline.sh"}]
    }],
    "PostToolUse": [{
        "matcher": "Edit|Write",
        "hooks": [
            {"type": "command", "command": f"bash {hooks_dir}/auto-quality.sh"},
            {"type": "command", "command": f"bash {hooks_dir}/track-changes.sh"}
        ]
    }],
    "Stop": [{
        "matcher": "",
        "hooks": [{"type": "command", "command": f"bash {hooks_dir}/verify-completion.sh"}]
    }]
}

if "hooks" not in settings:
    settings["hooks"] = {}

added = 0
for event, event_hooks in our_hooks.items():
    if event not in settings["hooks"]:
        settings["hooks"][event] = event_hooks
        added += 1
    else:
        existing_commands = set()
        for entry in settings["hooks"][event]:
            for h in entry.get("hooks", []):
                existing_commands.add(h.get("command", ""))
        for entry in event_hooks:
            for h in entry.get("hooks", []):
                if h.get("command", "") not in existing_commands:
                    settings["hooks"][event].append(entry)
                    added += 1
                    break

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print(f"  {added} hook events configured")
PYEOF

# ─────────────────────────────────────────────
# 4. Activation des plugins
# ─────────────────────────────────────────────
echo -e "${CYAN}[4/7]${NC} ${YELLOW}Enabling plugins in settings.json...${NC}"

python3 -c "
import json

settings_path = '$SETTINGS'
with open(settings_path) as f:
    settings = json.load(f)

if 'enabledPlugins' not in settings:
    settings['enabledPlugins'] = {}

plugins = [
    'superpowers@claude-plugins-official',
    'feature-dev@claude-plugins-official',
    'frontend-design@claude-plugins-official',
    'context7@claude-plugins-official',
    'code-review@claude-plugins-official',
    'code-simplifier@claude-plugins-official',
    'security-guidance@claude-plugins-official',
    'hookify@claude-plugins-official',
    'typescript-lsp@claude-plugins-official',
    'commit-commands@claude-plugins-official',
    'pr-review-toolkit@claude-plugins-official',
    'playwright@claude-plugins-official',
    'github@claude-plugins-official',
]

added = 0
for plugin in plugins:
    if plugin not in settings['enabledPlugins']:
        settings['enabledPlugins'][plugin] = True
        added += 1

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print(f'  {added} plugins enabled ({len(plugins) - added} already active)')
"

# ─────────────────────────────────────────────
# 5. Deny rules
# ─────────────────────────────────────────────
echo -e "${CYAN}[5/7]${NC} ${YELLOW}Adding security deny rules...${NC}"

python3 -c "
import json

settings_path = '$SETTINGS'
with open(settings_path) as f:
    settings = json.load(f)

if 'permissions' not in settings:
    settings['permissions'] = {}
if 'deny' not in settings['permissions']:
    settings['permissions']['deny'] = []

deny_rules = [
    'Bash(rm -rf /)',
    'Bash(rm -rf ~)',
    'Bash(git push*--force *main*)',
    'Bash(git push*--force *master*)',
    'Read(~/.ssh/*)',
    'Read(~/.aws/*)',
    'Read(~/.gnupg/*)'
]

existing = set(settings['permissions']['deny'])
added = 0
for rule in deny_rules:
    if rule not in existing:
        settings['permissions']['deny'].append(rule)
        added += 1

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print(f'  {added} deny rules added ({len(deny_rules) - added} already present)')
"

# ─────────────────────────────────────────────
# 6. Desactiver les skills legacy
# ─────────────────────────────────────────────
echo -e "${CYAN}[6/7]${NC} ${YELLOW}Disabling legacy conflicting skills...${NC}"

for skill in brainstorming planification; do
  SKILL_FILE="$SKILLS_DIR/$skill/SKILL.md"
  if [ -f "$SKILL_FILE" ]; then
    mv "$SKILL_FILE" "$SKILL_FILE.disabled"
    echo -e "  ${GREEN}+${NC} $skill disabled"
  elif [ -f "$SKILL_FILE.disabled" ]; then
    echo -e "  ${YELLOW}~${NC} $skill already disabled"
  else
    echo -e "  ${YELLOW}~${NC} $skill not found (OK)"
  fi
done

# ─────────────────────────────────────────────
# 7. Template projet
# ─────────────────────────────────────────────
echo -e "${CYAN}[7/7]${NC} ${YELLOW}Installing project template...${NC}"

mkdir -p "$TEMPLATE_DIR/.claude/agents"

cp -r "$SCRIPT_DIR/project-template/.claude/agents/"*.md "$TEMPLATE_DIR/.claude/agents/" 2>/dev/null || true
cp "$SCRIPT_DIR/project-template/.claude/"hookify.*.local.md "$TEMPLATE_DIR/.claude/" 2>/dev/null || true
cp "$SCRIPT_DIR/project-template/CLAUDE.md.template" "$TEMPLATE_DIR/" 2>/dev/null || true

# Script de deploiement
cat > "$TEMPLATE_DIR/deploy-to-project.sh" << 'DEPLOY'
#!/bin/bash
set -euo pipefail

TEMPLATE_DIR="$HOME/.claude/project-template"
PROJECT_DIR="${1:-.}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: $PROJECT_DIR does not exist"
  exit 1
fi

echo ""
echo "=== Deploying Autonomic Nervous System ==="
echo "Project: $(realpath "$PROJECT_DIR")"
echo ""

mkdir -p "$PROJECT_DIR/.claude/agents"

for rule in "$TEMPLATE_DIR/.claude"/hookify.*.local.md; do
  [ -f "$rule" ] || continue
  BASENAME=$(basename "$rule")
  if [ ! -f "$PROJECT_DIR/.claude/$BASENAME" ]; then
    cp "$rule" "$PROJECT_DIR/.claude/$BASENAME"
    echo "[+] $BASENAME"
  else
    echo "[~] $BASENAME (exists)"
  fi
done

for agent in "$TEMPLATE_DIR/.claude/agents"/*.md; do
  [ -f "$agent" ] || continue
  BASENAME=$(basename "$agent")
  if [ ! -f "$PROJECT_DIR/.claude/agents/$BASENAME" ]; then
    cp "$agent" "$PROJECT_DIR/.claude/agents/$BASENAME"
    echo "[+] agents/$BASENAME"
  else
    echo "[~] agents/$BASENAME (exists)"
  fi
done

if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
  cp "$TEMPLATE_DIR/CLAUDE.md.template" "$PROJECT_DIR/CLAUDE.md"
  echo "[+] CLAUDE.md — customize the {{PLACEHOLDERS}}"
else
  echo "[~] CLAUDE.md (exists)"
fi

if [ -f "$PROJECT_DIR/.gitignore" ]; then
  if ! grep -q "hookify" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
    printf '\n# Claude Code local hooks\n.claude/hookify.*.local.md\n' >> "$PROJECT_DIR/.gitignore"
    echo "[+] .gitignore updated"
  fi
fi

mkdir -p "$PROJECT_DIR/docs/state" "$PROJECT_DIR/docs/conventions" "$PROJECT_DIR/docs/architecture" "$PROJECT_DIR/docs/decisions"
echo "[+] docs/ structure created"

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md — replace {{PLACEHOLDERS}} with your stack"
echo "  2. cd $(realpath "$PROJECT_DIR") && claude"
echo "  3. Type: Diagnostic complet du projet"
echo ""
DEPLOY

chmod +x "$TEMPLATE_DIR/deploy-to-project.sh"
echo -e "  ${GREEN}+${NC} Template and deploy script installed"

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            Installation complete!                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Installed:${NC}"
echo "  - 5 global hooks (enforcement, memory, quality, tracking, lock)"
echo "  - 11 skills (jeyant v2 pipeline + checkpoint + rodin)"
echo "  - 13 plugins enabled (superpowers, security, LSP, review...)"
echo "  - 7 security deny rules"
echo "  - Legacy skills disabled"
echo "  - Project deployment template"
echo ""
echo -e "${YELLOW}First launch of Claude Code will download the plugins automatically.${NC}"
echo ""
echo -e "${CYAN}To deploy on a project:${NC}"
echo ""
echo "  bash ~/.claude/project-template/deploy-to-project.sh /path/to/project"
echo ""
echo -e "${CYAN}Then start working:${NC}"
echo ""
echo "  cd /path/to/project && claude"
echo "  > fix the login bug       (auto: debug + TDD pipeline)"
echo "  > add Stripe payments     (auto: challenge + full quality pipeline)"
echo "  > refactor auth module    (auto: zero behavior change + tests)"
echo ""
