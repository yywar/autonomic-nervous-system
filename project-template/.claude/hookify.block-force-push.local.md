---
name: block-force-push
enabled: true
event: bash
pattern: git\s+push\s+.*(-f|--force)\b
action: block
---

**Force push bloque !**

Les force push sont interdits. Alternatives :
- `git push` (normal)
- `git push --force-with-lease` (plus sur, si absolument necessaire)
- Demandez a l'utilisateur si un force push est vraiment voulu
