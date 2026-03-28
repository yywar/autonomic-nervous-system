#!/bin/bash
# ==============================================================================
# HOOK : PostToolUse — QUALITE AUTOMATIQUE
# ==============================================================================
# Apres chaque Edit/Write sur un fichier code, lance automatiquement
# le linter et le formateur s'ils sont disponibles dans le projet.
#
# Exit 0 : toujours (ne bloque jamais, avertit seulement)
# stdout : avertissements envoyes a l'agent
# ==============================================================================

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Si pas de fichier, rien a faire
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Extraire l'extension
EXT="${FILE_PATH##*.}"

# ─────────────────────────────────────────────
# Auto-format si prettier est disponible
# ─────────────────────────────────────────────
case "$EXT" in
  ts|tsx|js|jsx|json|css|scss|html|vue|svelte|md|yaml|yml)
    if command -v npx &>/dev/null; then
      # Chercher prettier dans le projet
      PROJECT_DIR=$(echo "$INPUT" | jq -r '.project_dir // empty' 2>/dev/null)
      if [ -n "$PROJECT_DIR" ] && [ -f "$PROJECT_DIR/node_modules/.bin/prettier" ]; then
        npx prettier --write "$FILE_PATH" 2>/dev/null || true
      fi
    fi
    ;;
esac

# ─────────────────────────────────────────────
# Auto-lint si eslint est disponible (avertissement seulement)
# ─────────────────────────────────────────────
case "$EXT" in
  ts|tsx|js|jsx|vue|svelte)
    if command -v npx &>/dev/null; then
      PROJECT_DIR=$(echo "$INPUT" | jq -r '.project_dir // empty' 2>/dev/null)
      if [ -n "$PROJECT_DIR" ] && [ -f "$PROJECT_DIR/node_modules/.bin/eslint" ]; then
        LINT_OUTPUT=$(npx eslint --no-error-on-unmatched-pattern "$FILE_PATH" 2>/dev/null || true)
        if [ -n "$LINT_OUTPUT" ]; then
          echo "[AUTO-LINT] Avertissements ESLint detectes sur $FILE_PATH :"
          echo "$LINT_OUTPUT" | head -20
        fi
      fi
    fi
    ;;
esac

# ─────────────────────────────────────────────
# Detection de patterns de securite basiques
# (complement au plugin security-guidance)
# ─────────────────────────────────────────────
if [ -f "$FILE_PATH" ]; then
  CONTENT=$(cat "$FILE_PATH" 2>/dev/null || true)

  # Verifier les patterns dangereux dans le contenu modifie
  if echo "$CONTENT" | grep -qE '(password|secret|api.?key|token)\s*[:=]\s*["\x27][^"\x27]{8,}'; then
    echo "[SECURITE] Possible secret code en dur detecte dans $FILE_PATH. Utilise des variables d'environnement."
  fi
fi

exit 0
