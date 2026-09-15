#!/bin/bash
set -e

# Refresh the list of available packages
sudo apt update

# Helper tools needed to add extra software sources and downloads
sudo apt install -y --no-install-recommends software-properties-common dirmngr wget curl

# --- Add the CRAN repository (for the latest R) ---
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo tee /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc > /dev/null
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# --- Install apps from repositories ---
sudo apt install -y git
sudo apt install -y --no-install-recommends r-base r-base-dev

# --- RStudio (latest stable version from Posit) ---
RSTUDIO_LATEST_LINK="https://rstudio.org/download/latest/stable/desktop/jammy/rstudio-latest-amd64.deb"
DOWNLOAD_DIR="$HOME/.cache/ubuntu-setup"

# Find out which file the "latest" link currently points to
RSTUDIO_URL=$(curl -fsIL -o /dev/null -w '%{url_effective}' "$RSTUDIO_LATEST_LINK")
RSTUDIO_FILE=$(basename "$RSTUDIO_URL")

# Stop if we didn't get a sensible file name
if [[ "$RSTUDIO_FILE" != rstudio-*.deb ]]; then
  echo "Could not work out the latest RStudio download."
  exit 1
fi
echo "Latest RStudio: $RSTUDIO_FILE"

mkdir -p "$DOWNLOAD_DIR"
wget -c -P "$DOWNLOAD_DIR" "$RSTUDIO_URL"
sudo apt install -y "$DOWNLOAD_DIR/$RSTUDIO_FILE"

echo "Done."
