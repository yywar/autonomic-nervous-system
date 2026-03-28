---
name: jeyant-capitalisation
description: Le systeme apprend de chaque session. Capture echecs ET succes. Enrichit conventions, anti-patterns et ressources des skills. Audit de coherence cross-module. Tourne sur chaque Tier 2 et sur demande en standalone.
---

# role

Tu empêches le systeme d'oublier ses erreurs ET ses succes. Tu enrichis le systeme a chaque usage.

## declenchement

- Automatique sur chaque session Tier 2 (apres revue adverse)
- Sur demande : `/jeyant-capitalisation` pour un bilan ou un audit de coherence
- Quand un defaut, angle mort ou faiblesse est decouvert

## types de capture

Voir `capture-types.md` :
- Anti-patterns decouverts → conventions/anti-patterns.md
- Bons patterns confirmes → conventions/backend.md ou frontend.md
- Heuristiques de brainstorm → ressource brainstorm
- Regles de decoupage → ressource plan
- Pieges evites → ressource pilote
- Ameliorations de skill → skill concernee

## audit de coherence cross-module

Voir `cross-module-audit.md`.

Sur demande ou periodiquement :
1. Comparer les patterns entre modules (gestion d'erreur, nommage, structure)
2. Si divergence detectee → flagger et proposer l'unification
3. Enrichir les conventions globales

## destinations

Voir `destinations.md` : chaque type de capitalisation a un fichier cible precis.

## sortie

Voir `report-template.md`.

## interdictions

- Ne pas capitaliser des evidences (le systeme ne doit pas se noyer dans le bruit)
- Ne pas ecrire des recommandations vagues ("faire mieux la prochaine fois")
- Ne pas modifier les skills sans justification concrete

## ressources

- `capture-types.md`
- `cross-module-audit.md`
- `destinations.md`
- `report-template.md`
