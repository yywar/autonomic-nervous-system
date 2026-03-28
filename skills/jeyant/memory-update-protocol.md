# protocole de mise a jour memoire

## ecritures immediates (pendant la session)

| Moment | Fichier | Action |
|--------|---------|--------|
| Brainstorm produit un ADR | `docs/decisions/NNN-sujet.md` | Ecrire le draft immediatement |
| Dev-guard decouvre un pattern | Note interne | Ajouter a la liste des patterns a proposer en fin de session |
| Revue adverse trouve un bug | `docs/state/BACKLOG.md` | Ajouter immediatement |

## ecritures de fin de session (obligatoires)

| Fichier | Action |
|---------|--------|
| `docs/state/PROJECT-STATE.md` | Mettre a jour la completude des modules |
| `docs/state/modules/[module].md` | Marquer ce qui est fait, en cours, decouvert |
| `docs/state/BACKLOG.md` | Cocher le fait, ajouter les decouvertes |
| `docs/state/CHANGELOG.md` | Ajouter l'entree de session |
| `docs/state/SESSION-LOG.md` | Ajouter la ligne de session |

## ecritures conditionnelles

| Condition | Fichier | Action |
|-----------|---------|--------|
| ADR draft valide | `docs/decisions/NNN.md` | Passer de DRAFT a FINAL |
| Pattern decouvert par dev-guard | `docs/conventions/[backend\|frontend].md` | Proposer l'ajout a l'utilisateur |
| Capitalisation produit un anti-pattern | `docs/conventions/anti-patterns.md` | Ajouter |
| Capitalisation produit un bon pattern | `docs/conventions/[backend\|frontend].md` | Ajouter |
| Capitalisation enrichit une skill | Ressource de la skill concernee | Modifier |

## verification de coherence (debut de session)

Au demarrage, le pilote verifie :
1. Les features marquees ✅ dans l'etat module → le fichier/test correspondant existe ?
2. Le backlog est coherent avec l'etat des modules
3. Le SESSION-LOG n'indique pas de probleme recurrent sur le module concerne

Si incoherence → signaler avant de commencer.
