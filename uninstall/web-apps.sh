#!/bin/bash

apps=(HEY Basecamp WhatsApp "Google Photos" "Google Contacts" "Google Messages" "X" "Figma" "Zoom" "Fizzy")

for app in "${apps[@]}"; do
  omarchy-webapp-remove
done
