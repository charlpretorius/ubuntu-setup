#!/bin/bash
set -e

# Refresh the list of available packages
sudo apt update

# Install apps
sudo apt install -y git

echo "Done."
