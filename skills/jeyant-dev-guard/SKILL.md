---
name: jeyant-dev-guard
description: Garde-fou avant toute implementation. Pre-flight (git, build, tests), lecture des conventions, pattern discovery, verification des frontieres de module. Garantit que l'agent code dans un cadre contraint. Skill interne du pilote jeyant.
---

# role

Tu empêches l'agent de coder dans le vide. Avant de toucher une ligne de code, l'agent doit passer par toi.

## protocole

### 1. pre-flight (obligatoire)

Voir `preflight-checklist.md`.

Executer dans l'ordre :
1. `git status` → l'arbre de travail est propre ?
2. Executer les tests du module → passent ?
3. Verifier le build → OK ?
4. Si ECHEC → signaler et demander avant de continuer

Le pre-flight etablit la **baseline**. Tout ce qui casse apres est de la responsabilite de l'agent.

### 2. lecture des conventions (obligatoire)

Voir `convention-reading-protocol.md`.

Lire dans l'ordre :
1. `CLAUDE.md` a la racine du projet
2. `CLAUDE.md` du module (s'il existe)
3. `docs/conventions/backend.md` ou `docs/conventions/frontend.md` selon le contexte
4. `docs/conventions/anti-patterns.md`
5. `docs/architecture/modules/[module].md` (contrat du module)

Extraire :
- Patterns de nommage
- Structure de fichiers
- Patterns d'import
- Gestion d'erreur
- Patterns de test
- Anti-patterns interdits

### 3. pattern discovery (Tier 2 ou si conventions manquantes)

Voir `pattern-discovery.md`.

Si les conventions sont incompletes :
1. Grep le module pour les patterns recurrents
2. Si un pattern apparait 3+ fois sans etre documente → noter
3. Utiliser ces patterns comme guide pour l'implementation
4. En fin de session, proposer de les documenter

### 4. verification des frontieres (obligatoire)

Voir `boundary-check.md`.

1. Lire `docs/architecture/MODULE-MAP.md`
2. Identifier le module cible
3. Lister les fichiers qui seront touches par la tache
4. Si un fichier est HORS module → REFUSER sauf justification explicite
5. Si une interface partagee est modifiee → signaler (impact cross-module potentiel)

## calibrage par tier

| Etape | Tier 1 | Tier 2 |
|-------|--------|--------|
| Pre-flight | Oui | Oui |
| Conventions | Oui | Oui |
| Pattern discovery | Non (sauf conventions absentes) | Oui |
| Frontieres | Oui | Oui |

## sortie

- Baseline etablie (etat pre-flight)
- Conventions actives listees
- Patterns detectes (si discovery)
- Frontieres verifiees
- Feu vert ou blocage + raison

## ressources

- `preflight-checklist.md`
- `convention-reading-protocol.md`
- `pattern-discovery.md`
- `boundary-check.md`
