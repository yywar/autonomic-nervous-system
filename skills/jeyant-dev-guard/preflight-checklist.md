# checklist pre-flight

## commandes exactes

```bash
# 1. Etat git
git status

# 2. Tests du module (adapter selon la stack)
# Python/FastAPI :
pytest tests/[module]/ -q
# React/TypeScript :
npm test -- --watchAll=false --testPathPattern=[module]

# 3. Build
# Python : pas de build, verifier les imports
python -c "import [module]"
# React/TypeScript :
npm run build

# 4. Types (si applicable)
# Python :
mypy [module_path]/
# TypeScript :
npx tsc --noEmit
```

## interpretation

| Resultat | Action |
|----------|--------|
| Tout passe | Continuer — baseline propre |
| Tests echouent | SIGNALER — ces echecs sont pre-existants, pas de notre fait |
| Build echoue | SIGNALER — le projet est deja casse |
| Git non propre | SIGNALER — changements non commites en cours |

## regle

Si le pre-flight echoue, demander a l'utilisateur :
- "Le projet a des tests qui echouent avant mon intervention. Continuer quand meme ?"
- Ne JAMAIS commencer avec un pre-flight echoue sans accord explicite
