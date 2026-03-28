---
name: block-hardcoded-secrets
enabled: true
event: file
action: block
conditions:
  - field: new_text
    operator: regex_match
    pattern: (API_KEY|SECRET_KEY|PRIVATE_KEY|AWS_SECRET|DATABASE_URL|NEXTAUTH_SECRET)\s*[:=]\s*["'][^"']{8,}
---

**Secret code en dur detecte !**

Les secrets ne doivent JAMAIS etre dans le code source.
Utilisez des variables d'environnement via `.env.local` (non commite).
