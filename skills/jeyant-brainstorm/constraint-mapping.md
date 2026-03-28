# cartographie des contraintes

```markdown
## Contraintes dures (non negociables)
- [ex: doit rester dans le module auth]
- [ex: doit utiliser le middleware JWT existant]
- [ex: pas de nouvelle dependance sans ADR]

## Contraintes souples (preferees mais negociables)
- [ex: suivre le pattern router → service → repository]
- [ex: eviter les requetes synchrones vers services externes]

## Inconnues (a trancher)
- [ex: provider email pas encore choisi → impact sur le design]
- [ex: volume attendu inconnu → impact sur le rate limiting]
```

## regle

Chaque inconnue est un risque. Si une inconnue change la solution fondamentalement → la signaler comme bloquante et poser la question.
