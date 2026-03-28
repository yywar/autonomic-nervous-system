#!/bin/bash
# ==============================================================================
# SYSTEME NERVEUX AUTONOME — Installeur
# ==============================================================================
# Installe le systeme d'enforcement qualite pour Claude Code.
#
# Usage : bash install.sh
#
# Ce que fait l'installeur :
#   1. Copie les hooks globaux dans ~/.claude/hooks/
#   2. Injecte la config hooks dans ~/.claude/settings.json
#   3. Ajoute les deny rules de securite
#   4. Desactive les skills legacy (brainstorming, planification)
#   5. Installe le template projet (deploy-to-project.sh)
#   6. Liste les plugins a installer manuellement
#
# Prerequis :
#   - Claude Code installe
#   - jq installe (apt install jq / brew install jq)
#   - Les plugins superpowers et jeyant deja configures
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS="$CLAUDE_DIR/settings.json"
TEMPLATE_DIR="$CLAUDE_DIR/project-template"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   SYSTEME NERVEUX AUTONOME — Installation   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

# ─────────────────────────────────────────────
# Verifications
# ─────────────────────────────────────────────
if [ ! -d "$CLAUDE_DIR" ]; then
  echo -e "${RED}Erreur : $CLAUDE_DIR n'existe pas. Claude Code est-il installe ?${NC}"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo -e "${RED}Erreur : jq est requis. Installez-le :${NC}"
  echo "  Linux : sudo apt install jq"
  echo "  macOS : brew install jq"
  exit 1
fi

# ─────────────────────────────────────────────
# 1. Hooks globaux
# ─────────────────────────────────────────────
echo -e "${YELLOW}[1/6] Installation des hooks globaux...${NC}"
mkdir -p "$HOOKS_DIR"

