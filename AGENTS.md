# AGENTS.md

Personal override/dotfiles repo layered on top of [Omarchy](https://github.com/basecamp/omarchy), an Arch/Hyprland desktop distro. It is not a standalone app: scripts call `omarchy-*` helpers installed at `~/.local/share/omarchy` and mutate the live `$HOME`. There is no build, test, or lint step — edits are validated only by running on a configured machine.

## Layout

- `index.sh` — entrypoint: `uninstall/all.sh` → `install/all.sh` → `overwrite/all.sh` → `git-config.sh`. Scripts resolve their own dir via `SCRIPT_DIR`, so they run from anywhere. Full re-run: `chmod +x $(git ls-files '*.sh') && ./index.sh`.
- `install/` — one-time package/app setup. Uses Omarchy helpers: `omarchy-pkg-aur-add`, `omarchy-install-dev-env`, `omarchy-tui-install`, `omarchy-webapp-install`, `omarchy-install-browser`. Some clone from the owner's GitHub (see `utils/clone.sh`).
- `overwrite/` — layers configs onto `$HOME`. Two mechanisms, don't mix them up:
  - Append absolute-path `source = ...` lines with `write_to_file` (`source-overwrites.sh`): `hyprland.overwrite.conf`, `hyprlock.overwrite.conf`, `zsh/rc.sh`, `bashrc`, `tmux.conf`, `ghostty.config`, `.XCompose`.
  - `overwrite-toml.sh` merges TOML keys into app configs via `overwrite/toml/overwrite.py` (deep-merge, overwrite wins) and symlinks starship. Requires `pip3 install tomli tomli-w --break-system-packages`.
  - `waybar.sh` symlinks the whole `files_to_copy/waybar/` dir.
- `bin/` — custom CLIs symlinked into `~/.local/my-bins` (on `PATH` via `uwsm/env` and `zsh/shell.sh`): `tmux-session-*`, `herdr-session-*`, `focusd-walker`, `toggle-animation`, `mkrepo`, `start`.
- `files_to_copy/` — full config files symlinked wholesale: `waybar/`, elephant menu lua files.
- `utils/` — sourced bash libraries (`clone`, `symlink`, `write-to-file`, `tmux`, `herdr`), guarded by `[[ "${BASH_SOURCE[0]}" == "${0}" ]]` so they no-op when sourced. Source them, don't execute.
- `zsh/` — zsh fragments loaded through `zsh/rc.sh` (`plugins.sh`, `alias.sh`, `shell.sh`, `binds.sh`).
- `uninstall/` — removes stock Omarchy packages (`yay -R` fixed list) and `omarchy-webapp-remove-all`.

## Gotchas

- **Hyprland is mid-migration.** Active config is `overwrite/hyprland.overwrite.conf` (classic `bindd`/`unbind` syntax, sourced). `files_to_copy/hyprland.lua` is the new Omarchy Lua API (`hl.*` global), currently commented out in `overwrite/source-overwrites.sh`. The working branch is `hyprland-lua`. When adding a keybind, keep both files in sync.
- **No tests/lint.** Closest to a check: `overwrite/toml/overwrite.py` (Python) and `.luarc.json` points lua-ls at `/usr/share/hypr/stubs` with `hl` as a global. Verify Lua by editing in a lua-ls-aware editor.
- `utils/clone.sh`: `clone <name> [dest]` — bare names default to `https://github.com/bibekbhusal0/<name>`; skips silently if dest already exists.
- `utils/write-to-file.sh`: appends content; skips if the exact string is already present; third arg `true` overwrites the file instead.
- `utils/symlink.sh`: replaces an existing symlink; a real file at the dest is moved to `<dest>.bak`.
- `overwrite/nvim.sh` is destructive: moves `~/.config/nvim` → `nvim.backup`, `rm -rf`s `~/.local/share/nvim`, then clones the owner's kickstart config.
- `install/others.sh` builds the `focusd` pomodoro tool from `~/Code/focusd` via `cargo build`; the waybar pomodoro module and `focusd-walker` depend on it.
- **herdr session workflow.** `bin/herdr-session-create` / `-search` (via `utils/herdr.sh`) are the herdr equivalents of the tmux pair: fzf over open workspaces + zoxide dirs, launching via [herdr-spreader](https://github.com/yuk1ty/herdr-spreader) (`apply --file <dir>/herdr.yml`). Projects keep a `herdr.yml` layout next to `.tmuxinator.yml` (tracked in each project's git); a tab must always have at least one pane entry (`- {}` for an empty shell — bare `-` fails to parse, and *any* validation warning makes apply exit 1). Re-applying is guarded: if a workspace with the layout's `name:` already exists it only switches.
- `bin/start` launches apps onto fixed workspaces matched by window class; `install/others.sh` and waybar depend on those class names.
- `install/zen-browser.sh` and `install/lofi-music.sh` download binaries/zip into `~/Downloads` / `~/Music` — network + manual steps required.

## Commit style

Conventional commits with emojis via devmoji: `feat: ✨`, `fix: 🐛`, `refactor: ♻️`, `chore: 🔧`. Alias `gce` does `git commit -am "<devmoji text>"`.
