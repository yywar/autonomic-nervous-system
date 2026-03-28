# verification des frontieres de module

## methode

1. Lire `docs/architecture/MODULE-MAP.md`
2. Identifier le module cible de la tache (d'apres le cadrage)
3. Lister tous les fichiers qui seront crees ou modifies
4. Pour chaque fichier, verifier qu'il est dans le perimetre du module

## regles

### fichier dans le module → OK
Continuer normalement.

### fichier hors module → REFUSER par defaut

Exceptions autorisees (avec justification) :
- Fichier de types/contrats partages (`SHARED-CONTRACTS`)
- Fichier de configuration globale
- Fichier de migration DB (module commun)

Si l'exception est necessaire → signaler au pilote comme impact cross-module.

### interface partagee modifiee → ALERTE

Si un fichier qui definit un contrat entre modules est modifie :
- Signaler immediatement
- Lister les modules qui dependent de cette interface
- Le pilote decidera si les modules dependants doivent etre mis a jour

## si MODULE-MAP n'existe pas

- Signaler le fichier manquant
- Deduire les frontieres de la structure de dossiers
- Proposer a l'utilisateur de creer la MODULE-MAP via `--init`
- Continuer avec les frontieres deduites (mode degrade)
