# Repository Notes

- This is a collection of separate Godot projects, one per top-level game directory with its own `project.godot` and `export_presets.cfg`; current projects are `breakout`, `pong`, and `space-invaders`.
- CI discovers games by finding `./*/project.godot`, so adding a new top-level Godot project automatically adds it to the Pages build matrix.
- GitHub Pages builds use Godot `4.6.0` with export templates and run `godot --headless --path <game> --import --quit` before `godot --headless --path <game> --export-release Web "$GITHUB_WORKSPACE/build/<game>/index.html"`.
- The tracked `site/` folder is only the static shell; CI copies it to `public/` and rewrites the `<!-- games:start -->` / `<!-- games:end -->` block in `site/index.html` from exported game artifact names.
- Generated/editor artifacts are intentionally not source: `.godot/`, `*.tmp`, `/site/games/`, and root `build/` are ignored.

## Godot Projects

- `breakout` uses `res://src/` for gameplay scripts, `res://scenes/` for scenes, and has vendored GUT under `breakout/addons/gut` enabled in `breakout/project.godot`.
- `pong` keeps its main scene/script at project root (`pong.tscn`, `pong.gd`) plus root-level component scripts.
- `space-invaders` currently uses `src/main.tscn` as its main scene and has no gameplay scripts checked in yet.

## Commands

- Import a project before headless export or tests: `godot --headless --path breakout --import --quit`.
- Export one game like CI: `godot --headless --path breakout --export-release Web "$PWD/build/breakout/index.html"`.
