# Autonomic Nervous System

> **[English](README.en.md)** | Francais

**Enforcement deterministe de la qualite pour Claude Code.**

Ton IA code. Ce systeme garantit qu'elle code *bien*.

---

Chaque fois que tu demandes a Claude Code de corriger un bug, construire une feature ou refactoriser du code, la meme question se pose : **est-ce qu'il a vraiment suivi le processus ?** A-t-il lance les tests ? Verifie la securite ? Reflechi avant de coder ?

L'Autonomic Nervous System repond a cette question avec des hooks, pas de l'espoir. Il enveloppe Claude Code dans une couche d'enforcement deterministe qui **force** la qualite sur chaque requete. Aucune discipline requise. Aucun prompt a memoriser. Le systeme le fait pour toi.

## Le Probleme

Claude Code est puissant. Mais la puissance sans garde-fous produit des resultats inconsistants :

- Tests sautes "parce que le changement est simple"
- Vulnerabilites de securite introduites silencieusement
- Correctifs appliques sans comprendre la cause racine
- Sessions qui se terminent sans memoire de ce qui a ete appris
- Refactoring qui change discretement le comportement
- Secrets codes en dur par accident

On peut ecrire de meilleurs prompts. On peut ajouter des instructions dans CLAUDE.md. Mais les instructions sont des *suggestions* — le modele peut et va les ignorer sous pression de contexte.

## La Solution

Les hooks ne sont pas des suggestions. **Les hooks sont deterministes.** Ils s'executent a chaque fois, sur chaque requete, sans exception.

L'Autonomic Nervous System deploie 6 couches d'enforcement autour de Claude Code :

<p align="center">
  <img src="docs/images/architecture.png" alt="Architecture d'enforcement a 6 couches" width="700"/>
</p>

### Ce que fait chaque couche

| Couche | Hook | Role | Bloque ? |
|--------|------|------|:---:|
| 1 | `CLAUDE.md` | Conventions du projet, stack, regles de securite | Non |
| 2 | `SessionStart` | Recharge la memoire projet (etat, backlog, decisions, conventions) | Non |
| 3 | **`UserPromptSubmit`** | **LE GARDIEN** — classifie chaque prompt (fix/feature/refactor/question) et injecte le pipeline qualite obligatoire | Non |
| 4 | `PreToolUse` | Bloque les patterns dangereux : secrets en dur, edits `.env`, force push, injection SQL | **Oui** |
| 5 | `PostToolUse` | Auto-format, auto-lint, scan securite, suivi des modifications | Non |
| 6 | **`Stop`** | **LE VERROU** — bloque la fin de session si tests manquants, preuves non satisfaites, ou capitalisation oubliee | **Oui** |

### Classification des pipelines

Le Gardien analyse chaque prompt et injecte le bon pipeline :

| Tu ecris | Detecte comme | Pipeline injecte |
|----------|--------------|------------------|
| "fix le bug de login" | **FIX** | Analyse de cause racine (systematic-debugging) + TDD (test avant fix) + verification des preuves |
| "ajoute le paiement Stripe" | **FEATURE** | Challenge technique (est-ce necessaire ? approche plus simple ? risques ?) + pipeline qualite complet + code review |
| "refactor le module auth" | **REFACTOR** | Challenge (est-ce justifie maintenant ?) + regle zero changement de comportement + parite des tests avant/apres |
| "comment marche le routeur ?" | **QUESTION** | Reponse directe, pas de pipeline |

<p align="center">
  <img src="docs/images/classification.png" alt="Classification des pipelines" width="700"/>
</p>

### Challenge technique (integre)

Avant chaque feature ou refactoring, le systeme force trois questions :

1. **Est-ce vraiment necessaire**, ou un mecanisme existant resout deja le besoin ?
2. **Quelle est l'approche la plus simple** qui repond au besoin ?
3. **Quel est le risque principal** (securite, dette technique, complexite) ?

Si une reponse revele un probleme, l'IA le signale avant d'ecrire une seule ligne de code.

### Memoire automatique

Le systeme maintient la memoire du projet entre les sessions :

<p align="center">
  <img src="docs/images/memory.png" alt="Cycle de memoire automatique" width="700"/>
</p>

Fini le "repartir de zero" a chaque session.

## Installation

### Prerequis

