# protocole de recherche

## avant tout brainstorm

1. **Code existant** — chercher des solutions similaires dans le projet
   - `grep -r` pour les patterns, les noms de service, les structures similaires
   - Lire les fichiers les plus proches du probleme actuel
   - Identifier quels patterns sont deja etablis

2. **ADRs** — lire `docs/decisions/`
   - Quelles decisions passees contraignent l'espace de solutions ?
   - Y a-t-il un ADR qui interdit ou recommande une approche ?

3. **Conventions** — lire `docs/conventions/`
   - Patterns obligatoires
   - Anti-patterns interdits
   - Structure de fichiers attendue

4. **Etat module** — lire `docs/state/modules/[module].md`
   - Ce qui est deja implemente
   - Ce qui est prevu
   - Problemes connus

5. **Documentation externe** (si pertinent)
   - Best practices de la stack (FastAPI, React, Redis, Postgres)
   - Patterns connus pour le type de probleme
   - Pas de recherche generique — cibler le probleme exact

## sortie

Un brief de contexte de 5-10 lignes :
- Ce qui existe deja dans le code
- Ce qui contraint les choix
- Ce qu'on sait deja
- Ce qu'on ne sait pas encore
