# catalogue des types de preuve

| Type | Description | Quand l'utiliser |
|------|-------------|------------------|
| Tests unitaires | Fonctions isolees, logique metier | Toujours |
| Tests d'integration | Interactions entre composants | Si 2+ composants interagissent |
| Tests e2e | Parcours utilisateur complet | Features cross-module |
| Type checking | mypy/tsc — pas d'erreur de typage | Toujours |
| Build | Le projet compile/demarre | Toujours |
| Lint | Respect des regles de style | Toujours |
| Non-regression | Suite de tests existante passe | Toujours (obligatoire) |
| Contrat API | Schema OpenAPI/types respecte | Si endpoint API modifie |
| Securite | Pas de failles evidentes | Si auth, tokens, donnees sensibles |
| Performance ciblee | Benchmark d'une operation specifique | Si performance est un critere |
| Verification visuelle | UI correspond a l'attendu | Features frontend |

## regle de selection

Le contrat de preuve inclut au minimum :
- Tests unitaires
- Type checking
- Build
- Non-regression

Les autres types sont ajoutes selon le contexte de la tache.
