#!/bin/bash
# ==============================================================================
# HOOK : UserPromptSubmit — LE GARDIEN
# ==============================================================================
# Analyse chaque prompt utilisateur et injecte le pipeline obligatoire.
# Ce hook est le coeur du systeme d'enforcement.
#
# Exit 0 : toujours (ne bloque jamais le prompt, injecte du contexte)
# stdout : instructions injectees dans le contexte de l'agent
# ==============================================================================

set -euo pipefail

# Lire l'input depuis stdin (JSON avec user_prompt)
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // empty' 2>/dev/null)

# Si pas de prompt exploitable, laisser passer
if [ -z "$PROMPT" ]; then
  exit 0
fi

PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# ─────────────────────────────────────────────
# BYPASS : commandes slash explicites
# L'utilisateur sait ce qu'il fait
# ─────────────────────────────────────────────
if echo "$PROMPT" | grep -qE '^\s*/'; then
  exit 0
fi

# ─────────────────────────────────────────────
# BYPASS : questions et conversations
# Pas besoin du pipeline pour une question
# ─────────────────────────────────────────────
if echo "$PROMPT_LOWER" | grep -qE '^\s*(explique|comment |pourquoi |qu.est.ce|c.est quoi|montre|liste[^r]|affiche|aide|help|what |how |why |show |tell |describe|display)'; then
  cat << 'EOF'
[MODE INFORMATION] Reponds directement. Pas de pipeline obligatoire pour les questions.
Si ta reponse implique neanmoins une modification de code, applique le pipeline adapte.
EOF
  exit 0
fi

# ─────────────────────────────────────────────
# BYPASS : confirmations courtes
# ─────────────────────────────────────────────
if echo "$PROMPT_LOWER" | grep -qE '^\s*(oui|non|ok|yes|no|continue|go|d.accord|parfait|merci|valide|approved|confirm)'; then
  exit 0
fi

# ─────────────────────────────────────────────
# DETECTION : Fix / Bug / Debug
# ─────────────────────────────────────────────
if echo "$PROMPT_LOWER" | grep -qE '(fix[e ]|bug|erreur|crash|cass[eé]|broken|fail|regression|corrig|repar[e ]|probl[eè]me|issue[^r]|debug|fuite|leak|lent|slow|timeout|exception|stack.?trace|segfault|panic)'; then
  cat << 'EOF'
[PIPELINE OBLIGATOIRE — FIX/BUG]

1. INVOQUE /jeyant avec la description du probleme
2. Dans le cycle implement :
   - Utilise superpowers:systematic-debugging (root cause AVANT fix)
   - Utilise superpowers:test-driven-development (test qui reproduit le bug AVANT le fix)
3. Le hook Stop verifiera que les preuves sont satisfaites

RAPPELS :
- Ne propose PAS de fix sans avoir identifie la cause racine
- Le test doit ECHOUER avant le fix et REUSSIR apres
- Verifie que le fix n'introduit pas de vulnerabilite
EOF
  exit 0
fi

# ─────────────────────────────────────────────
# DETECTION : Refactoring
# ─────────────────────────────────────────────
if echo "$PROMPT_LOWER" | grep -qE '(refactor|restructur|reorganis|nettoyer|clean.?up|simplif|d[eé]placer|rename|migr[ea]|extraire|extract|d[eé]couper|split|fusionner|merge module|consolid)'; then
  cat << 'EOF'
[PIPELINE OBLIGATOIRE — REFACTORING]

0. CHALLENGE TECHNIQUE (AVANT tout code) :
   Pose-toi ces 3 questions et partage tes reponses a l'utilisateur :
   - "Ce refactoring est-il necessaire MAINTENANT, ou est-ce du perfectionnisme ?"
   - "Le code actuel cause-t-il un probleme concret (bugs, perf, lisibilite bloquante) ?"
   - "Le ratio effort/benefice est-il favorable ?"
   Si le refactoring n'est pas justifie, PROPOSE de ne pas le faire.

1. INVOQUE /jeyant avec la description du refactoring
2. jeyant-dev-guard verifiera les frontieres de module (MODE STRICT)
3. REGLE D'OR : ZERO changement de comportement
   - Les tests existants doivent passer IDENTIQUEMENT avant et apres
   - Si un test doit changer, ce n'est PAS un refactoring
4. Utilise superpowers:test-driven-development pour la non-regression
5. Le hook Stop verifiera que les preuves sont satisfaites

RAPPELS :
- Un refactoring qui change le comportement n'est pas un refactoring
- Verifie le nombre de tests avant/apres (doit etre >= identique)
- Pas de refactoring opportuniste hors scope
EOF
  exit 0
fi

# ─────────────────────────────────────────────
# DETECTION : Evolution / Feature / Creation
# ─────────────────────────────────────────────
if echo "$PROMPT_LOWER" | grep -qE '(ajout|cr[eé][eé]|impl[eé]ment|d[eé]velopp|feature|fonction|nouveau|nouvelle|construi|build[^-]|design[^-]|[eé]volut|am[eé]lior|int[eé]gr|connect|endpoint|route|page|composant|component|api |hook |service )'; then
  cat << 'EOF'
[PIPELINE OBLIGATOIRE — EVOLUTION/FEATURE]

0. CHALLENGE TECHNIQUE (AVANT tout code) :
   Pose-toi ces 3 questions et partage tes reponses a l'utilisateur :
   - "Est-ce que cette feature est reellement necessaire, ou un mecanisme existant suffit ?"
   - "Quelle est l'approche la plus SIMPLE qui resout le besoin ?"
   - "Quel est le risque principal si on fait ca (securite, dette, complexite) ?"
   Si une de ces questions revele un probleme, SIGNALE-LE avant de continuer.

1. INVOQUE /jeyant avec la description de la feature
2. jeyant determinera le tier (1 ou 2) et executera le pipeline complet
   - Tier 1 : cadrage -> dev-guard -> implement -> preuves
   - Tier 2 : cadrage -> brainstorm -> revue design -> plan -> dev-guard -> implement -> preuves -> revue code -> capitalisation
3. Dans le cycle implement :
   - Utilise superpowers:test-driven-development (RED -> GREEN -> REFACTOR)
4. Avant de terminer :
   - Utilise superpowers:requesting-code-review
5. Le hook Stop verifiera que les preuves sont satisfaites

RAPPELS :
- Pas de code sans test
- Pas de merge sans review
- Securite : valider les inputs, echapper les outputs
EOF
  exit 0
fi

# ─────────────────────────────────────────────
# DEFAUT : demande non classifiee impliquant potentiellement du code
# ─────────────────────────────────────────────
cat << 'EOF'
[PIPELINE PAR DEFAUT]

Cette demande peut impliquer du code. Evalue si un pipeline est necessaire :
1. Si modification de code → INVOQUE /jeyant avec la description
2. Si tu modifies du code, applique TDD (superpowers:test-driven-development)
3. Verifie la securite de tes modifications
4. Le hook Stop verifiera que les preuves sont satisfaites si /jeyant a ete utilise
EOF
exit 0
