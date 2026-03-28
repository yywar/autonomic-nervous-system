# package de revue

L'agent de revue independant DOIT recevoir ces pieces :

| Piece | Pourquoi | Obligatoire |
|-------|----------|-------------|
| Cadrage formalise | Comprendre l'intention | Oui |
| Contrat de preuve | Savoir ce qui devait etre verifie | Oui |
| ADR (si applicable) | Comprendre le choix architectural | Si Tier 2 |
| Diff complet | Voir ce qui a ete produit | Oui |
| Resultats des preuves | Savoir ce qui a ete verifie | Oui |
| Conventions du module | Les regles a respecter | Oui |

## comment transmettre

Le pilote constitue le package en incluant :
- Le contenu du cadrage
- Le contrat de preuve
- `git diff` complet
- Le rapport de preuves
- Reference aux fichiers de conventions

L'agent de revue lit ces pieces AVANT de commencer sa revue.

## sans package

Si invoque en standalone (`/jeyant-revue-adverse`), l'agent :
1. Lit le diff actuel (`git diff HEAD~1` ou le diff stage)
2. Lit le CLAUDE.md et les conventions
3. Fait une revue technique (scope code) sans cadrage
4. Signale qu'il n'a pas l'intention originale → revue limitee a la technique
