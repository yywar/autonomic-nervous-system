# exemple end-to-end — Tier 1 : ajouter GET /users/me/profile

## 1. demande utilisateur

```
/jeyant "ajoute un endpoint GET /users/me/profile qui retourne les infos du profil"
```

## 2. pilote — lecture de l'etat

```
📖 docs/state/PROJECT-STATE.md
  → Module users : en cours, 60%, derniere session 2026-03-17
📖 docs/state/SESSION-LOG.md
  → Aucune regression recente sur module users
📖 docs/state/modules/users.md
  → Implemente : CRUD utilisateurs, list, search
  → Patterns : router → service → repository, Pydantic models
```

## 3. pilote → cadrage

Le pilote execute jeyant-cadrage :

```
CADRAGE :
  Besoin : endpoint GET /users/me/profile retournant le profil utilisateur connecte
  Perimetre : module users uniquement
  Hors perimetre : modification profil, upload photo, cache

TIER : 1 — un seul module, patterns existants, read-only simple

CONTRAT DE PREUVE :
  - Test success : GET /users/me/profile → 200 + ProfileResponse
  - Test unauthorized : GET /users/me/profile sans token → 401
  - mypy clean
  - Non-regression : pytest tests/users/ — tous passent
  - Build passe

MODE EXECUTION : single-agent
```

## 4. pilote → presentation et validation

```
→ L'utilisateur voit le cadrage ci-dessus
→ L'utilisateur repond : "ok" (ou ajuste)
→ Validation ✓
```

## 5. pilote → execution Tier 1

### 5a. dev-guard

```
PRE-FLIGHT :
  git status → propre ✓
  pytest tests/users/ → 5 passed ✓ (baseline)
  mypy backend/modules/users/ → clean ✓

CONVENTIONS :
  CLAUDE.md → FastAPI + SQLAlchemy + Pydantic v2
  conventions/backend.md → router → service → repository
  anti-patterns.md → pas d'ORM en retour, pas d'import cross-module
  architecture/modules/users.md → CRUD, profil, expose UserResponse

FRONTIERES :
  Fichiers prevus : router.py (modifier), service.py (modifier), schemas/profile.py (creer), test_profile.py (creer)
  Tous dans module users → OK

STATUT : FEU VERT
```

### 5b. implementation

L'agent implemente en suivant les patterns detectes :

```python
# backend/modules/users/schemas/profile.py
from pydantic import BaseModel
from datetime import datetime

class ProfileResponse(BaseModel):
    id: int
    email: str
    name: str
    created_at: datetime

    class Config:
        from_attributes = True
```

```python
# ajout dans backend/modules/users/service.py
async def get_profile(user_id: int, db: AsyncSession) -> User:
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
```

```python
# ajout dans backend/modules/users/router.py
@router.get("/me/profile", response_model=ProfileResponse)
async def get_my_profile(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    return await user_service.get_profile(current_user.id, db)
```

```python
# tests/users/test_profile.py
import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_get_profile_success(client: AsyncClient, auth_headers: dict):
    response = await client.get("/users/me/profile", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert "email" in data
    assert "name" in data
    assert "created_at" in data

@pytest.mark.asyncio
async def test_get_profile_unauthorized(client: AsyncClient):
    response = await client.get("/users/me/profile")
    assert response.status_code == 401
```

### 5c. preuves (phase 2)

```
1. TYPES
   $ mypy backend/modules/users/
   Success: no issues found in 5 source files
   → DEMONSTREE

2. LINT
   $ ruff check backend/modules/users/
   All checks passed!
   → DEMONSTREE

3. BUILD
   $ python -c "from backend.modules.users import router"
   → DEMONSTREE

4. TESTS NOUVEAUX
   $ pytest tests/users/test_profile.py -v
   test_get_profile_success PASSED
   test_get_profile_unauthorized PASSED
   → DEMONSTREE (2/2)

5. NON-REGRESSION
   $ pytest tests/users/ -v
   7 passed in 0.9s (baseline 5 + 2 nouveaux)
   → DEMONSTREE
```

**Verdict preuves : PASS**

## 6. pilote → mise a jour memoire

```
📝 docs/state/PROJECT-STATE.md
  → Module users : 65% (etait 60%)

📝 docs/state/modules/users.md
  → Ajoute : ✅ GET /users/me/profile (endpoint + service + tests)

📝 docs/state/CHANGELOG.md
  → 2026-03-18 | users | profil endpoint | GET /users/me/profile

📝 docs/state/SESSION-LOG.md
  → 2026-03-18 | users | profil | T1 | ✅ | —
```

## 7. pilote → verdict final

```
STATUT : PRET

DEMONTRE :
  - Endpoint retourne 200 avec profil (test)
  - Endpoint retourne 401 sans auth (test)
  - Types clean, build OK, non-regression OK

INFERE :
  (rien)

NON VERIFIE :
  (rien — tache simple, tout est couvert)

RESERVES :
  (aucune)

PROCHAINE ACTION : prochaine tache du backlog
```
