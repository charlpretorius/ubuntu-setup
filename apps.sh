#!/bin/bash
set -e

# Refresh the list of available packages
sudo apt update

# Helper tools needed to add extra software sources and downloads
sudo apt install -y --no-install-recommends software-properties-common dirmngr wget curl gpg

# --- Add the CRAN repository (for the latest R) ---
# Download CRAN's signing key so Ubuntu trusts its packages
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo tee /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc > /dev/null

# Add the CRAN software source for this Ubuntu version
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# --- Add the Microsoft repository (for VS Code) ---
# Download Microsoft's signing key and convert it to the format apt expects
wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
  | sudo gpg --dearmor --yes -o /usr/share/keyrings/microsoft.gpg

# Tell apt where to find VS Code
sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null << 'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# We added the repository ourselves, so tell the VS Code package not to add another copy
echo "code code/add-microsoft-repo boolean false" | sudo debconf-set-selections

# Read the newly added repositories
sudo apt update

# --- Install apps from repositories ---
sudo apt install -y git
sudo apt install -y --no-install-recommends r-base r-base-dev
sudo apt install -y code

# LaTeX: basic version now; swap the # to the other line to get everything
sudo apt install -y texlive-latex-extra latexmk
# sudo apt install -y texlive-full latexmk

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

# Download (skipped if already downloaded) and install
mkdir -p "$DOWNLOAD_DIR"
wget -c -P "$DOWNLOAD_DIR" "$RSTUDIO_URL"
sudo apt install -y "$DOWNLOAD_DIR/$RSTUDIO_FILE"

# --- VS Code extensions (run as you, not with sudo) ---
code --install-extension James-Yu.latex-workshop

echo "Done."
