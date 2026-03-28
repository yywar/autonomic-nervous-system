---
name: warn-sql-injection
enabled: true
event: file
action: warn
conditions:
  - field: new_text
    operator: regex_match
    pattern: (\$\{.*\}|['"]\s*\+\s*).*(?i)(SELECT|INSERT|UPDATE|DELETE|DROP|ALTER|EXEC|EXECUTE)
---

**Risque d'injection SQL detecte !**

Utilisez des requetes parametrees :
- Prisma : `prisma.$queryRaw` avec tagged template
- Supabase : `.from().select()` (query builder)
- SQL brut : placeholders `$1, $2` (jamais de concatenation)
