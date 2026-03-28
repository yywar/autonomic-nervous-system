# arbre de decision des tiers

## tier 2 si l'un de ces criteres est vrai

- La tache touche plus d'un module
- La tache cree une nouvelle architecture ou un nouveau pattern
- La tache modifie un contrat d'API ou des types partages
- C'est la premiere implementation d'un module
- La tache implique une migration de base de donnees
- La tache implique un choix technologique engageant
- Le cadrage revele une ambiguite structurante

## tier 1 sinon

- Feature dans un module existant avec patterns etablis
- Bug fix local
- Ajout simple a une structure existante
- Modification de contenu (texte, config, style)

## l'utilisateur peut toujours forcer

- `--light` force le Tier 1
- L'utilisateur peut demander un Tier 2 meme si le cadrage suggere Tier 1
