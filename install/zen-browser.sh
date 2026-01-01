#!/bin/bash

yay -Sy --noconfirm --needed zen-browser-bin

# Also download sine it can't run automotically i will run it later
cd ~/Downloads
curl -L -o sine https://github.com/CosmoCreeper/Sine/releases/latest/download/sine-linux-x64
chmod +x ./sine

echo "Sine has ben downloaded to ~/Downloads/sine make sure to run it"
