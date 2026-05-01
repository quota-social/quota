#!/usr/bin/env bash
set -euo pipefail

APP_NAME="quota-social"
APP_VERSION="1.0.1"
ARCH="amd64"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEB_FILE="$ROOT_DIR/pkg-deb/${APP_NAME}_${APP_VERSION}_${ARCH}.deb"
REPO_DIR="$ROOT_DIR/apt-repo"
POOL_DIR="$REPO_DIR/pool/main/q/$APP_NAME"
DIST_DIR="$REPO_DIR/dists/stable/main/binary-$ARCH"

if [[ ! -f "$DEB_FILE" ]]; then
  echo "Paquet Debian introuvable : $DEB_FILE"
  exit 1
fi

rm -rf "$REPO_DIR"
mkdir -p "$POOL_DIR"
mkdir -p "$DIST_DIR"

cp "$DEB_FILE" "$POOL_DIR/"

cd "$REPO_DIR"
dpkg-scanpackages --multiversion pool > "$DIST_DIR/Packages"
gzip -k -f "$DIST_DIR/Packages"
apt-ftparchive release dists/stable > dists/stable/Release

echo "Depot APT cree dans : $REPO_DIR"