for hook in "$SCRIPT_DIR"/hooks/*.sh; do
  BASENAME=$(basename "$hook")
  if [ -f "$HOOKS_DIR/$BASENAME" ]; then
    echo -e "  ${YELLOW}BACKUP${NC} $BASENAME → $BASENAME.bak"
    cp "$HOOKS_DIR/$BASENAME" "$HOOKS_DIR/$BASENAME.bak"
  fi
  cp "$hook" "$HOOKS_DIR/$BASENAME"
  chmod +x "$HOOKS_DIR/$BASENAME"
  echo -e "  ${GREEN}OK${NC} $BASENAME"
done

# ─────────────────────────────────────────────
# 2. Configuration settings.json — hooks
# ─────────────────────────────────────────────
echo -e "${YELLOW}[2/6] Configuration des hooks dans settings.json...${NC}"

if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

# Backup
cp "$SETTINGS" "$SETTINGS.bak"
echo -e "  ${YELLOW}BACKUP${NC} settings.json → settings.json.bak"

# Injecter les hooks (merge avec l'existant)
HOOKS_CONFIG=$(cat << JSONEOF
{
  "SessionStart": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash $HOOKS_DIR/session-context.sh"
        }
      ]
    }
  ],
  "UserPromptSubmit": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash $HOOKS_DIR/enforce-pipeline.sh"
        }
      ]
    }
  ],
  "PostToolUse": [
    {
      "matcher": "Edit|Write",
      "hooks": [
        {
          "type": "command",
          "command": "bash $HOOKS_DIR/auto-quality.sh"
        },
        {
          "type": "command",
          "command": "bash $HOOKS_DIR/track-changes.sh"
        }
      ]
    }
  ],
  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash $HOOKS_DIR/verify-completion.sh"
        }
      ]
    }
  ]
}
JSONEOF
)

# Merge hooks into settings.json
python3 << PYEOF
import json, sys

with open("$SETTINGS") as f:
    settings = json.load(f)

hooks_config = json.loads('''$HOOKS_CONFIG''')

# Merge hooks (ne pas ecraser les hooks existants des plugins)
if "hooks" not in settings:
    settings["hooks"] = {}

for event, event_hooks in hooks_config.items():
    if event not in settings["hooks"]:
        settings["hooks"][event] = event_hooks
    else:
        # Verifier si nos hooks sont deja presents
        existing_commands = set()
        for entry in settings["hooks"][event]:
            for h in entry.get("hooks", []):
                existing_commands.add(h.get("command", ""))

        for entry in event_hooks:
            for h in entry.get("hooks", []):
                if h.get("command", "") not in existing_commands:
                    settings["hooks"][event].append(entry)
                    break

with open("$SETTINGS", "w") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print("  OK hooks injectes")
PYEOF

# ─────────────────────────────────────────────
# 3. Deny rules
# ─────────────────────────────────────────────
echo -e "${YELLOW}[3/6] Ajout des deny rules de securite...${NC}"

python3 << 'PYEOF'
import json

settings_path = "$SETTINGS".replace("$SETTINGS", "$SETTINGS")
PYEOF

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

print(f'  OK {added} deny rules ajoutees ({len(deny_rules) - added} deja presentes)')
"

# ─────────────────────────────────────────────
# 4. Desactiver les skills legacy
# ─────────────────────────────────────────────
echo -e "${YELLOW}[4/6] Desactivation des skills legacy...${NC}"

SKILLS_DIR="$CLAUDE_DIR/skills"
DISABLED=0

for skill in brainstorming planification; do
  SKILL_FILE="$SKILLS_DIR/$skill/SKILL.md"
  if [ -f "$SKILL_FILE" ]; then
    mv "$SKILL_FILE" "$SKILL_FILE.disabled"
    echo -e "  ${GREEN}OK${NC} $skill desactive"
    DISABLED=$((DISABLED + 1))
  elif [ -f "$SKILL_FILE.disabled" ]; then
    echo -e "  ${YELLOW}SKIP${NC} $skill deja desactive"
  else
    echo -e "  ${YELLOW}SKIP${NC} $skill non trouve"
  fi
done

# ─────────────────────────────────────────────
# 5. Template projet
# ─────────────────────────────────────────────
echo -e "${YELLOW}[5/6] Installation du template projet...${NC}"

mkdir -p "$TEMPLATE_DIR/.claude/agents"

cp -r "$SCRIPT_DIR/project-template/.claude/agents/"*.md "$TEMPLATE_DIR/.claude/agents/" 2>/dev/null
cp "$SCRIPT_DIR/project-template/.claude/"hookify.*.local.md "$TEMPLATE_DIR/.claude/" 2>/dev/null
cp "$SCRIPT_DIR/project-template/CLAUDE.md.template" "$TEMPLATE_DIR/" 2>/dev/null

# Copier le script de deploiement
cat > "$TEMPLATE_DIR/deploy-to-project.sh" << 'DEPLOY'
#!/bin/bash
set -euo pipefail

TEMPLATE_DIR="$HOME/.claude/project-template"
PROJECT_DIR="${1:-.}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Erreur : $PROJECT_DIR n'existe pas"
  exit 1
fi

echo "=== Deploiement du Systeme Nerveux Autonome ==="
echo "Projet : $(realpath "$PROJECT_DIR")"
echo ""

mkdir -p "$PROJECT_DIR/.claude/agents"

for rule in "$TEMPLATE_DIR/.claude"/hookify.*.local.md; do
  [ -f "$rule" ] || continue
  BASENAME=$(basename "$rule")
  if [ ! -f "$PROJECT_DIR/.claude/$BASENAME" ]; then
    cp "$rule" "$PROJECT_DIR/.claude/$BASENAME"
    echo "[OK] Regle hookify : $BASENAME"
  else
    echo "[SKIP] $BASENAME existe deja"
  fi
done

for agent in "$TEMPLATE_DIR/.claude/agents"/*.md; do
  [ -f "$agent" ] || continue
  BASENAME=$(basename "$agent")
  if [ ! -f "$PROJECT_DIR/.claude/agents/$BASENAME" ]; then
    cp "$agent" "$PROJECT_DIR/.claude/agents/$BASENAME"
    echo "[OK] Agent : $BASENAME"
  else
    echo "[SKIP] $BASENAME existe deja"
  fi
done

if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
  cp "$TEMPLATE_DIR/CLAUDE.md.template" "$PROJECT_DIR/CLAUDE.md"
  echo "[OK] CLAUDE.md template — A PERSONNALISER"
else
  echo "[SKIP] CLAUDE.md existe deja"
fi

if [ -f "$PROJECT_DIR/.gitignore" ]; then
  if ! grep -q "hookify" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
    echo "" >> "$PROJECT_DIR/.gitignore"
    echo "# Claude Code hooks locaux" >> "$PROJECT_DIR/.gitignore"
    echo ".claude/hookify.*.local.md" >> "$PROJECT_DIR/.gitignore"
    echo "[OK] .gitignore mis a jour"
  fi
fi

mkdir -p "$PROJECT_DIR/docs/state" "$PROJECT_DIR/docs/conventions" "$PROJECT_DIR/docs/architecture" "$PROJECT_DIR/docs/decisions"

echo ""
echo "=== Deploiement termine ==="
echo ""
echo "Prochaines etapes :"
echo "  1. Personnaliser CLAUDE.md (remplacer les {{PLACEHOLDERS}})"
echo "  2. cd $(realpath "$PROJECT_DIR") && claude"
echo "  3. Ecrire : Diagnostic complet du projet"
echo ""
DEPLOY

chmod +x "$TEMPLATE_DIR/deploy-to-project.sh"
echo -e "  ${GREEN}OK${NC} Template installe dans $TEMPLATE_DIR"

# ─────────────────────────────────────────────
# 6. Resume
# ─────────────────────────────────────────────
echo -e "${YELLOW}[6/6] Plugins a installer manuellement...${NC}"

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Installation terminee !             ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Installe :${NC}"
echo "  - 5 hooks globaux dans ~/.claude/hooks/"
echo "  - Config hooks dans ~/.claude/settings.json"
echo "  - 7 deny rules de securite"
echo "  - Skills legacy desactivees"
echo "  - Template projet pret"
echo ""
echo -e "${YELLOW}Plugins a installer dans Claude Code (si pas deja fait) :${NC}"
echo ""
echo "  /plugin install security-guidance@claude-plugins-official"
echo "  /plugin install hookify@claude-plugins-official"
echo "  /plugin install typescript-lsp@claude-plugins-official"
echo "  /plugin install commit-commands@claude-plugins-official"
echo "  /plugin install pr-review-toolkit@claude-plugins-official"
echo "  /plugin install playwright@claude-plugins-official"
echo "  /plugin install github@claude-plugins-official"
echo ""
echo -e "${YELLOW}Pour deployer sur un projet :${NC}"
echo ""
echo "  bash ~/.claude/project-template/deploy-to-project.sh /chemin/vers/projet"
echo ""
