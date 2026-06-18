#!/bin/bash
echo "Installing Neovim plugins (headless)..."

max_retries=5
count=0
success=false

while [ $count -lt $max_retries ]; do
  if nvim --headless --cmd "let g:lazy_concurrency=1" "+Lazy! sync" +qa; then
    success=true
    break
  fi
  count=$((count+1))
  if [ $count -lt $max_retries ]; then
    echo "Neovim plugin installation failed (Attempt $count). Retrying in 5 seconds..."
    sleep 5
  fi
done

if [ "$success" = false ]; then
  echo "Warning: Neovim plugins failed to install after $max_retries attempts. Continuing setup..."
fi
