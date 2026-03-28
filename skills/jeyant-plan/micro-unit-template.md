# template de micro-unite

```markdown
## Micro-unite N — [nom court]

### Objectif
[Concret et testable — ex: "creer l'endpoint POST /auth/reset-request qui genere un token JWT"]

### Fichiers
- Creer : [liste precise]
- Modifier : [liste precise]
- Pattern a suivre : [reference au fichier modele — ex: "meme structure que auth/login.py"]

### Prerequis
- [Micro-unite M terminee]
- [Table X existe]
- [Service Y disponible]

### Preuve attendue
- [Test specifique — ex: "pytest tests/auth/test_reset.py::test_reset_request_success"]
- [Type check clean]

### Risque principal
[Le probleme le plus probable — ex: "conflit avec le middleware existant"]

### Condition de sortie
[Ce qui doit etre vrai — ex: "test passe, types clean, build OK, non-regression auth OK"]
```

## regle

Si tu ne peux pas remplir "preuve attendue" avec un test specifique, la micro-unite est trop vague → la preciser.
