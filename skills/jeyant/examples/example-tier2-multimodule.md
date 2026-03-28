# exemple end-to-end — Tier 2 : password reset cross-module

## 1. demande utilisateur

```
/jeyant "ajoute la feature de password reset avec email"
```

## 2. pilote — lecture de l'etat

```
📖 PROJECT-STATE → auth a 70%, notifications a 40%
📖 SESSION-LOG → aucune regression recente
📖 modules/auth.md → login + register OK, pattern JWT etabli
📖 modules/notifications.md → envoi email basique OK
```

## 3. cadrage

```
CADRAGE :
  Besoin : flow password reset securise (request → email → confirm → password change)
  Perimetre : module auth (2 endpoints + service) + module notifications (template email)
  Hors perimetre : frontend, rate limiting, 2FA

TIER : 2 — cross-module, securite, nouveau flow

CONTRAT DE PREUVE :
  - 4 tests auth (request success, unknown email, confirm success, confirm expired)
  - 1 test notifications (email formate)
  - 1 test integration e2e (flow complet)
  - 2 verif securite (claim purpose, expiration)
  - mypy clean sur 2 modules
  - Non-regression 2 modules
  - Build passe

MODE : parallele 2 modules + consolidation
```

## 4. validation utilisateur → ✓

## 5. brainstorm (7 phases)

```
RECHERCHE : JWT pattern existe dans login, notifications envoie deja des emails
CONTRAINTES : doit utiliser le middleware JWT, pas de nouvelle dependance
APPROCHES :
  A. Token DB (table reset_tokens) — conservatrice
  B. JWT signe avec claim purpose — structuree
  C. Lien magique one-time (hash en URL) — inattendue

SIMULATION AGENTIC :
  B reutilise le pattern JWT existant → l'agent a un modele
  A cree une nouvelle table → migration necessaire
  C cree un nouveau pattern → risque de divergence

MODES D'ECHEC :
  B : token non revocable avant expiration → acceptable si TTL 15min
  A : table orpheline si cleanup manque → dette
  C : hash previsible si mal genere → faille

RECOMMANDATION : B (JWT avec claim purpose)
  → reutilise pattern existant, agentic-friendly, pas de migration
```

## 6. revue adverse #1 (design)

```
Verdict : PASS
Reserve : documenter dans l'ADR que le token n'est pas revocable
  → acceptable car TTL 15min
```

## 7. plan

```
Micro-unite 1 : endpoint POST /auth/reset-request + service (module auth)
Micro-unite 2 : endpoint POST /auth/reset-confirm + service (module auth)
  → sequentiel (meme module, unite 2 depend de 1)
Micro-unite 3 : template email reset + envoi (module notifications)
  → parallele avec 1+2 (module different)
Micro-unite 4 : test integration e2e
  → sequentiel (depend de 1, 2, 3)
```

## 8. dispatch

```
AGENT A (worktree) → module auth : micro-unites 1 + 2
  ├── dev-guard : OK (baseline 12 tests)
  ├── Unite 1 : implemente → preuves OK
  ├── Unite 2 : implemente → preuves FAIL (password non hashe)
  │   └── Retry 1 : corrige → preuves OK
  └── Rapport : succes, 2 corrections, 16 tests passent

AGENT B (worktree) → module notifications : micro-unite 3
  ├── dev-guard : OK (baseline 4 tests)
  ├── Unite 3 : implemente → preuves OK
  └── Rapport : succes, 5 tests passent
```

## 9. consolidation

```
Merge worktrees → pas de conflit (modules isoles)
Test integration e2e (micro-unite 4) :
  reset-request → email envoye → reset-confirm → login OK → PASS
```

## 10. revue adverse #2 (agent independant)

```
Package recu : cadrage + contrat preuve + ADR + diff + preuves

Verdict : PASS AVEC RESERVES
  - Mineur : log level "info" sur reset-request devrait etre "warning" (action sensible)
  - Les tests verifient le comportement reel (pas de mock fragile)
  - Le claim "purpose" est bien present dans le token
  - La non-regression passe sur les 2 modules
```

## 11. mise a jour memoire

```
📝 PROJECT-STATE → auth 85%, notifications 50%
📝 modules/auth.md → ✅ password reset (request + confirm)
📝 modules/notifications.md → ✅ template reset email
📝 BACKLOG → coche "password reset", ajoute "IMPROVE: log level reset"
📝 CHANGELOG → 2026-03-18 : password reset avec email
📝 SESSION-LOG → auth+notif | reset | T2 | ✅ reserves | log level
📝 docs/decisions/004-reset-strategy.md → ADR FINAL
📝 conventions/backend.md → ajoute pattern "JWT avec claim purpose"
```

## 12. capitalisation

```
ECHECS :
  - Password non hashe dans le service → ajouter a anti-patterns.md :
    "toujours utiliser hash_password(), ne jamais stocker en clair"

SUCCES :
  - Le pattern JWT avec claim purpose est agentic-friendly
    → documente dans conventions/backend.md
  - Le decoupage "1 endpoint + service = 1 micro-unite" fonctionne bien
    → confirme la regle dans jeyant-plan

COHERENCE : pas de divergence detectee entre auth et notifications
```

## 13. verdict final

```
STATUT : PRET AVEC RESERVES

DEMONTRE :
  - Flow complet fonctionne (test e2e)
  - Token securise avec claim purpose
  - Non-regression OK sur 2 modules
  - Build + types clean

INFERE :
  - Performance sous charge (pas teste)

NON VERIFIE :
  - Comportement si service email down (hors perimetre)

RESERVES :
  - Log level a ajuster (mineur, dans le backlog)
  - Password non hashe decouvert pendant les preuves (corrige, capitalise)

PROCHAINE ACTION : rate limiting (backlog)
```
