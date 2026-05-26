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

## Export SVG direct (v3.0.0)

- `writeSVGDirect()` dans `xLib_ExportUtils.pde` — écrit l'SVG en pur Java sans le renderer Processing
  - Plus rapide, progression console toutes les 10%, AxiDraw-compatible nativement
  - Fallback automatique vers renderer Processing si `export_group == null` ou `PAPER_NONE`
  - Bouton "SVG (Processing)" dans le GUI pour forcer l'ancien mode
  - Export PDF supprimé du GUI

- **Connexion dans un sketch** — une ligne dans `setup()` après `setupControls()` :
  ```java
  file_ui.export_group  = lineGroup;    // PolylineGroup : spiral, perlin_mountains, image_lines
  file_ui.export_shapes = shapesGroup;  // ShapesGroup   : image_dots (dots + polylines)
  ```
  `export_shapes` a priorité sur `export_group`. Les deux sont null → fallback renderer Processing.

- **Transform** : auto-centrage via bbox, scale `export_scale * (25.4/96)`, rotation -90deg optionnelle
- **stroke_mm** = `data.style.lineWidth * export_scale * (25.4/96)`

- **Adaptation par sketch (TODO)** :
  - `spiral`, `perlin_mountains` — vérifier nom du PolylineGroup dans le générateur
  - `image_lines` — `file_ui.export_group = generator.group;`
  - `image_dots` — `file_ui.export_shapes = shapesGroup;` (ShapesGroup avec dots)
  - `gravity` — non adapté à l'export pour l'instant
