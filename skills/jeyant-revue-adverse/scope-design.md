# scope design — revue du brainstorm

## quand

Apres le brainstorm, AVANT de commencer l'implementation. Tier 2 uniquement.

## checklist de contestation

1. **Le bon probleme ?**
   Le brainstorm repond-il au besoin reel du cadrage, ou a-t-il derive vers un probleme adjacent ?

2. **La meilleure approche ?**
   L'approche recommandee est-elle reellement superieure aux alternatives, ou est-ce un biais de premiere idee ?

3. **Hypotheses fragiles ?**
   Quelles hypotheses non verifiees supportent la decision ? Que se passe-t-il si elles sont fausses ?

4. **Modes d'echec oublies ?**
   Le brainstorm a-t-il couvert les 4 types d'echec (technique, agentic, echelle, operationnel) ? En manque-t-il ?

5. **Simulation agentic realiste ?**
   La simulation est-elle optimiste ? L'agent pourra-t-il vraiment faire ce qui est prevu dans une seule session ?

6. **ADR complet ?**
   L'ADR draft documente-t-il honnement les risques acceptes ? Les alternatives sont-elles reellement rejetees pour les bonnes raisons ?

## sortie

```markdown
### Revue design

#### Verdict : [PASS / PASS AVEC RESERVES / REFAIRE LE BRAINSTORM]

#### Points de contestation
- [point 1 + gravite]
- [point 2 + gravite]

#### Recommandation
[Continuer / Revoir l'approche X / Poser la question Y a l'utilisateur]
```
