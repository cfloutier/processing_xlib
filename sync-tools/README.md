# xLib Sync Tools

PowerShell tools to synchronize shared xLib files between Processing projects and the centralized xLib repository.

## Quick start

Use this section for day-to-day operations:

```powershell
# Pull xLib changes from one source project into processing_xlib
.\pull-from-projects.ps1 spiral

# Push xLib changes from processing_xlib to all projects
.\push-to-projects.ps1 all

# Safe preview mode (no file copy)
.\pull-from-projects.ps1 spiral -dry
.\push-to-projects.ps1 all -dry

# Interactive menus
.\pull-from-projects.ps1
.\push-to-projects.ps1
```

Typical flow:

1. Edit and test in one project.
2. Pull into processing_xlib.
3. Review and commit in processing_xlib.
4. Push to all projects.

## Architecture

```text
processing_xlib/ (central repository - source of truth)
├── xLib_*.pde (shared files)
├── .git/
└── sync-tools/
    ├── push-to-projects.ps1
    ├── pull-from-projects.ps1
    ├── projects.ps1
    └── README.md

spiral/, perlin_mountains/, image_lines/, gravity/, image_dots/, image_contours/, curved_lines/
├── xLib_*.pde (synchronized copies)
└── [other project files]
```

## Usage

### Push and pull behavior

Both scripts share a similar interface, but they operate differently:

**Push xLib to projects** - can target all projects or one project.

```powershell
.\push-to-projects.ps1 all                # Push xLib to every configured project
.\push-to-projects.ps1 spiral             # Push xLib only to spiral
.\push-to-projects.ps1                    # Interactive menu: 0=all, 1..N=single project
```

**Pull from one project** - always one project at a time.

```powershell
.\pull-from-projects.ps1 spiral           # Pull from spiral to processing_xlib
.\pull-from-projects.ps1                  # Interactive menu: choose one project
```

### Options

- `-dry`: Dry run mode (shows what would change without copying files).
- Any unknown project name or invalid choice returns an error.

### Examples

**Push to all projects**

```powershell
.\push-to-projects.ps1 all
```

**Pull from one project**

```powershell
.\pull-from-projects.ps1 spiral
```

**Use interactive mode**

```powershell
.\push-to-projects.ps1                    # Includes "0. all"
.\pull-from-projects.ps1                  # One-project selection only
```

**Preview changes first (dry run)**

```powershell
.\push-to-projects.ps1 all -dry
.\pull-from-projects.ps1 spiral -dry
```

## Recommended workflow

### When you modify xLib inside a project

```powershell
# 1) Edit and test inside the source project

# 2) Pull changes back to processing_xlib (one project at a time)
.\pull-from-projects.ps1 spiral

# 3) Review and commit from processing_xlib
cd C:\dev\__tracer\processing\processing_xlib
git add xLib_*.pde
git commit -m "Update xLib: description of changes"
git push
```

### When you need to distribute xLib changes

```powershell
# Push to every configured project
.\push-to-projects.ps1 all

# Or push to a single project
.\push-to-projects.ps1 spiral
```

### Add a new project

If you add a new Processing project that depends on xLib:

1. Add the project name to `$projectNames` in `projects.ps1`.
2. Keep the folder name identical to the project name.
3. The scripts will include it automatically in their menus.

## How it works

The scripts use SHA256 hashes to detect changes by content:

- **push-to-projects.ps1**: copies from processing_xlib to one or more projects.
- **pull-from-projects.ps1**: copies from one selected project to processing_xlib.

If hashes are identical, nothing is copied.

### Why pull is one-project-only

- It avoids accidental merge conflicts.
- It keeps the source of truth explicit for each pull operation.
- It enforces a clean flow: pull from one project, review, commit, then push.

## Configuration

### `projects.ps1`

Central configuration file for project names. Update it only when the project list changes.

```powershell
$projectNames = @(
    "spiral",
    "perlin_mountains",
    "image_lines",
    "gravity",
    "image_dots",
    "image_contours",
    "curved_lines"
)

# Paths are built automatically from project names
$projectPaths = @{}
$projectNames | ForEach-Object { $projectPaths[$_] = Join-Path $processingDir $_ }
```

## Managed files

The scripts automatically synchronize every file matching `xLib_*.pde`, regardless of how many files exist.

No script change is required when new `xLib_*.pde` files are added.

## Notes

- The scripts are non-destructive and compare content before copying.
- Use `-dry` to safely preview operations.
- Files are compared by hash (content), not by last modified date.
- Export outputs and generated artifacts are not part of the sync; only `xLib_*.pde` files are handled.

## Troubleshooting

**Error: "Unknown project" or "Project not found"**

- Check the project name in `projects.ps1`.
- Make sure the target project folder exists under the Processing root directory.

**Error: "Missing files in xlib repo"**

- `processing_xlib` may not contain all expected `xLib_*.pde` files yet.
- Pull from the correct source project first.

**Script does not run**

- Check PowerShell execution policy:

```powershell
Get-ExecutionPolicy
```

- If needed, allow script execution for the current session only:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```
