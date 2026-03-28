---
name: checkpoint
description: Automatise la création d'un point de sauvegarde propre (commit) à la fin d'une fonctionnalité. L'agent analyse les changements, génère un message de commit détaillé en français (Conventional Commits), demande validation, puis effectue le commit. À utiliser lors de requêtes comme "sauvegarde mon chantier" ou "/checkpoint".
---

# Compétence : Checkpoint (Sauvegarde Fin de Chantier)

Cette compétence génère un commit de haute qualité (Conventional Commits) avec une description très détaillée en **Français**, servant de documentation vivante du projet.

## Objectif
Créer un point de sauvegarde (commit) structuré et exhaustif après la complétion d'une tâche ou d'une fonctionnalité, avec le minimum d'effort de la part de l'utilisateur.

## Workflow (Étapes obligatoires)

Lorsque l'utilisateur invoque cette compétence, suivez scrupuleusement cet ordre :

### 1. Analyse de l'état (Automatique)
- Exécutez `git status` pour voir les fichiers modifiés/ajoutés/supprimés.
- Exécutez `git diff` (et `git diff --cached` si des fichiers sont déjà indexés) pour comprendre **exactement** les changements apportés.
- Lisez le fichier de suivi des tâches courant (ex: `task.md` dans les artifacts) s'il y en a un pour comprendre le contexte global.

### 2. Génération du Message (Très Détaillé & en Français)
Préparez en mémoire un message de commit structuré comme suit :

- **Titre (Header)** : `<type>(<scope>): <description courte en français>`
  - Types : `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.
  - Exemple : `feat(Lexique): intégration de l'édition inline des termes`
- **Corps (Body)** : Rédigez un texte exhaustif, clair et structuré en **Français** expliquant :
  - **Contexte / Objectif** : Pourquoi avez-vous fait ça ?
  - **Approche technique** : Comment avez-vous résolu le problème ? Quels fichiers/composants clés ont été modifiés et pourquoi ?
  - **Impact** : (Optionnel) Y a-t-il des breaking changes ? Des éléments à noter pour la suite ?

*Exemple de format:*
```text
feat(Lexique): intégration de l'édition inline des termes

Contexte : L'utilisateur devait auparavant ouvrir une modal pour chaque modification.
Approche :
- Ajout d'attributs contentEditable sur le composant TermRow.
- Remplacement du bouton d'édition par une validation via la touche Entrée.
- Mise à jour du store Zustand pour supporter les modifications atomiques.
```

### 3. Validation Utilisateur (HARD-GATE)
> [!IMPORTANT]
> Ne faites **JAMAIS** le commit sans l'accord de l'utilisateur.

- Présentez le message de commit généré à l'utilisateur (via un bloc de code ou blockquote).
- Demandez-lui : "Ce message de commit te convient-il ? Dois-je procéder à la sauvegarde (git add & git commit) ?"

### 4. Sauvegarde (Commit)
- **SI l'utilisateur valide** :
  - Exécutez `git add .` (ou ajoutez spécifiquement les fichiers s'il l'a demandé).
  - Exécutez le commit en utilisant le message validé.
  - *Astuce technique : Si vous utilisez bash pour le commit, faites attention aux guillemets. Préférez créer le message dans un fichier temporaire (`/tmp/msg.txt`) et faire `git commit -F /tmp/msg.txt`.*
- **SI l'utilisateur demande des modifications** :
  - Ajustez le message selon ses retours et reprenez à l'étape 3.

## Critères de Succès
- Résultat final : un nouveau commit dans l'historique de l'utilisateur.
- Le message de commit est en Français, détaillé, et respecte les Conventional Commits.
- L'utilisateur a explicitement validé le message avant son exécution.
