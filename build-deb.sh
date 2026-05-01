#!/usr/bin/env bash
set -euo pipefail

APP_NAME="quota-social"
APP_VERSION="1.0.1"
ARCH="amd64"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$ROOT_DIR/pkg-deb"
BUILD_DIR="$PKG_DIR/${APP_NAME}_${APP_VERSION}_${ARCH}"
DIST_BIN="$ROOT_DIR/dist/$APP_NAME"
OUTPUT_DEB="$PKG_DIR/${APP_NAME}_${APP_VERSION}_${ARCH}.deb"

if [[ ! -f "$DIST_BIN" ]]; then
  echo "Binaire introuvable : $DIST_BIN"
  echo "Genere d'abord le binaire Linux avec PyInstaller :"
  echo "python3 -m PyInstaller --onefile --windowed --name $APP_NAME main.py"
  exit 1
fi

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/opt/$APP_NAME"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/usr/share/applications"

cp "$PKG_DIR/DEBIAN/control" "$BUILD_DIR/DEBIAN/control"
cp "$PKG_DIR/DEBIAN/postinst" "$BUILD_DIR/DEBIAN/postinst"
cp "$PKG_DIR/usr/bin/$APP_NAME" "$BUILD_DIR/usr/bin/$APP_NAME"
cp "$PKG_DIR/usr/share/applications/$APP_NAME.desktop" "$BUILD_DIR/usr/share/applications/$APP_NAME.desktop"
cp "$DIST_BIN" "$BUILD_DIR/opt/$APP_NAME/$APP_NAME"
cp "$ROOT_DIR/.ascii" "$BUILD_DIR/opt/$APP_NAME/.ascii"

chmod 0755 "$BUILD_DIR/usr/bin/$APP_NAME"
chmod 0755 "$BUILD_DIR/opt/$APP_NAME/$APP_NAME"
chmod 0644 "$BUILD_DIR/DEBIAN/control"
chmod 0755 "$BUILD_DIR/DEBIAN/postinst"
chmod 0644 "$BUILD_DIR/usr/share/applications/$APP_NAME.desktop"
chmod 0644 "$BUILD_DIR/opt/$APP_NAME/.ascii"

dpkg-deb --build "$BUILD_DIR" "$OUTPUT_DEB"

echo "Paquet cree : $OUTPUT_DEB"
