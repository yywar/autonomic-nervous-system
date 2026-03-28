# exemple — Tier 1 : ajouter un endpoint GET /users/me/profile

## demande utilisateur

"ajoute un endpoint GET /users/me/profile qui retourne les infos du profil de l'utilisateur connecte"

## etape 1 — analyse

- Demande explicite : endpoint GET qui retourne le profil
- Attente implicite : utiliser le middleware d'auth existant, meme format que les autres endpoints
- Type de livrable : code backend (endpoint + service + test)
- Niveau d'enjeu : faible — c'est un read-only dans un module existant
- Risque de malentendu : faible — la demande est claire
- Impact radius : module `users` uniquement, pas de contrat partage modifie

Signaux Tier 2 : aucun. Un seul module, patterns existants, pas de nouvelle architecture.

→ **Tier 1 recommande**

## etape 2 — contrat de besoin

### Objectif reel
Permettre au frontend d'afficher les informations du profil de l'utilisateur connecte.

### Perimetre
- Endpoint GET /users/me/profile dans le module `users`
- Service qui recupere le profil depuis la DB
- Schema de reponse Pydantic
- Test unitaire de l'endpoint

### Hors perimetre
- Modification du profil (c'est un GET read-only)
- Upload de photo de profil
- Cache du profil

### Hypotheses
- Le modele User existe deja en DB avec les champs necessaires (email, name, created_at)
- Le middleware JWT est deja en place (Depends(get_current_user))

### Criteres d'acceptation
- [ ] GET /users/me/profile retourne 200 avec les infos du profil quand le token est valide
- [ ] GET /users/me/profile retourne 401 sans token
- [ ] La reponse suit le schema ProfileResponse

### Impact radius
- Modules : users uniquement
- Contrats/types modifies : aucun (nouveau schema, pas de modification)
- Effets de bord : aucun identifie

## etape 3 — expansion proactive

Niveau 1 (completion utile) :
- Ajouter le schema ProfileResponse aux exports du module users
- Le endpoint doit suivre le meme pattern que les autres endpoints du module (router → service → repository)

Pas d'expansion supplementaire — la tache est simple et bornee.

## etape 4 — contrat de preuve

### Nouvelles preuves
- [ ] pytest tests/users/test_profile.py::test_get_profile_success — retourne 200 + schema valide
- [ ] pytest tests/users/test_profile.py::test_get_profile_unauthorized — retourne 401

### Types / lint
- [ ] mypy backend/modules/users/ — clean

### Build
- [ ] build passe

### Non-regression
- [ ] pytest tests/users/ — TOUS passent

## sortie finale

```
CADRAGE :
  Besoin : endpoint GET /users/me/profile retournant le profil utilisateur connecte
  Perimetre : module users uniquement
  Hors perimetre : modification profil, upload photo, cache

TIER : 1 — un seul module, patterns existants, read-only

CONTRAT DE PREUVE :
  - Test success (200 + schema)
  - Test unauthorized (401)
  - Types mypy clean
  - Non-regression module users
  - Build passe

MODE EXECUTION : single-agent
```
