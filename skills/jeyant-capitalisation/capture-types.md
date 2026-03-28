# types de capture

## echecs / lecons

| Type | Exemple | Destination |
|------|---------|-------------|
| Anti-pattern decouvert | "Ne jamais partager un secret JWT entre usages" | `docs/conventions/anti-patterns.md` |
| Erreur de cadrage | "Le perimetre etait trop large → split necessaire" | Ressource `jeyant-cadrage` |
| Preuve insuffisante | "Le test ne verifiait que le happy path" | Ressource `jeyant-preuves` |
| Pattern divergent | "Module A et B gèrent les erreurs differemment" | `docs/conventions/backend.md` |
| Piege de decoupage | "Micro-unite trop grosse → 2 retries necessaires" | Ressource `jeyant-plan` |

## succes / bonnes pratiques

| Type | Exemple | Destination |
|------|---------|-------------|
| Bon pattern confirme | "Token signe avec claim purpose = agentic-friendly" | `docs/conventions/backend.md` |
| Heuristique brainstorm | "Privilegier l'approche qui reutilise les patterns" | Ressource `jeyant-brainstorm` |
| Regle de decoupage | "1 endpoint + service + tests = 1 micro-unite ideale" | Ressource `jeyant-plan` |
| Bonne taille de micro-unite | "~50 lignes de code + ~30 lignes de test = cycle fluide" | Ressource `jeyant-plan` |
| Convention emergente | "Tous les services retournent des Pydantic models" | `docs/conventions/backend.md` |

## regle de filtrage

Ne capitaliser que ce qui est :
- Non evident (pas "les tests doivent passer")
- Reproductible (pas un cas unique)
- Actionnable (peut etre transforme en regle ou guide)
