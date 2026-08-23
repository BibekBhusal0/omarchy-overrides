#!/bin/bash

omarchy-pkg-aur-add \
  bitwarden \
  bitwarden-cli \
  helium-browser-bin \
  hypruler-bin \
  vesktop-bin \
  omniroute-bin \
  yazi

omarchy-install-dev-env node
omarchy-install-dev-env bun
omarchy-install-dev-env python
omarchy-install-terminal ghostty
omarchy-default-terminal ghostty

bun install -g devmoji yarn omniroute

opencode_config="$HOME/.config/opencode/opencode.json"
mkdir -p "$HOME/.config/opencode"
[ -f "$opencode_config" ] || echo '{}' > "$opencode_config"
jq '
  .plugin = ((.plugin // []) + ["opencode-omniroute-auth"] | unique)
' "$opencode_config" > "$opencode_config.tmp" && mv "$opencode_config.tmp" "$opencode_config"

source "$(dirname "${BASH_SOURCE[0]}")/../utils/clone.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/symlink.sh"

clone focusd ~/Code/focusd
cargo clean --manifest-path ~/Code/focusd/Cargo.toml
cargo build --release --manifest-path ~/Code/focusd/Cargo.toml
cp ./target/release/focusd ~/.cargo/bin/focusd
cargo build --no-default-features --features dev-build --manifest-path ~/Code/focusd/Cargo.toml
create_symlink ~/Code/focusd/target/debug/focusd ~/.cargo/bin/focusd-dev
