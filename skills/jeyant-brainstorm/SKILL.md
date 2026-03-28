---
name: jeyant-brainstorm
description: Exploration profonde en 7 phases avant toute decision structurante. Recherche, contraintes, 3+ approches (conservatrice, structuree, inattendue), analyse multi-axe avec simulation agentic, modes d'echec, recommandation arborescente et ADR draft. Declenchement Tier 2 uniquement ou en standalone.
---

# role

Tu explores en profondeur AVANT de decider. Pas de reflexion superficielle, pas de premiere idee.

## declenchement

- Automatique en Tier 2 (apres cadrage)
- Standalone via `/jeyant-brainstorm "sujet"`

## les 7 phases

### phase 1 — recherche

AVANT de proposer quoi que ce soit, collecter :

| Source | Action |
|--------|--------|
| Code existant | Grep : comment des problemes similaires ont ete resolus |
| ADRs | `docs/decisions/` — decisions passees qui contraignent |
| Conventions | `docs/conventions/` — patterns obligatoires et interdits |
| Etat module | `docs/state/modules/` — ce qui existe, ce qui est prevu |
| Doc externe | Best practices de la stack si pertinent |

Sortie : brief de contexte ("voila ce qui existe, ce qui contraint, ce qu'on sait").

### phase 2 — cartographie des contraintes

Voir `constraint-mapping.md`.

Distinguer :
- Contraintes dures (non negociables)
- Contraintes souples (preferees mais negociables)
- Inconnues (a trancher — chacune est un risque)

### phase 3 — exploration large

Voir `exploration-rules.md`.

Minimum 3 approches :
- La conservatrice — reutilise au maximum l'existant
- La structuree — la "bonne" solution architecturale
- L'inattendue — approche non evidente, forcer la creativite

Chaque approche DOIT avoir une esquisse d'implementation (fichiers, patterns, modules).

### phase 4 — analyse multi-axe

Voir `analysis-axes.md`.

3 axes :
1. Technique (complexite, testabilite, coherence, securite, performance)
2. Agentic-friendliness (isolation module, pattern existant, taille contexte, risque divergence, verifiabilite)
3. Effets de bord et futur (impact modules, dette, features futures, reversibilite)

### phase 5 — simulation agentic

Voir `agentic-simulation.md`.

Pour chaque approche, simuler :
- Ce que l'agent devra lire / creer / modifier
- Le pattern a suivre (existe ou non)
- Le risque de divergence
- La projection a 6 mois (le pattern sera-t-il toujours clair ?)

### phase 6 — modes d'echec

Voir `failure-modes.md`.

Pour chaque approche, 4 types d'echec :
- Technique (comment ca casse)
- Agentic (comment un agent futur pourrait mal l'utiliser)
- A l'echelle (que se passe-t-il si volume/taille explose)
- Operationnel (que se passe-t-il si un service est down)

### phase 7 — recommandation + ADR

Voir `recommendation-pattern.md` et `adr-template.md`.

- Arbre de decision (pas un choix plat)
- Rejet argumente des alternatives
- Si decision structurante → ADR draft

## interdictions

- Proposer une seule approche
- Proposer des approches sans esquisse d'implementation
- Recommander sans argumenter les rejets
- Ignorer l'axe agentic-friendliness
- Produire un brainstorm "contemplatif" sans decision

## ressources

- `research-protocol.md`
- `constraint-mapping.md`
- `exploration-rules.md`
- `analysis-axes.md`
- `agentic-simulation.md`
- `failure-modes.md`
- `recommendation-pattern.md`
- `adr-template.md`
