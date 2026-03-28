# modes d'echec

Pour chaque approche, analyser 4 types d'echec :

## 1. echec technique

```markdown
### Que se passe-t-il si...
[le cas technique le plus probable qui casse — ex: secret partage, race condition, timeout]

### Mitigation
[comment prevenir ou gerer]
```

## 2. echec agentic

```markdown
### Comment un agent futur pourrait mal utiliser ce pattern ?
[ex: copier le pattern sans le claim purpose → faille de securite]

### Mitigation
[ex: documenter dans ADR + convention + anti-pattern]
```

## 3. echec a l'echelle

```markdown
### Que se passe-t-il si le volume/la taille x10 ou x100 ?
[ex: token stateless → pas de revocation possible sous charge]

### Mitigation
[ex: acceptable si TTL court, sinon table de revocation]
```

## 4. echec operationnel

```markdown
### Que se passe-t-il si un service externe est down ?
[ex: service email down → token cree mais pas envoye]

### Mitigation
[ex: queue avec retry dans le module notifications]
```

## regle

L'agent pense toujours a comment ca MARCHE. Le brainstorm doit penser a comment ca CASSE. C'est la difference entre un bon design et un design fragile.
