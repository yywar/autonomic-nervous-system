# pattern discovery

## quand l'activer

- Tier 2 (toujours)
- Tier 1 si les conventions documentees sont absentes ou incompletes

## methode

1. Lister les fichiers du module
2. Pour chaque type de pattern, grep :

### Structure de fichier
```bash
# Quels fichiers existent dans le module ?
ls -la [module_path]/
# Y a-t-il un pattern ? (router, service, repository, model, schema, test)
```

### Imports recurrents
```bash
# Quels imports apparaissent dans 3+ fichiers ?
grep -rn "^from\|^import" [module_path]/ | sort | uniq -c | sort -rn | head -20
```

### Gestion d'erreur
```bash
# Comment les erreurs sont-elles gerees ?
grep -rn "raise\|except\|HTTPException\|AppError" [module_path]/
```

### Patterns de retour
```bash
# Que retournent les fonctions/endpoints ?
grep -rn "return\|-> " [module_path]/ | head -20
```

### Patterns de test
```bash
# Comment les tests sont-ils structures ?
ls tests/[module]/
grep -rn "def test_\|class Test" tests/[module]/
```

## seuil

Un pattern est "etabli" s'il apparait dans **3+ fichiers** du module.

## sortie

```markdown
### Patterns detectes (non documentes)
- [pattern 1 — ex: "tous les endpoints utilisent Depends(get_current_user)"]
- [pattern 2 — ex: "tous les services retournent des Pydantic models"]

### Proposition de documentation
Ces patterns devraient etre ajoutes a `docs/conventions/[backend|frontend].md`
```

## regle

Les patterns decouverts servent de guide pour l'implementation MEME s'ils ne sont pas documentes. L'agent suit ce que le code existant fait, pas ce qu'il invente.
