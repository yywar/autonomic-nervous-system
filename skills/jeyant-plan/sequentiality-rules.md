# regles de sequentialite

## sequentiel obligatoire

| Cas | Raison |
|-----|--------|
| Migrations de base de donnees | Conflits de versions, risque de data loss |
| Modification de types/contrats partages | Les implementations dependantes doivent voir la version finale |
| Modification d'un middleware utilise par d'autres modules | Risque de regression cross-module |

## parallelisable

| Cas | Condition |
|-----|-----------|
| Micro-unites dans le meme module sans dependance | Pas de fichier partage entre elles |
| Micro-unites dans des modules differents | Pas de contrat partage modifie |
| Tests independants | Toujours parallelisables |

## ordre recommande

1. Migrations / schema DB en premier (si applicable)
2. Types / contrats partages en deuxieme
3. Services / logique metier en troisieme
4. Endpoints / composants en quatrieme
5. Tests d'integration en dernier

## regle

En cas de doute sur la parallelisabilite → sequentiel. Le cout d'un conflit est toujours superieur au cout de la sequentialite.
