#!/bin/bash
# ==============================================================================
# HOOK : PostToolUse — TRACKING AUTOMATIQUE DES CHANGEMENTS
# ==============================================================================
# Enregistre chaque fichier modifie dans un log de session temporaire.
# Ce log sera utilise par le hook Stop pour decider si la capitalisation
# est necessaire.
#
# Exit 0 : toujours (ne bloque jamais)
# ==============================================================================

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Seulement pour les outils qui modifient des fichiers
case "$TOOL_NAME" in
  Edit|Write|MultiEdit) ;;
  *) exit 0 ;;
esac

# Si pas de fichier, rien a tracker
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Fichier de tracking temporaire (par session, dans /tmp)
SESSION_ID="${CLAUDE_SESSION_ID:-default}"
TRACK_FILE="/tmp/claude-session-changes-${SESSION_ID}.log"

# Ecrire le changement (timestamp + fichier)
echo "$(date '+%H:%M:%S') $TOOL_NAME $FILE_PATH" >> "$TRACK_FILE" 2>/dev/null

exit 0
