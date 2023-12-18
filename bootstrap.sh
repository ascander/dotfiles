#!/usr/bin/env bash
#
# bootstrap.sh - bootstraps a fresh macOS installation
#
# This script is intended to be run exactly once, with a fresh install of macOS, and performs the following actions:
#
#     - Installs the latest Xcode command line developer tools
#     - Installs Homebrew

# Sane behavior (see http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail
IFS=$'\n\t'

echo "[bootstrap.sh] - Installing Xcode developer tools"
xcode-select --install

echo "[bootstrap.sh] - Installing Homebrew"
if [[ -d "/usr/local/bin" ]]; then
	exit 0
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
