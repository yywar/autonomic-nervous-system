# signaux d'analyse

## signaux de Tier 2 (decision structurante)

Mots-cles dans la demande :
- "architecture", "systeme", "workflow", "complet", "robuste", "industrialiser"
- "migration", "refactoring", "nouveau module", "premiere fois"

Caracteristiques de la tache :
- Touche plus d'un module
- Cree un nouveau pattern qui n'existe pas dans le code
- Modifie un contrat d'API ou des types partages
- Premiere implementation d'un module
- Implique une migration de base de donnees
- Choix technologique engageant

## signaux de Tier 1 (quotidien)

- Tache dans un module existant avec patterns etablis
- Bug fix local
- Ajout simple a une structure existante (nouvel endpoint, nouveau composant)
- Modification de contenu

## signaux de risque (augmenter la vigilance)

- La demande mentionne "production", "securite", "performance", "donnees sensibles"
- Plusieurs systemes ou composants concernes
- Attente explicite d'exhaustivite
- Impact transverse probable

## dimensions a qualifier

- Precision de la demande : vague / moyenne / precise
- Complexite : simple / moderate / elevee
- Criticite : faible / moyenne / haute
- Ambiguite : faible / moyenne / forte
- Attente de profondeur : surface / standard / approfondie
