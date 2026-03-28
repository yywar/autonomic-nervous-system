# exemple — Tier 2 : feature password reset avec email

## demande utilisateur

"ajoute la feature de password reset : l'utilisateur demande un reset, recoit un email avec un lien, clique et change son mot de passe"

## etape 1 — analyse

- Demande explicite : flow complet de password reset
- Attente implicite : securise (token expire, usage unique), email envoye, UX complete
- Type de livrable : code backend (2 endpoints + service + email) + potentiellement frontend
- Niveau d'enjeu : eleve — touche l'auth (securite), cross-module (auth + notifications)
- Risque de malentendu : moyen — "lien" implique du frontend, scope a clarifier
- Impact radius : module `auth` + module `notifications`, potentiellement `frontend`

Signaux Tier 2 :
- Touche 2 modules (auth + notifications) ✓
- Securite (tokens, auth) ✓
- Nouveau flow complet ✓

→ **Tier 2 recommande**

## etape 2 — contrat de besoin

### Objectif reel
Permettre a un utilisateur qui a oublie son mot de passe de le reinitialiser de maniere securisee via un email.

### Perimetre
- Endpoint POST /auth/reset-request — genere un token et declenche l'envoi d'email
- Endpoint POST /auth/reset-confirm — verifie le token et change le mot de passe
- Service de generation/verification de token reset
- Integration avec le module notifications pour l'envoi d'email
- Tests unitaires et d'integration

### Hors perimetre
- Frontend (pages de reset) — a traiter dans une tache separee
- Rate limiting sur le reset request — a traiter comme tache suivante
- 2FA — feature separee
- Changement de mot de passe quand on connait l'ancien (c'est un reset, pas un change)

### Hypotheses
- Le module notifications existe et peut envoyer des emails (sinon, c'est un prerequis)
- Le password est hashe avec bcrypt (pattern existant dans le login)
- Le JWT secret peut etre utilise pour signer les tokens de reset (avec un claim purpose different)

### Criteres d'acceptation
- [ ] POST /auth/reset-request avec email existant → 200, email envoye
- [ ] POST /auth/reset-request avec email inexistant → 200 (pas de leak d'info)
- [ ] POST /auth/reset-confirm avec token valide + nouveau password → 200, password change
- [ ] POST /auth/reset-confirm avec token expire → 400
- [ ] POST /auth/reset-confirm avec token deja utilise → 400
- [ ] Le token expire apres 15 minutes
- [ ] L'utilisateur peut se login avec le nouveau password apres reset

### Impact radius
- Modules : auth (principal), notifications (email)
- Contrats/types modifies : aucun contrat partage — les modules communiquent via un appel interne
- Effets de bord : le module notifications doit supporter un nouveau template d'email

## etape 3 — expansion proactive

Niveau 2 (anticipation voisine) :
- Ajouter le template d'email de reset dans le module notifications
- Documenter la strategie de token reset dans un ADR (choix JWT vs token DB)
- Prevoir le rate limiting comme tache BACKLOG (pas dans ce scope, mais identifie)

Niveau 3 (elargissement strategique) :
- Le pattern de "token a usage unique" sera reutilisable pour : verification email, invitation, etc.
  → le documenter dans les conventions pour que les agents futurs le reutilisent

## etape 4 — contrat de preuve

### Nouvelles preuves
- [ ] pytest tests/auth/test_reset.py::test_reset_request_success — 200 + email declenche
- [ ] pytest tests/auth/test_reset.py::test_reset_request_unknown_email — 200 (pas de leak)
- [ ] pytest tests/auth/test_reset.py::test_reset_confirm_success — password change
- [ ] pytest tests/auth/test_reset.py::test_reset_confirm_expired_token — 400
- [ ] pytest tests/auth/test_reset.py::test_reset_confirm_used_token — 400
- [ ] pytest tests/notifications/test_reset_email.py::test_send_reset_email — email formate

### Types / lint
- [ ] mypy backend/modules/auth/ — clean
- [ ] mypy backend/modules/notifications/ — clean

### Build
- [ ] build complet passe

### Non-regression
- [ ] pytest tests/auth/ — TOUS passent
- [ ] pytest tests/notifications/ — TOUS passent

### Integration
- [ ] test e2e : reset-request → email contient un token → reset-confirm avec ce token → login OK

### Securite
- [ ] le token contient un claim "purpose": "reset" (pas reutilisable comme token d'auth)
- [ ] le token expire bien apres 15 minutes

## sortie finale

```
CADRAGE :
  Besoin : flow complet de password reset securise via email
  Perimetre : module auth (endpoints + service) + module notifications (email)
  Hors perimetre : frontend, rate limiting, 2FA, change password

TIER : 2 — cross-module (auth + notifications), securite, nouveau flow

CONTRAT DE PREUVE :
  - 6 tests unitaires (success, unknown email, confirm, expired, used, email)
  - 1 test d'integration e2e (flow complet)
  - 2 verifications securite (claim purpose, expiration)
  - Types mypy clean sur 2 modules
  - Non-regression sur 2 modules
  - Build passe

MODE EXECUTION : parallele 2 modules (auth + notifications) + consolidation
```
