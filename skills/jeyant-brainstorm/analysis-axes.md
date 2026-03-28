# axes d'analyse

## axe 1 — technique

| Critere | Question |
|---------|----------|
| Complexite code | Combien de lignes / fichiers / concepts nouveaux ? |
| Testabilite | Peut-on ecrire des tests clairs et non fragiles ? |
| Coherence avec l'existant | L'approche s'integre-t-elle naturellement au code actuel ? |
| Securite | Y a-t-il des surfaces d'attaque evidentes ? |
| Performance | Y a-t-il des goulots previsibles ? |

## axe 2 — agentic-friendliness

| Critere | Question |
|---------|----------|
| Isolation module | L'agent peut-il tout faire sans sortir du module ? |
| Pattern existant | L'agent a-t-il un modele a suivre dans le code existant ? |
| Taille de contexte | L'agent peut-il comprendre toute l'approche dans une session ? |
| Risque de divergence | L'approche cree-t-elle des patterns que l'agent pourrait mal reproduire plus tard ? |
| Verifiabilite | Les preuves sont-elles automatisables (tests, types) ou manuelles ? |

## axe 3 — effets de bord et futur

| Critere | Question |
|---------|----------|
| Impact autres modules | Cette approche force-t-elle des changements ailleurs ? |
| Creation de dette | Cette approche cree-t-elle de la dette technique evidente ? |
| Features futures | Cette approche facilite-t-elle ou bloque-t-elle les evolutions prevues ? |
| Reversibilite | Si c'est un mauvais choix, a quel prix revient-on en arriere ? |

## format de sortie

Tableau comparatif par axe, puis synthese.
