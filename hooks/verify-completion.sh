#!/bin/bash
# ==============================================================================
# HOOK : Stop — LE VERROU + CAPITALISATION
# ==============================================================================
# 1. Verifie que le travail est termine (tests, preuves)
# 2. Si des fichiers code ont ete modifies, rappelle la capitalisation
#    (une seule fois, puis laisse passer)
#
# Exit 0 : autorise la fin
# Exit 2 : BLOQUE la fin
# ==============================================================================

set -euo pipefail

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript // empty' 2>/dev/null || true)

SESSION_ID="${CLAUDE_SESSION_ID:-default}"
TRACK_FILE="/tmp/claude-session-changes-${SESSION_ID}.log"
REMINDED_FILE="/tmp/claude-session-reminded-${SESSION_ID}"

# ─────────────────────────────────────────────
# Gate 1 : Si jeyant invoque, preuves obligatoires
# ─────────────────────────────────────────────
if [ -n "$TRANSCRIPT" ] && echo "$TRANSCRIPT" | grep -qi "jeyant" 2>/dev/null; then
  if ! echo "$TRANSCRIPT" | grep -qiE "(preuves|verdict|PRET|PASS|demontr|proof)" 2>/dev/null; then
    echo "Le pipeline jeyant a ete invoque mais aucune preuve n'est visible. Execute jeyant-preuves avant de terminer." >&2
    exit 2
  fi
fi

# ─────────────────────────────────────────────
# Gate 2 : Si code modifie, tests obligatoires
# ─────────────────────────────────────────────
if [ -n "$TRANSCRIPT" ] && echo "$TRANSCRIPT" | grep -qiE "(Edit|Write).*\.(ts|tsx|js|jsx|py|rs|go)" 2>/dev/null; then
  if ! echo "$TRANSCRIPT" | grep -qiE "(test|vitest|jest|pytest|cargo test)" 2>/dev/null; then
    echo "Du code source a ete modifie mais aucun test n'a ete execute. Lance les tests avant de terminer." >&2
    exit 2
  fi
fi

# ─────────────────────────────────────────────
# Gate 3 : Rappel capitalisation (une seule fois)
# ─────────────────────────────────────────────
if [ -f "$TRACK_FILE" ]; then
  CODE_CHANGES=$(grep -cE '\.(ts|tsx|js|jsx|py|rs|go|rb|java|vue|svelte)$' "$TRACK_FILE" 2>/dev/null || echo "0")

  if [ "$CODE_CHANGES" -ge 3 ] && [ ! -f "$REMINDED_FILE" ]; then
    # Premier essai : rappeler et bloquer UNE FOIS
    touch "$REMINDED_FILE"
    cat << EOF >&2
Session significative ($CODE_CHANGES fichiers code modifies).
Invoque /jeyant-capitalisation pour sauvegarder les lecons,
ou dis "rien a capitaliser" pour terminer.
EOF
    exit 2
  fi

  # Nettoyage
  rm -f "$TRACK_FILE" "$REMINDED_FILE" 2>/dev/null
fi

exit 0
