# AGENTS.md

Personal override/dotfiles repo layered on [Omarchy](https://github.com/basecamp/omarchy), an Arch/Hyprland desktop. Scripts call `omarchy-*` helpers installed at `~/.local/share/omarchy` and mutate the live `$HOME`. No build, test, or lint — edits are validated only by running on a configured machine.

## Entrypoint

`index.sh` runs sequentially: `uninstall/all.sh` → `install/all.sh` → `overwrite/all.sh` → `config/all.sh`. Full re-run:

```bash
chmod +x $(git ls-files '*.sh') && ./index.sh
```

Scripts resolve their own dir via `SCRIPT_DIR`, so they run from anywhere.

## Layout

- `install/` — one-time package/app setup. Uses `omarchy-pkg-aur-add`, `omarchy-install-dev-env`, `omarchy-tui-install`, `omarchy-webapp-install`, `omarchy-install-browser`. Some clone from the owner's GitHub via `utils/clone.sh`.
- `overwrite/` — layers configs onto `$HOME` via `source-overwrites.sh`: appends `source = ...` lines to hyprland, zsh, bashrc, tmux, ghostty, XCompose. Also creates symlinks for hyprland.lua, hyprsunset, starship, yazi configs.
- `config/` — git aliases (`config/git.sh`) and omarchy plugin setup (`config/omarchy.sh`: clones + installs custom shell plugins, third-party plugins, symlinks `shell.json`).
- `bin/` — custom CLIs symlinked into `~/.local/my-bins` (on PATH via `uwsm/env` and `zsh/shell.sh`): `tmux-session-*`, `herdr-session-*`, `focusd-walker`, `toggle-animation`, `mkrepo`, `start`.
- `files_to_copy/` — full config files symlinked wholesale: `hyprland.lua`, `hyprsunset.conf`, `starship.toml`, `yazi.toml`, `herdr.toml`, `shell.json`, `herdr-automatic-rename.sh`.
- `utils/` — sourced bash libraries (`clone`, `symlink`, `write-to-file`, `tmux`, `herdr`). Guarded by `[[ "${BASH_SOURCE[0]}" == "${0}" ]]` so they no-op when sourced. Source them, don't execute.
- `zsh/` — zsh fragments loaded through `zsh/rc.sh`: `plugins.sh`, `alias.sh`, `shell.sh`, `binds.sh`.
- `uninstall/` — removes stock Omarchy packages (`omarchy-pkg-drop` fixed list) and `omarchy-webapp-remove-all`.

## Key gotchas

- **Install order matters.** `install/all.sh` runs simple scripts inline, launches `herdr.sh` and `lofi-music.sh` in parallel terminals, then chains all AUR scripts sequentially in one terminal (pacman lock conflicts). Don't reorder AUR scripts.
- **Hyprland config is Lua-based.** Active config is `files_to_copy/hyprland.lua` (Omarchy Lua API: `hl.*` global), symlinked to `~/.config/hypr/own_config.lua` and required from `~/.config/hypr/hyprland.lua`. `.luarc.json` points lua-ls at `/usr/share/hypr/stubs` with `hl` as a global for validation.
- **`utils/clone.sh`**: `clone <name> [dest]` — bare names default to `https://github.com/bibekbhusal0/<name>`; supports full URLs and `user/repo` format; skips silently if dest already exists.
- **`utils/write-to-file.sh`**: appends content; skips if the exact string is already present; third arg `true` overwrites the file instead.
- **`utils/symlink.sh`**: replaces existing symlinks; moves real files at dest to `<dest>.bak`.
- **`overwrite/nvim.sh`** is destructive: moves `~/.config/nvim` → `nvim.backup`, `rm -rf`s `~/.local/share/nvim`, clones the owner's kickstart config, then clones 4 personal plugins from `~/Code/nvim-plugins`.
- **`install/others.sh`** builds `focusd` from `~/Code/focusd` via `cargo build --release`; waybar pomodoro module and `focusd-walker` depend on it.
- **`bin/start`** launches apps onto fixed workspaces matched by window class (`com.mitchellh.ghostty`, `zen`, `obsidian`, `spotify`); `install/others.sh` and waybar depend on those class names.
- **herdr session workflow.** `bin/herdr-session-create` / `-search` (via `utils/herdr.sh`) use fzf over open workspaces + zoxide dirs, launching via [herdr-spreader](https://github.com/yuk1ty/herdr-spreader) (`apply --file <dir>/herdr.yml`). A tab must always have at least one pane entry (`- {}` for an empty shell — bare `-` fails to parse). Re-applying is guarded by directory: if a workspace backed by that directory already exists it only switches (same-named sessions in different directories each get their own workspace, renames included).
- **Install scripts launch in separate terminals.** `omarchy-launch-terminal bash "$SCRIPT_DIR/..."` runs scripts outside the main terminal. Errors are swallowed (`&>/dev/null &`). Check terminal output manually if something fails.

## Environment prerequisites

- `cargo` (for `focusd`, `herdr-spreader`)
- `pip3 install tomli tomli-w --break-system-packages` (only needed if TOML merge scripts are added back)
- Network access for `zen-browser.sh`, `lofi-music.sh`, git clones
- Spotify must be opened and logged in before `spicetify backup apply`

## Commit style

Conventional commits with emojis via devmoji: `feat: ✨`, `fix: 🐛`, `refactor: ♻️`, `chore: 🔧`. Alias `gce` does `git commit -am "<devmoji text>"`.
