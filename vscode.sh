#!/bin/bash
set -e

# Run this as yourself (no sudo).

# The folder this script is in, so it works no matter where you run it from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE="$SCRIPT_DIR/vscode/settings.json"
TARGET_DIR="$HOME/.config/Code/User"
TARGET="$TARGET_DIR/settings.json"

# Stop if the settings file is missing from the setup folder
if [[ ! -f "$SOURCE" ]]; then
  echo "Cannot find $SOURCE"
  exit 1
fi

# Make sure VS Code's settings folder exists
mkdir -p "$TARGET_DIR"

# Back up the current settings if they differ from ours
if [[ -f "$TARGET" ]] && ! cmp -s "$SOURCE" "$TARGET"; then
  BACKUP="$TARGET.backup-$(date +%Y%m%d-%H%M%S)"
  cp "$TARGET" "$BACKUP"
  echo "Backed up existing settings to: $BACKUP"
fi

# Copy our settings into place
cp "$SOURCE" "$TARGET"

echo "Done. VS Code settings are in $TARGET"
