#!/bin/bash
set -e

# Refresh the list of available packages
sudo apt update

# Helper tools needed to add extra software sources
sudo apt install -y --no-install-recommends software-properties-common dirmngr wget

# --- Add the CRAN repository (for the latest R) ---
# Download CRAN's signing key so Ubuntu trusts its packages
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo tee /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc > /dev/null

# Add the CRAN software source for this Ubuntu version
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# --- Install apps ---
sudo apt install -y git
sudo apt install -y --no-install-recommends r-base r-base-dev

echo "Done."
