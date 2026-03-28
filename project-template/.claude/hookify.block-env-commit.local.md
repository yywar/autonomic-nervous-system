---
name: block-env-files
enabled: true
event: file
action: block
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.env($|\.\w+$)
---

**Modification de fichier .env bloquee !**

Les fichiers `.env` contiennent des secrets et ne doivent pas etre modifies par l'agent.
Demandez a l'utilisateur de modifier le fichier manuellement.
