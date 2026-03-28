# template de rapport de preuves

```markdown
## Rapport de preuves

### Demonstrees
- [x] [preuve] — [commande executee] → [resultat]
- [x] [preuve] — [commande executee] → [resultat]

### Probables
- [~] [preuve] — [raison pour laquelle c'est probable mais pas demontre]

### Non verifiees
- [ ] [preuve] — [raison : pas d'environnement / hors scope / etc.]

### Contredites
- [!] [preuve] — [commande] → [erreur obtenue]
  - Tentative 1 : [correction tentee] → [resultat]
  - Tentative 2 : [correction tentee] → [resultat]

### Non-regression
- [x/!] Suite tests module [X] : [PASS / N tests, M echecs]
- [x/!] Suite tests module [Y] : [PASS / N tests, M echecs]
- [x/!] Build : [PASS / FAIL]
- [x/!] Types : [CLEAN / N erreurs]

### Verdict preuves
[PASS / PASS AVEC RESERVES / FAIL]

### Reserves (si PASS AVEC RESERVES)
- [ce qui n'est pas demontre mais acceptable]
```
