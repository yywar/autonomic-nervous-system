# exemple — preuves avec echec et retry

## contexte

Tache : ajouter endpoint POST /auth/reset-request
Le code a ete implemente. On execute les preuves.

## phase 2 — execution

### 1. Types

```bash
$ mypy backend/modules/auth/
backend/modules/auth/service.py:45: error: Argument "purpose" to "create_jwt" has incompatible type "str"; expected "TokenPurpose"
Found 1 error in 1 source file
```
→ CONTREDITE — type error

### declenchement retry (tentative 1)

**Analyse** : le service passe "reset" comme string au lieu de l'enum TokenPurpose.RESET.

**Correction** :
```python
# avant
token = create_jwt(user_id=user.id, purpose="reset", ttl=900)
# apres
token = create_jwt(user_id=user.id, purpose=TokenPurpose.RESET, ttl=900)
```

**Re-execution types** :
```bash
$ mypy backend/modules/auth/
Success: no issues found in 8 source files
```
→ DEMONSTREE apres correction

### 2. Lint

```bash
$ ruff check backend/modules/auth/
All checks passed!
```
→ DEMONSTREE

### 3. Build

```bash
$ python -c "from backend.modules.auth import router"
```
→ DEMONSTREE

### 4. Tests nouveaux

```bash
$ pytest tests/auth/test_reset.py -v
tests/auth/test_reset.py::test_reset_request_success PASSED
tests/auth/test_reset.py::test_reset_request_unknown_email PASSED
tests/auth/test_reset.py::test_reset_confirm_success FAILED
3 passed, 1 failed in 1.2s

FAILED tests/auth/test_reset.py::test_reset_confirm_success
  AssertionError: assert 500 == 200
  E   Response body: {"detail": "Internal Server Error"}
```
→ CONTREDITE — test confirm echoue (500 au lieu de 200)

### declenchement retry (tentative 2)

**Analyse** : le endpoint reset-confirm retourne 500. En lisant les logs :
```
sqlalchemy.exc.IntegrityError: password_hash cannot be null
```
Le service ne hashe pas le nouveau mot de passe avant de l'enregistrer.

**Correction** :
```python
# avant
user.password_hash = new_password
# apres
user.password_hash = hash_password(new_password)
```

**Re-execution TOUTES les preuves** :
```bash
$ mypy backend/modules/auth/
Success: no issues found in 8 source files

$ pytest tests/auth/test_reset.py -v
tests/auth/test_reset.py::test_reset_request_success PASSED
tests/auth/test_reset.py::test_reset_request_unknown_email PASSED
tests/auth/test_reset.py::test_reset_confirm_success PASSED
tests/auth/test_reset.py::test_reset_confirm_expired PASSED
4 passed in 1.1s
```
→ DEMONSTREE apres correction

### 5. Non-regression

```bash
$ pytest tests/auth/ -v
... (12 tests existants)
tests/auth/test_reset.py::test_reset_request_success PASSED
tests/auth/test_reset.py::test_reset_request_unknown_email PASSED
tests/auth/test_reset.py::test_reset_confirm_success PASSED
tests/auth/test_reset.py::test_reset_confirm_expired PASSED
16 passed in 2.3s
```
→ DEMONSTREE (16 tests, 0 echec, baseline 12 + 4 nouveaux)

## rapport de preuves

```markdown
## Rapport de preuves

### Demonstrees
- [x] test_reset_request_success — pytest → PASSED
- [x] test_reset_request_unknown_email — pytest → PASSED
- [x] test_reset_confirm_success — pytest → PASSED (apres retry 2)
- [x] test_reset_confirm_expired — pytest → PASSED
- [x] mypy clean — 0 erreur (apres retry 1)
- [x] lint clean — ruff passe
- [x] build OK

### Probables
(aucune)

### Non verifiees
(aucune)

### Contredites (corrigees)
- [!→x] mypy type error (TokenPurpose) — corrige tentative 1
- [!→x] test_reset_confirm 500 error (password non hashe) — corrige tentative 2

### Non-regression
- [x] Suite tests module auth : 16/16 PASS (baseline 12 + 4 nouveaux)
- [x] Build : PASS
- [x] Types : CLEAN

### Verdict preuves
PASS AVEC RESERVES

### Reserves
- 2 corrections necessaires (type error + password hash) — les deux sont corrigees
  mais indiquent un manque de rigueur dans l'implementation initiale.
  → Capitalisation : le service doit toujours utiliser les enums types au lieu de strings,
    et le hashing de password doit etre verifie dans le contrat de preuve initial.
```
