#!/usr/bin/env bash
set -e

if [ ! -d "$HOME/Music/lofimusic" ]; then
  mkdir -p "$HOME/Music/lofimusic"
  curl -L -o "$HOME/Music/lofimusic/openlofi.zip" "https://github.com/btahir/open-lofi/releases/download/v1.0.0/openlofi.zip"
  unzip -o "$HOME/Music/lofimusic/openlofi.zip" -d "$HOME/Music/lofimusic"
  rm "$HOME/Music/lofimusic/openlofi.zip"
fi


omarchy-tui-install "Lofi Music" "cliamp --shuffle --auto-play ~/Music/lofimusic/" tile "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu1U7EHisLuM3va3QRXNBmnSiSHFc1QnidSYaeoiv9qz-LZkn6KYlysHQ&s=10"
