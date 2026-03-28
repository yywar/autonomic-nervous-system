# protocole de lecture des conventions

## ordre de lecture

1. `CLAUDE.md` (racine projet) → regles globales
2. `CLAUDE.md` (racine module, s'il existe) → regles specifiques au module
3. `docs/conventions/backend.md` ou `docs/conventions/frontend.md` → patterns techniques
4. `docs/conventions/anti-patterns.md` → ce qui est interdit
5. `docs/architecture/modules/[module].md` → contrat du module (responsabilite, dependances, interfaces)

## quoi extraire

Pour chaque fichier lu, extraire :

### Nommage
- Comment sont nommes les fichiers, fonctions, classes, variables
- Ex : "les services sont en snake_case, les classes en PascalCase"

### Structure
- Comment les fichiers sont organises dans le module
- Ex : "router.py → service.py → repository.py"

### Imports
- Quels imports sont standard dans ce module
- Ex : "from app.core.deps import get_current_user"

### Gestion d'erreur
- Comment les erreurs sont gerees
- Ex : "raise HTTPException(status_code=..., detail=...)"

### Tests
- Comment les tests sont structures
- Ex : "un fichier test_ par fichier source, fixtures dans conftest.py"

### Anti-patterns
- Ce qui est explicitement interdit
- Ex : "ne jamais importer directement depuis un autre module — passer par les interfaces"

## si un fichier n'existe pas

- Ne pas bloquer
- Signaler le fichier manquant
- Compenser par pattern discovery (grep le module pour deduire les conventions)
