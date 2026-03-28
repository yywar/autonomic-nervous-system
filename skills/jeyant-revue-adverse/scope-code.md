# scope code — revue de l'implementation

## quand

Apres implementation + preuves. En Tier 1 et Tier 2.
Execute par un agent independant (contexte frais).

## checklist technique

1. **Coherence intention/implementation**
   Le diff repond-il au cadrage ? Tout ce qui etait demande est-il presente ? Rien de non demande n'a ete ajoute ?

2. **Changements non intentionnels**
   Des fichiers ont-ils ete modifies par erreur ? Des espaces, des imports, des reformattages parasites ?

3. **Oublis de debug**
   TODO, FIXME, console.log, print(), breakpoints, code commente ?

4. **Securite**
   Injections, XSS, auth bypass, secrets en dur, permissions manquantes ?

5. **Patterns du module**
   Le nouveau code suit-il les patterns existants ? (nommage, structure, imports, gestion d'erreur)

6. **Qualite des tests**
   Les tests verifient-ils REELLEMENT le comportement ? Ou testent-ils juste que le code s'execute sans erreur ?
   Pièges : assertions trop faibles (assertTrue(True)), mocks trop gentils, pas de cas negatif.

7. **Non-regression**
   La suite de tests existante passe-t-elle ? Le rapport de preuves est-il coherent ?

## sortie

Utiliser `report-template.md`.
