#!/usr/bin/env bash
set -e

if [ ! -d "$HOME/Music/lofimusic" ]; then
  mkdir -p "$HOME/Music/lofimusic"
  curl -L -o "$HOME/Music/lofimusic/openlofi.zip" "https://github.com/btahir/open-lofi/releases/download/v1.0.0/openlofi.zip"
  unzip -o "$HOME/Music/lofimusic/openlofi.zip" -d "$HOME/Music/lofimusic"
  rm "$HOME/Music/lofimusic/openlofi.zip"
fi


omarchy-tui-install "Lofi Music" "cliamp --shuffle --auto-play $HOME/Music/lofimusic/" tile "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu1U7EHisLuM3va3QRXNBmnSiSHFc1QnidSYaeoiv9qz-LZkn6KYlysHQ&s=10"

source "$(dirname "${BASH_SOURCE[0]}")/../utils/write-to-file.sh"
write_to_file "$HOME/.config/systemd/user/cliamp.service" "$(cat <<'EOF'
[Unit]
Description=cliamp headless music player

[Service]
ExecStart=/usr/bin/cliamp --daemon --shuffle --auto-play $HOME/Music/lofimusic/
Restart=on-failure

[Install]
WantedBy=default.target
EOF
)" true
systemctl --user enable cliamp