- [Claude Code](https://claude.ai/code) installe
- `python3` installe
- [Plugin Superpowers](https://github.com/anthropics/claude-plugins-official) (recommande)

### Une commande

```bash
git clone https://github.com/yywar/autonomic-nervous-system.git
cd autonomic-nervous-system
bash install.sh
```

L'installeur :
- Sauvegarde votre `settings.json` existant avant toute modification
- Installe 11 skills (jeyant v2 + checkpoint + rodin)
- Active 13 plugins automatiquement
- Fusionne les hooks sans ecraser ceux des plugins
- Ajoute les deny rules de securite
- Desactive les skills legacy conflictuelles
- Installe le template de deploiement projet

Les plugins se telechargeront automatiquement au prochain lancement de Claude Code.

### Deployer sur un projet

```bash
bash ~/.claude/project-template/deploy-to-project.sh /chemin/vers/projet
```

Cela cree :
- `.claude/agents/` — 3 agents de review specialises
- `.claude/hookify.*.local.md` — 4 regles de securite
- `CLAUDE.md` — template a personnaliser avec votre stack
- `docs/` — structure de repertoire pour la memoire projet

## Contenu

### Hooks (globaux, actifs sur tous les projets)

| Fichier | Evenement | Role |
|---------|-----------|------|
| `enforce-pipeline.sh` | UserPromptSubmit | Classifie les requetes, injecte le pipeline obligatoire |
| `session-context.sh` | SessionStart | Recharge la memoire projet + regles systeme |
| `verify-completion.sh` | Stop | Bloque si tests/preuves manquants, force la capitalisation |
| `auto-quality.sh` | PostToolUse | Auto-format, lint, scan securite apres chaque edit |
| `track-changes.sh` | PostToolUse | Suit les fichiers modifies pour les decisions de capitalisation |

### Skills (11 installees dans ~/.claude/skills/)

| Skill | Role |
|-------|------|
| **jeyant** | Pilote principal — orchestre le pipeline complet selon le tier |
| **jeyant-cadrage** | Qualifie et formalise chaque demande en contrat testable |
| **jeyant-brainstorm** | Exploration profonde en 7 phases (3+ approches, simulation agentic, modes d'echec) |
| **jeyant-dev-guard** | Garde-fou pre-implementation (pre-flight, conventions, frontieres de module) |
| **jeyant-plan** | Decoupe en micro-unites testables avec dependances |
| **jeyant-preuves** | Systeme de preuve en deux phases (contrat avant code, verification apres) |
| **jeyant-revue-adverse** | Contre-expertise severe (scope design + scope code) |
| **jeyant-capitalisation** | Capture les lecons apprises, enrichit les conventions |
| **jeyant-createur-competence** | Fabrique de nouvelles skills robustes et testables |
| **checkpoint** | Automatise les commits propres en Conventional Commits |
| **rodin** | Interlocuteur socratique — anti-chambre d'echo |

### Agents (par projet)

| Agent | Focus |
|-------|-------|
| `security-reviewer.md` | OWASP Top 10, injection, XSS, failles d'auth, detection de secrets |
| `a11y-auditor.md` | Conformite WCAG 2.2 Niveau AA |
| `perf-analyst.md` | Taille du bundle, rendu, reseau, Core Web Vitals |

### Regles de securite (par projet, format hookify)

| Regle | Action |
|-------|--------|
| `block-secrets` | **Bloque** les cles API, tokens, mots de passe codes en dur |
| `block-env-commit` | **Bloque** toute modification des fichiers `.env` |
| `warn-sql-injection` | **Avertit** sur la concatenation de chaines dans les requetes SQL |
| `block-force-push` | **Bloque** `git push --force` |

### Deny rules globales (settings.json)

- `rm -rf /` et `rm -rf ~` bloques
- Force push sur main/master bloque
- Acces en lecture a `~/.ssh/`, `~/.aws/`, `~/.gnupg/` bloque

## Compatibilite

Concu pour fonctionner avec :
- **[Superpowers](https://github.com/obra/superpowers)** — TDD, debugging systematique, code review, execution de plans
- **[Feature Dev](https://github.com/anthropics/claude-plugins-official)** — Exploration de codebase, design d'architecture, agents de review

Le systeme complete ces outils en ajoutant la couche d'enforcement qu'ils n'ont pas. Les skills definissent *ce que* la qualite signifie. L'Autonomic Nervous System *garantit* qu'elle se produit.

## Desinstallation

```bash
# Restaurer settings.json
cp ~/.claude/settings.json.bak ~/.claude/settings.json

# Supprimer les hooks
rm ~/.claude/hooks/enforce-pipeline.sh
rm ~/.claude/hooks/session-context.sh
rm ~/.claude/hooks/verify-completion.sh
rm ~/.claude/hooks/auto-quality.sh
rm ~/.claude/hooks/track-changes.sh

# Reactiver les skills legacy (si voulu)
mv ~/.claude/skills/brainstorming/SKILL.md.disabled ~/.claude/skills/brainstorming/SKILL.md
mv ~/.claude/skills/planification/SKILL.md.disabled ~/.claude/skills/planification/SKILL.md
```

## Vue d'ensemble de l'architecture

<p align="center">
  <img src="docs/images/overview.png" alt="Vue d'ensemble de l'architecture" width="700"/>
</p>

## Philosophie

> Les instructions sont des voeux. Les hooks sont des garanties.

Le meilleur processus est celui qu'on ne peut pas sauter. Ce systeme est ne d'une observation simple : les assistants de code IA produisent leur meilleur travail quand ils suivent un processus structure — et leur pire travail quand ils ne le font pas. Au lieu de compter sur le jugement du modele pour suivre le processus, on a rendu le processus incontournable.

## Auteur

**Yann LOMBRET** — [@yywar](https://github.com/yywar)

## Licence

MIT
