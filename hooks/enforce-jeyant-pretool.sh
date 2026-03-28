#!/bin/bash
# ==============================================================================
# HOOK : PreToolUse — BLOQUE les edits sans pipeline
# ==============================================================================
# Bloque Edit/Write sur des fichiers code source si /jeyant n'a pas
# ete invoque dans la session.
#
# Utilise un fichier marqueur ecrit par enforce-pipeline.sh quand
# le pipeline est actif.
#
# Exit 0 : autorise
# Exit 2 : BLOQUE (l'outil ne s'execute pas)
# ==============================================================================

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Seulement pour Edit et Write
case "$TOOL_NAME" in
  Edit|Write) ;;
  *) exit 0 ;;
esac

# Si pas de fichier, laisser passer
[ -z "$FILE_PATH" ] && exit 0

# Verifier si c'est un fichier code source
EXT="${FILE_PATH##*.}"
case "$EXT" in
  ts|tsx|js|jsx|py|rs|go|rb|java|vue|svelte) ;;
  *) exit 0 ;; # Pas du code source (md, json, yaml...) → laisser passer
esac

# Verifier si le pipeline a ete active dans cette session
SESSION_ID="${CLAUDE_SESSION_ID:-default}"
PIPELINE_MARKER="/tmp/claude-pipeline-active-${SESSION_ID}"

if [ ! -f "$PIPELINE_MARKER" ]; then
  cat << 'EOF' >&2
[BLOQUE] Modification de code source sans pipeline qualite.

Tu dois d'abord invoquer /jeyant avec la description de la tache,
ou au minimum declarer le type de travail (fix, feature, refactor).

Le hook UserPromptSubmit t'a indique le pipeline a suivre.
Suis-le avant de modifier du code.
EOF
  exit 2
fi

exit 0
