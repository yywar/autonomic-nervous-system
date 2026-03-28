# exemple — session dev-guard sur module auth (FastAPI)

## contexte

Tache : ajouter l'endpoint GET /users/me/profile dans le module users.
Tier : 1

## 1. pre-flight

```bash
$ git status
On branch main
nothing to commit, working tree clean
→ OK

$ pytest tests/users/ -q
5 passed in 0.8s
→ OK — baseline : 5 tests passent

$ python -c "from backend.modules.users import router"
→ OK — import clean

$ mypy backend/modules/users/
Success: no issues found in 4 source files
→ OK
```

**Baseline etablie** : git propre, 5 tests passent, build OK, types clean.

## 2. lecture des conventions

### CLAUDE.md racine
```
- Stack : FastAPI + SQLAlchemy + Pydantic v2
- Pattern backend : router → service → repository
- Tests : pytest + httpx AsyncClient
- Auth : JWT via Depends(get_current_user)
```

### docs/conventions/backend.md
```
- Endpoints dans router.py, logique dans service.py, DB dans repository.py
- Tous les endpoints retournent des Pydantic models (pas de dict)
- Gestion d'erreur : raise HTTPException(status_code=..., detail=...)
- Nommage : snake_case pour fichiers et fonctions, PascalCase pour classes
- Chaque endpoint a un decorator @router.get/post/put/delete avec response_model
```

### docs/conventions/anti-patterns.md
```
- Ne jamais importer directement depuis un autre module — passer par les interfaces
- Ne jamais retourner un ORM model directement — toujours convertir en Pydantic
- Ne jamais hardcoder des valeurs de config — utiliser settings
```

### docs/architecture/modules/users.md
```
Responsabilite : gestion des utilisateurs (CRUD, profil)
Expose : UserResponse, get_current_user
Depend de : database
Ne doit PAS dependre de : auth (sens inverse), billing, notifications
```

**Conventions extraites** :
- Pattern : router → service → repository
- Retour : Pydantic model obligatoire
- Auth : Depends(get_current_user)
- Nommage : snake_case / PascalCase
- Anti-patterns : pas d'import cross-module direct, pas d'ORM en retour

## 3. pattern discovery (non active — Tier 1 avec conventions presentes)

Skip — les conventions sont completes.

## 4. verification des frontieres

```
MODULE-MAP → module cible : users
Fichiers prevus :
  - Modifier : backend/modules/users/router.py (ajouter endpoint)
  - Creer : backend/modules/users/schemas/profile.py (schema reponse)
  - Modifier : backend/modules/users/service.py (ajouter get_profile)
  - Creer : tests/users/test_profile.py

Verification :
  - Tous dans le module users → OK
  - Aucun fichier hors module → OK
  - Aucune interface partagee modifiee → OK
```

**Feu vert** : toutes les verifications passent.

## resume dev-guard

```
PRE-FLIGHT : OK (git propre, 5 tests passent, build OK, types clean)
CONVENTIONS : lues et extraites (6 regles + 3 anti-patterns)
FRONTIERES : verifiees (4 fichiers, tous dans module users)
PATTERNS DECOUVERTS : N/A (Tier 1)
STATUT : FEU VERT
```
