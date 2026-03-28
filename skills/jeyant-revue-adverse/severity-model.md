# modele de gravite

## critique

Rend le resultat non deployable, dangereux ou faux de maniere centrale.

Exemples :
- Faille de securite (auth bypass, injection SQL, secret en dur)
- Perte de donnees possible
- Fonctionnalite principale ne fonctionne pas
- Non-regression cassee

## majeur

Affaiblit fortement la fiabilite ou cree un risque serieux de regression.

Exemples :
- Test qui ne verifie rien de reel (mock trop gentil)
- Pattern divergent qui creera de la confusion
- Gestion d'erreur absente sur un chemin critique
- Interface partagee modifiee sans mise a jour des dependants

## moyen

Defaut reel mais circonscrit.

Exemples :
- Nommage incoherent avec les conventions
- Log level inapproprie
- Test edge case manquant
- Code duplique evitable

## mineur

Amelioration utile sans remise en cause.

Exemples :
- Commentaire manquant sur une logique non evidente
- Import inutilise
- Formattage incoherent
