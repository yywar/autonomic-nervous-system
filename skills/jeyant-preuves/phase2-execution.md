# phase 2 — execution des preuves

## ordre d'execution

1. **Types** (mypy/tsc) — rapide, detecte les erreurs structurelles
2. **Lint** — rapide, detecte les problemes de style
3. **Build** — verifie que tout compile
4. **Tests unitaires nouveaux** — verifie le code ecrit
5. **Non-regression module** — verifie que rien n'est casse
6. **Non-regression modules impactes** — verifie les effets de bord
7. **Tests d'integration** (si applicable)
8. **Tests e2e** (si applicable)
9. **Verifications manuelles** (securite, performance, visuel)

## pour chaque preuve

1. Executer la commande/verification
2. Capturer le resultat (succes/echec + output)
3. Classifier selon le modele de classification
4. Si echec → declencher le protocole de retry

## arret immediat si

- Non-regression echoue (tests existants casses)
- Build echoue
- Un test de securite critique echoue

Ne PAS continuer les preuves suivantes — corriger d'abord.
