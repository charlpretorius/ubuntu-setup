#!/bin/bash
set -e

# Install English language packs (translations for the system and GNOME)
sudo apt install -y language-pack-en language-pack-gnome-en

# Make sure the South African locale exists on this machine
sudo locale-gen en_ZA.UTF-8

# Set South African English as the language and default for all formats
sudo update-locale --reset \
  LANG=en_ZA.UTF-8 \
  LANGUAGE=en_ZA:en_GB:en

echo "Done. Log out and back in for the changes to take effect."
