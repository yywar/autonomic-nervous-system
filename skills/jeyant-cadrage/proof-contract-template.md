# template de contrat de preuve

```markdown
## Contrat de preuve

### Nouvelles preuves
- [ ] [test/verification specifique — ex: "test endpoint POST /auth/reset retourne 200 avec email valide"]
- [ ] [test/verification specifique — ex: "test retourne 400 avec email invalide"]

### Types / lint
- [ ] mypy/tsc clean (0 erreur)
- [ ] Lint passe

### Build
- [ ] Build complet passe

### Non-regression
- [ ] Suite de tests module [X] : TOUS passent
- [ ] Suite de tests module [Y] : TOUS passent (si touche)

### Integration (si cross-module)
- [ ] [test e2e specifique — ex: "reset request → email envoye → reset confirm → login OK"]

### Securite (si pertinent)
- [ ] [verification specifique — ex: "token non reutilisable apres usage"]
```

## regles

- Chaque preuve doit etre EXECUTABLE (pas "verifier que ca marche" mais "executer pytest tests/auth/test_reset.py")
- Les preuves de non-regression sont TOUJOURS presentes
- Le contrat est valide par l'utilisateur AVANT le code
