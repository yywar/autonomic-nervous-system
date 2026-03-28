#!/bin/bash
# ==============================================================================
# HOOK : Stop — LE VERROU + CAPITALISATION FORCEE
# ==============================================================================
# 1. Verifie que le travail est termine (tests, preuves)
# 2. Si des fichiers code ont ete modifies, BLOQUE tant que la capitalisation
#    n'a pas ete faite (ou explicitement ignoree)
#
# Exit 0 : autorise la fin
# Exit 2 : BLOQUE la fin
# ==============================================================================

set -euo pipefail

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript // empty' 2>/dev/null)

# ─────────────────────────────────────────────
# Gate 1 : Si jeyant invoque, preuves obligatoires
# ─────────────────────────────────────────────
if echo "$TRANSCRIPT" | grep -qi "jeyant"; then
  if ! echo "$TRANSCRIPT" | grep -qiE "(preuves|verdict|PRET|PASS|demontr|proof)"; then
    echo "Le pipeline jeyant a ete invoque mais aucune preuve n'est visible. Execute jeyant-preuves avant de terminer." >&2
    exit 2
  fi
fi

# ─────────────────────────────────────────────
# Gate 2 : Si code modifie, tests obligatoires
# ─────────────────────────────────────────────
if echo "$TRANSCRIPT" | grep -qiE "(Edit|Write).*\.(ts|tsx|js|jsx|py|rs|go|rb|java|vue|svelte)"; then
  if ! echo "$TRANSCRIPT" | grep -qiE "(test|vitest|jest|pytest|cargo test|go test|rspec|npm run test|pnpm test|yarn test)"; then
    echo "Du code source a ete modifie mais aucun test n'a ete execute. Lance les tests avant de terminer." >&2
    exit 2
  fi
fi

# ─────────────────────────────────────────────
# Gate 3 : Capitalisation obligatoire si changements significatifs
# ─────────────────────────────────────────────
SESSION_ID="${CLAUDE_SESSION_ID:-default}"
TRACK_FILE="/tmp/claude-session-changes-${SESSION_ID}.log"

if [ -f "$TRACK_FILE" ]; then
  # Compter les fichiers code modifies (pas json, md, config)
  CODE_CHANGES=$(grep -cE '\.(ts|tsx|js|jsx|py|rs|go|rb|java|vue|svelte)$' "$TRACK_FILE" 2>/dev/null || echo "0")

  if [ "$CODE_CHANGES" -ge 3 ]; then
    # Session significative : verifier si capitalisation a ete faite
    if ! echo "$TRANSCRIPT" | grep -qiE "(capitalisation|jeyant-capitalisation|lecons|convention ajout|pattern d[eé]couvert)"; then
      cat << 'STOP' >&2
Cette session a modifie ${CODE_CHANGES}+ fichiers code. Avant de terminer :

1. Invoque /jeyant-capitalisation pour sauvegarder les lecons apprises
   OU
2. Si rien de notable : dis explicitement "rien a capitaliser" pour que je te laisse terminer

La memoire du projet depend de cette etape.
STOP
      exit 2
    fi
  fi

  # Nettoyer le fichier de tracking
  rm -f "$TRACK_FILE" 2>/dev/null
fi

exit 0
