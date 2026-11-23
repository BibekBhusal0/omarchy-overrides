#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/symlink.sh"

REPO=arxhr007/lxask
DATA="$HOME/.local/share/lxask"
BIN="$HOME/.local/bin"
BASE="https://github.com/$REPO/releases/latest/download"

# Skip the 1.1 GB download when the installed version is already the newest.
installed="$("$BIN/lxask" --version 2>/dev/null | awk '{print $2}' || true)"
latest="$(curl -sIL -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest" | sed 's#.*/tag/v\?##')"
if [[ -n "$installed" && "$installed" == "$latest" ]]; then
  echo "lxask $installed is current"
  exit 0
fi

if grep -qw avx2 /proc/cpuinfo && grep -qw fma /proc/cpuinfo; then
  PROGRAM=lxask-x86_64-v3
else
  PROGRAM=lxask-x86_64
fi

mkdir -p "$DATA/models" "$BIN"
stage="$(mktemp -d "$DATA/.download.XXXXXX")"
trap 'rm -rf "$stage"' EXIT

# SHA256SUMS doubles as the manifest: the model and adapter filenames change per release.
curl -fsSL -o "$stage/SHA256SUMS" "$BASE/SHA256SUMS"
MODEL="$(grep -oE 'lxask-[^ ]+\.gguf' "$stage/SHA256SUMS" | head -n 1)"
read -ra ADAPTERS <<<"$(grep -oE '(restrict|precision)-[^ ]+\.gguf' "$stage/SHA256SUMS" | tr '\n' ' ')"

for name in "$PROGRAM" "$MODEL" embed.gguf docs.sqlite "${ADAPTERS[@]}"; do
  echo "fetching $name"
  curl -fL --retry 3 -O --output-dir "$stage" "$BASE/$name"
done

(cd "$stage" && sha256sum -c --quiet --ignore-missing SHA256SUMS)
chmod 755 "$stage/$PROGRAM"
"$stage/$PROGRAM" --version >/dev/null

# A server from the previous build would keep answering with the old model.
"$BIN/lxask" --stop >/dev/null 2>&1 || true

mv -f "$stage/$PROGRAM" "$BIN/lxask"
mv -f "$stage/$MODEL" "${ADAPTERS[@]/#/$stage/}" "$DATA/models/"
mv -f "$stage/embed.gguf" "$stage/docs.sqlite" "$DATA/"

# Old models are dead weight once the new one is in place.
find "$DATA/models" -name '*.gguf' \
  ! -name "$MODEL" $(printf '! -name %s ' "${ADAPTERS[@]}") -delete

create_symlink "$DATA/models/$MODEL" "$DATA/model.gguf"
for name in "${ADAPTERS[@]}"; do
  create_symlink "$DATA/models/$name" "$DATA/${name%%-*}.gguf"
done

if [[ ! -f "$DATA/settings" ]]; then
  printf 'serve = auto\n' >"$DATA/settings"
fi

echo "installed $("$BIN/lxask" --version) into $BIN, data in $DATA"
