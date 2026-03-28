# template ADR

A utiliser quand le brainstorm porte sur une decision structurante.

```markdown
# ADR-NNN — [Titre] (DRAFT)

## Contexte
[Pourquoi cette decision etait necessaire — le probleme, pas la solution]

## Decision
[Ce qui a ete decide — concret et actionnable]

## Alternatives evaluees

### [Nom approche A]
[Resume + raison du rejet]

### [Nom approche B]
[Resume + raison du rejet]

## Consequences

### Sur le code
[Quels modules, fichiers, patterns sont impactes]

### Sur les conventions
[Nouveaux patterns a documenter, anti-patterns a interdire]

### Sur les modules
[Dependances creees ou modifiees]

## Risques acceptes
[Modes d'echec connus et mitigations choisies]

## Statut
DRAFT — a valider par l'utilisateur
```

## regles

- Le numero NNN est le prochain disponible dans `docs/decisions/`
- Le titre doit etre descriptif (pas "choix technique" mais "strategie d'authentification JWT")
- L'ADR passe de DRAFT a FINAL apres validation explicite de l'utilisateur
