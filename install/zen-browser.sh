#!/bin/bash

omarchy-install-browser zen

# Also download sine it can't run automotically i will run it later
cd ~/Downloads || exit 
curl -L -o sine https://github.com/CosmoCreeper/Sine/releases/latest/download/sine-linux-x64
chmod +x ./sine

echo "Sine has been downloaded to ~/Downloads/sine make sure to run it"
# Command required for sine to work
sudo chown "$(whoami)":"$(whoami)" -R ~/.zen/*/
