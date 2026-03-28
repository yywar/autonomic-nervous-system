# regles d'exploration

## minimum 3 approches

| Type | Role | Obligatoire |
|------|------|-------------|
| La conservatrice | Reutilise au maximum l'existant, minimum de nouveau code | Oui |
| La structuree | La "bonne" solution architecturale, quitte a investir plus | Oui |
| L'inattendue | Approche non evidente — forcer la creativite | Oui |
| Variante | Si une approche a 2 variantes significatives | Optionnel |

## chaque approche doit contenir

```markdown
## Approche [A/B/C] — [Nom descriptif]

### Principe
[Description concrete — pas vague, pas un paragraphe marketing]

### Implementation esquissee
- Endpoint / composant : [quoi]
- Service / hook : [quoi]
- Fichiers a creer : [liste]
- Fichiers a modifier : [liste]
- Pattern a suivre : [reference a un fichier existant ou "nouveau"]

### Modules touches
- [liste]

### Patterns reutilises
- [liste — quels patterns existants sont reutilises]

### Patterns nouveaux
- [liste — quels nouveaux patterns cette approche cree]
```

## regle stricte

Une approche sans esquisse d'implementation est trop vague pour etre comparee. Si tu ne peux pas lister les fichiers, l'approche n'est pas assez concrete.
