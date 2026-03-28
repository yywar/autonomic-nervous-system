# protocole d'erreur

## preuves echouent apres 2 retries

1. Arreter immediatement
2. Presenter le diagnostic a l'utilisateur :
   - Quelle preuve echoue
   - Ce qui a ete tente
   - Hypothese sur la cause
3. Demander : corriger manuellement / modifier l'approche / abandonner

## cadrage ambigu

1. Identifier les ambiguites bloquantes
2. Poser les questions manquantes (max 3, groupees)
3. Si l'utilisateur ne repond pas → continuer avec hypotheses explicites si risque faible, sinon STOP

## agent timeout ou echec

1. Signaler quel agent a echoue et sur quelle micro-unite
2. Proposer : relancer / continuer sans cette partie / arreter
3. Ne jamais relancer silencieusement

## conflit de merge

1. Signaler les fichiers en conflit
2. Montrer les deux versions
3. Demander a l'utilisateur de trancher
4. Ne JAMAIS resoudre un conflit seul

## etat projet incoherent au demarrage

1. Lister les incoherences detectees (ex: "login marque comme fait mais le fichier n'existe pas")
2. Proposer une correction de l'etat
3. Attendre validation avant de continuer

## non-regression echoue

1. STOP IMMEDIAT — ne pas continuer avec des tests casses
2. Identifier si la casse est pre-existante (pre-flight) ou causee par l'agent
3. Si pre-existante → signaler, demander si on continue quand meme
4. Si causee → corriger, re-verifier (compte dans les 2 retries max)
