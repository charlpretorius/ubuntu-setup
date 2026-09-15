#!/bin/bash
set -e

# Run this as yourself (no sudo), while logged in to the desktop.

# Apps to pin to the dash, by their .desktop file name
APPS=(
  "code.desktop"      # VS Code
  "rstudio.desktop"   # RStudio
)

for app in "${APPS[@]}"; do
  # Skip apps that aren't installed
  if [[ ! -f "/usr/share/applications/$app" && ! -f "$HOME/.local/share/applications/$app" ]]; then
    echo "Not installed, skipping: $app"
    continue
  fi

  # Read the current list of pinned apps
  current=$(gsettings get org.gnome.shell favorite-apps)

  # Skip apps that are already pinned
  if [[ "$current" == *"'$app'"* ]]; then
    echo "Already in dash: $app"
    continue
  fi

  # Add the app to the end of the list
  if [[ "$current" == "@as []" || "$current" == "[]" ]]; then
    new="['$app']"
  else
    new="${current%]}, '$app']"
  fi

  gsettings set org.gnome.shell favorite-apps "$new"
  echo "Added to dash: $app"
done

echo "Done."
