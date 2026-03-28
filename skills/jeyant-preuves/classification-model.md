# modele de classification des preuves

## demonstree

Preuve directe. Le test passe, la commande retourne le resultat attendu, la verification est concluante.

Criteres :
- Test automatise qui passe
- Commande executee avec output verifiable
- Resultat reproductible

## probable

Indicateurs positifs mais pas de preuve directe complete.

Criteres :
- Revue de code manuelle concluante mais pas de test automatise
- Pattern suivi correctement mais non verifiable automatiquement
- Fonctionnement observe mais pas sous toutes les conditions

## non verifiee

Pas teste ou pas testable dans le contexte actuel.

Criteres :
- Pas d'environnement de test disponible (ex: service externe)
- Test trop complexe a mettre en place pour cette iteration
- Verification visuelle non realisee

## contredite

La preuve echoue. Le test ne passe pas, le build casse, le type check echoue.

Criteres :
- Test automatise qui echoue
- Build error
- Type error
- Assertion failure

→ Declenche immediatement le protocole de retry.
