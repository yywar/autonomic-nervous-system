# definition de done d'une micro-unite

Une micro-unite n'est PAS finie parce qu'elle est codee.

Elle est finie quand :
- Son objectif est atteint (le critere de sortie est vrai)
- Son test principal passe
- Les types sont clean (mypy/tsc sans erreur)
- Le build passe
- La non-regression du module passe (suite de tests existante)
- Ses effets voisins ont ete verifies (si elle touche une interface)
- Son statut est explicite dans le rapport

Si l'une de ces conditions n'est pas remplie → la micro-unite n'est pas done.
