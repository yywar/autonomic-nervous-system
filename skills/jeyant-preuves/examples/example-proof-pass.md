# exemple — preuves passantes (GET /users/me/profile)

## phase 1 — contrat de preuve (defini au cadrage)

```markdown
### Nouvelles preuves
- [ ] pytest tests/users/test_profile.py::test_get_profile_success
- [ ] pytest tests/users/test_profile.py::test_get_profile_unauthorized

### Types / lint
- [ ] mypy backend/modules/users/ — clean

### Build
- [ ] python -c "from backend.modules.users import router"

### Non-regression
- [ ] pytest tests/users/ — TOUS passent (baseline : 5 tests)
```

## phase 2 — execution (apres implementation)

### 1. Types

```bash
$ mypy backend/modules/users/
Success: no issues found in 5 source files
```
→ DEMONSTREE

### 2. Lint

```bash
$ ruff check backend/modules/users/
All checks passed!
```
→ DEMONSTREE

### 3. Build

```bash
$ python -c "from backend.modules.users import router"
```
→ DEMONSTREE (pas d'erreur)

### 4. Tests nouveaux

```bash
$ pytest tests/users/test_profile.py -v
tests/users/test_profile.py::test_get_profile_success PASSED
tests/users/test_profile.py::test_get_profile_unauthorized PASSED
2 passed in 0.3s
```
→ DEMONSTREE (2/2)

### 5. Non-regression

```bash
$ pytest tests/users/ -v
tests/users/test_create_user.py::test_create_success PASSED
tests/users/test_create_user.py::test_create_duplicate PASSED
tests/users/test_list_users.py::test_list_all PASSED
tests/users/test_list_users.py::test_list_paginated PASSED
tests/users/test_list_users.py::test_list_unauthorized PASSED
tests/users/test_profile.py::test_get_profile_success PASSED
tests/users/test_profile.py::test_get_profile_unauthorized PASSED
7 passed in 0.9s
```
→ DEMONSTREE (7 tests, 0 echec, baseline etait 5 → +2 nouveaux)

## rapport de preuves

```markdown
## Rapport de preuves

### Demonstrees
- [x] test_get_profile_success — pytest → PASSED
- [x] test_get_profile_unauthorized — pytest → PASSED
- [x] mypy clean — 0 erreur sur 5 fichiers
- [x] lint clean — ruff passe
- [x] build OK — import sans erreur

### Probables
(aucune)

### Non verifiees
(aucune)

### Contredites
(aucune)

### Non-regression
- [x] Suite tests module users : 7/7 PASS (baseline 5 + 2 nouveaux)
- [x] Build : PASS
- [x] Types : CLEAN

### Verdict preuves
PASS
```
