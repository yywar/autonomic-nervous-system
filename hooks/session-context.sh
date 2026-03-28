#!/bin/bash
# ==============================================================================
# HOOK : SessionStart — INJECTION DE CONTEXTE + MEMOIRE PROJET
# ==============================================================================
# Injecte le contexte obligatoire ET l'etat du projet au demarrage
# de chaque session et apres chaque compaction de contexte.
#
# Exit 0 : toujours
# stdout : contexte injecte dans la session
# ==============================================================================

set -euo pipefail

# ─────────────────────────────────────────────
# 1. Regles du systeme (toujours injectees)
# ─────────────────────────────────────────────
cat << 'EOF'
[SYSTEME DE QUALITE ACTIF]

Tu travailles dans un environnement equipe du Systeme Nerveux Autonome.
Chaque demande de code passe par un pipeline de qualite obligatoire.

REGLES NON-NEGOCIABLES :
- Pas de code sans test (TDD : red -> green -> refactor)
- Pas de fix sans root cause (systematic-debugging)
- Pas de merge sans review
- Pas de secrets dans le code
- Pas de modification hors module sans justification

PIPELINE : Le hook UserPromptSubmit t'indiquera le pipeline a suivre.
SECURITE : Les hooks PreToolUse bloqueront les patterns dangereux.
VERIFICATION : Le hook Stop verifiera que le travail est complet.

Si /jeyant est invoque, suis le pipeline jeyant integralement.
Si superpowers:test-driven-development est requis, respecte le cycle RED -> GREEN -> REFACTOR.
Si superpowers:systematic-debugging est requis, trouve la cause racine AVANT de proposer un fix.
EOF

# ─────────────────────────────────────────────
# 2. Memoire projet (injectee si disponible)
# ─────────────────────────────────────────────
# Detecter le repertoire du projet (variable fournie par Claude Code ou pwd)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Injecter l'etat du projet s'il existe
STATE_DIR="$PROJECT_DIR/docs/state"
if [ -d "$STATE_DIR" ]; then
  echo ""
  echo "[MEMOIRE PROJET — ETAT ACTUEL]"

  # Derniere session
  if [ -f "$STATE_DIR/session-log.md" ]; then
    echo ""
    echo "--- Derniere session ---"
    tail -30 "$STATE_DIR/session-log.md" 2>/dev/null
  fi

  # Backlog
  if [ -f "$STATE_DIR/backlog.md" ]; then
    echo ""
    echo "--- Backlog actif ---"
    head -30 "$STATE_DIR/backlog.md" 2>/dev/null
  fi
fi

# Injecter les decisions architecturales recentes
DECISIONS_DIR="$PROJECT_DIR/docs/decisions"
if [ -d "$DECISIONS_DIR" ]; then
  RECENT_ADRS=$(find "$DECISIONS_DIR" -name "*.md" -mtime -14 2>/dev/null | sort -r | head -3)
  if [ -n "$RECENT_ADRS" ]; then
    echo ""
    echo "[DECISIONS RECENTES (< 14 jours)]"
    for adr in $RECENT_ADRS; do
      echo "- $(basename "$adr"): $(head -1 "$adr" 2>/dev/null | sed 's/^#\+\s*//')"
    done
  fi
fi

# Injecter les conventions
CONV_DIR="$PROJECT_DIR/docs/conventions"
if [ -d "$CONV_DIR" ]; then
  CONV_COUNT=$(find "$CONV_DIR" -name "*.md" 2>/dev/null | wc -l)
  if [ "$CONV_COUNT" -gt 0 ]; then
    echo ""
    echo "[CONVENTIONS PROJET : $CONV_COUNT fichier(s) dans docs/conventions/]"
    echo "Lis-les via jeyant-dev-guard avant toute implementation."
  fi
fi

# Injecter la carte des modules
if [ -f "$PROJECT_DIR/docs/architecture/MODULE-MAP.md" ]; then
  echo ""
  echo "[CARTE DES MODULES disponible : docs/architecture/MODULE-MAP.md]"
  echo "Consulte-la avant de modifier des fichiers cross-module."
fi

# ─────────────────────────────────────────────
# 3. Capitalisation Tier 1 — rappel
# ─────────────────────────────────────────────
echo ""
echo "[RAPPEL] En fin de session, si des lecons utiles ont ete apprises,"
echo "invoque /jeyant-capitalisation meme sur les taches Tier 1."

exit 0
