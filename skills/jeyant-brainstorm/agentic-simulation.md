# simulation agentic

Pour chaque approche, simuler deux scenarios :

## scenario 1 — l'agent qui implemente maintenant

```markdown
### Fichiers a lire : [N fichiers, lesquels]
### Fichiers a creer : [N fichiers, lesquels]
### Fichiers a modifier : [N fichiers, lesquels]
### Pattern a suivre : [existe dans le code → reference, ou nouveau]
### Risque de divergence : [faible / moyen / eleve + explication]
### Taille de contexte necessaire : [estimation en lignes de code a comprendre]
### Peut etre fait dans un module isole : [oui / non + explication]
```

## scenario 2 — l'agent qui maintient dans 6 mois

```markdown
### Le pattern sera-t-il toujours clair ?
[oui si documente dans ADR, non si convention implicite]

### Le module sera-t-il toujours de taille raisonnable ?
[oui si < 20 fichiers, attention si croissance prevue]

### Y aura-t-il des effets de bord invisibles ?
[oui si dependances implicites, non si contrats types clairs]

### Un agent pourrait-il mal reutiliser ce pattern ?
[risque + mitigation — ex: "documenter dans conventions/anti-patterns.md"]
```

## regle

Si une approche est mauvaise pour l'agentic (risque de divergence eleve, pas de pattern existant, contexte trop large), c'est un argument fort CONTRE cette approche, meme si elle est techniquement superieure.
