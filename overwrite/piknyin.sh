# Disable fcitx5 Ctrl+Alt+J "Toggle completion" hotkey to prevent
# "Completion enabled/disabled" notification. An empty key list unbinds the key.
PYNII_CONF="$HOME/.config/fcitx5/conf/pinyin.conf"
mkdir -p "$(dirname "$PYNII_CONF")"
if [[ -f "$PYNII_CONF" ]]; then
  existing=$(<"$PYNII_CONF")
  if [[ "$existing" != *"[Hotkey/ToggleCompletion]"* ]]; then
    # Append the unbinding section only if not already present
    printf '\n# Disable Ctrl+Alt+J "Toggle completion" hotkey.\n# An empty key list means unbound, so the\n# "Completion enabled/disabled" notification can no longer fire.\n[Hotkey/ToggleCompletion]\n' >> "$PYNII_CONF"
    echo "Added fcitx5 ToggleCompletion unbinding to $PYNII_CONF"
  else
    echo "fcitx5 ToggleCompletion unbinding already present in $PYNII_CONF"
  fi
else
  # Create the file with the unbinding section
  printf '# Keep Pinyin offline without prompting to enable cloud prediction.\nFirstRun=False\nCloudPinyinEnabled=False\n\n# Disable Ctrl+Alt+J "Toggle completion" hotkey.\n# An empty key list means unbound, so the\n# "Completion enabled/disabled" notification can no longer fire.\n[Hotkey/ToggleCompletion]\n' > "$PYNII_CONF"
  echo "Created $PYNII_CONF with fcitx5 ToggleCompletion unbinding"
fi
