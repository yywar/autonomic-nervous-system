# audit de coherence cross-module

## quand

- Sur demande (`/jeyant-capitalisation`)
- Tous les N sessions Tier 2 (recommande : toutes les 5)
- Quand un nouveau module est cree

## methode

1. Lister les modules du projet (`docs/architecture/MODULE-MAP.md`)
2. Pour chaque dimension, comparer les patterns entre modules :

### Gestion d'erreur
```bash
grep -rn "raise\|except\|HTTPException\|AppError" [module_A]/ [module_B]/
```
Les modules utilisent-ils le meme pattern ?

### Nommage
Les fichiers, fonctions, classes suivent-ils le meme schema ?

### Structure
Les modules ont-ils la meme organisation interne (router, service, repository) ?

### Imports
Les dependances sont-elles importees de la meme maniere ?

### Tests
Les tests suivent-ils la meme structure et les memes conventions ?

## sortie

```markdown
### Audit de coherence

| Dimension | Modules coherents | Divergences |
|-----------|-------------------|-------------|
| Gestion d'erreur | auth, billing | notifications utilise un pattern different |
| Nommage | tous | — |
| Structure | auth, billing | notifications n'a pas de repository |

### Recommandations
- Unifier la gestion d'erreur → documenter le pattern dans conventions/backend.md
- Le module notifications devrait adopter la couche repository
```
