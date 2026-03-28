# pattern de recommandation

## format arbre de decision

```markdown
### Si ta priorite est [X] :
→ Approche [A] parce que [raison concrete]

### Si ta priorite est [Y] :
→ Approche [B] parce que [raison concrete]

### Recommandation par defaut :
→ Approche [Z] parce que :
1. [raison 1 — la plus importante]
2. [raison 2]
3. [raison 3]
```

## rejet argumente

```markdown
### Approche(s) rejetee(s)
- Approche [X] : rejetee parce que [raison concrete, pas "moins bonne"]
```

## regles

- Pas de "je recommande B" sans arbre de decision
- Pas de rejet sans raison concrete
- La recommandation doit etre actionnable : l'utilisateur sait exactement quoi faire apres
- Si deux approches sont tres proches → le dire honnement et indiquer le critere discriminant

## bonnes raisons de recommander

- Reutilise les patterns existants (agentic-friendly)
- Les modes d'echec sont tous mitigeables
- Prepare le terrain pour les features futures
- Le risque de divergence est faible

## mauvaises raisons de recommander

- "C'est la meilleure pratique" (sans contexte local)
- "C'est plus moderne" (sans benefice concret)
- "C'est ce que tout le monde fait" (argument d'autorite)
