#!/bin/bash

omarchy-pkg-aur-add bitwarden
omarchy-pkg-aur-add bitwarden-cli
omarchy-pkg-aur-add helium-browser-bin
omarchy-pkg-aur-add hypruler-bin
omarchy-pkg-aur-add vesktop-bin
omarchy-pkg-aur-add losslesscut-bin
omarchy-pkg-aur-add yazi

omarchy-install-dev-env node
omarchy-install-dev-env bun
omarchy-install-dev-env python
omarchy-install-terminal ghostty
omarchy-default-terminal ghostty

bun install -g devmoji
bun install -g yarn

source "$(dirname "${BASH_SOURCE[0]}")/../utils/clone.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/symlink.sh"
clone focusd ~/Code/focusd
cargo clean --manifest-path ~/Code/focusd/Cargo.toml
cargo build --release --manifest-path ~/Code/focusd/Cargo.toml
cp ./target/release/focusd ~/.cargo/bin/focusd
cargo build --no-default-features --features dev-build --manifest-path ~/Code/focusd/Cargo.toml
create_symlink ~/Code/focusd/target/debug/focusd ~/.cargo/bin/focusd-dev
