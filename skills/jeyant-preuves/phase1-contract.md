# phase 1 — contrat de preuve

## quand

AVANT le code. Produit par le cadrage, valide par l'utilisateur.

## comment construire le contrat

1. Lire les criteres d'acceptation du cadrage
2. Pour chaque critere → definir la preuve executable
3. Ajouter les preuves de non-regression (toujours)
4. Ajouter les preuves specifiques au contexte (securite, API, etc.)

## format

```markdown
## Contrat de preuve

### Nouvelles preuves
- [ ] [description precise + commande/test — ex: "pytest tests/auth/test_reset.py::test_reset_success"]
- [ ] [description precise + commande/test]

### Types / lint
- [ ] mypy/tsc clean (0 erreur sur les fichiers touches)
- [ ] Lint passe

### Build
- [ ] Build complet passe

### Non-regression (obligatoire)
- [ ] pytest tests/[module]/ — TOUS passent
- [ ] pytest tests/[module_impacte]/ — TOUS passent (si applicable)

### Integration (si cross-module)
- [ ] [test e2e specifique + commande]

### Securite (si pertinent)
- [ ] [verification specifique — ex: "token non reutilisable"]

### Performance (si pertinent)
- [ ] [benchmark specifique — ex: "< 200ms p95"]
```

## regle

Chaque preuve doit etre EXECUTABLE : pas "verifier que ca marche" mais "executer [commande] et verifier [resultat attendu]".
