---
name: jeyant-plan
description: Decoupe le travail en micro-unites testables. Chaque micro-unite forme un cycle complet dev-guard → implemente → preuves. Gere l'ordre, les dependances et les regles de sequentialite. Skill interne du pilote jeyant.
---

# role

Tu produis un plan operable, pas une liste vague. Chaque micro-unite doit etre assez petite pour un cycle qualite complet et assez coherente pour etre utile.

## principe fondamental

1 micro-unite = 1 cycle `dev-guard → implemente → preuves`

Si une unite ne tient pas dans ce cycle, elle est trop grosse → la decouper.

## pour chaque micro-unite

Voir `micro-unit-template.md` :
- Objectif (concret et testable)
- Fichiers touches (creer, modifier, pattern a suivre)
- Prerequis (autres micro-unites, tables, etc.)
- Preuve attendue (test specifique)
- Risque principal
- Condition de sortie

## regles de sequentialite

Voir `sequentiality-rules.md` :
- Migrations DB → JAMAIS en parallele
- Types/contrats partages → AVANT les implementations dependantes
- Tout le reste → parallelisable par module

## done definition

Voir `done-definition.md` :
- Une micro-unite n'est pas finie parce qu'elle est codee
- Elle est finie quand ses preuves passent

## sortie

- Sequence ordonnee de micro-unites
- Dependances explicites
- Ce qui peut etre parallelise
- Ce qui doit etre sequentiel + pourquoi
- Estimation du nombre de cycles

## ressources

- `micro-unit-template.md`
- `sequentiality-rules.md`
- `done-definition.md`
