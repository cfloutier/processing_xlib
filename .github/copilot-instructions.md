# Processing xLib — Contexte Copilot

- Librairie partagée `xLib` centralisée dans ce repo (`processing_xlib/`)
- Les fichiers `xLib_*.pde` sont **copiés** dans chaque projet Processing (pas de lien symbolique)
  - Projets synchronisés : `spiral`, `perlin_mountains`, `image_lines`, `gravity`, `image_dots`
  - Liste définie dans `sync-tools/projects.ps1` (`$projectNames`)
- Processing impose cette copie car il ne supporte pas les imports de dossiers externes
- **Workflow de modification** : les changements xLib sont toujours faits en premier dans un projet, puis transférés vers `processing_xlib/` (pull), puis poussés vers les autres projets (push). Les projets receveurs nécessitent souvent des adaptations après mise à jour.
- Synchronisation via scripts PowerShell dans `sync-tools/` :
  - `pull-from-projects.ps1` — ramène les modifs des projets vers le repo central
  - `push-to-projects.ps1` — pousse les modifs du repo central vers les projets
  - `projects.ps1` — liste des projets cibles
