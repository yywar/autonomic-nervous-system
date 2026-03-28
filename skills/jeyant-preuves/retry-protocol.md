# protocole de retry

## declenchement

Une preuve est classifiee CONTREDITE (test echoue, build casse, type error).

## procedure

### tentative 1
1. Analyser l'echec : lire le message d'erreur, identifier la cause
2. Corriger le code
3. Re-executer la preuve echouee
4. Re-executer la non-regression (verifier que la correction n'a pas casse autre chose)

### tentative 2 (si tentative 1 echoue)
1. Re-analyser : la cause initiale etait-elle correcte ?
2. Explorer une approche differente de correction
3. Re-executer toutes les preuves du contrat

### apres 2 tentatives echouees
1. STOP — ne pas continuer
2. Documenter :
   - Quelle preuve echoue
   - Ce qui a ete tente (2 approches)
   - L'hypothese sur la cause racine
3. Remonter au pilote avec le diagnostic
4. Le pilote demande a l'utilisateur : corriger manuellement / modifier l'approche / abandonner

## interdictions

- Ne JAMAIS supprimer un test qui echoue pour "faire passer les preuves"
- Ne JAMAIS commenter un test
- Ne JAMAIS baisser les seuils de preuve sans accord utilisateur
- Ne JAMAIS boucler silencieusement au-dela de 2 tentatives
