#!/usr/bin/env bash
# Muxy AI Kit installer — installs commands into .claude/ or .opencode/.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash -s -- claude
#   curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash -s -- opencode
set -euo pipefail

REPO="${MUXY_AI_KIT_REPO:-muxy-app/ai-kit}"
REF="${MUXY_AI_KIT_REF:-main}"
TARBALL="https://codeload.github.com/${REPO}/tar.gz/refs/heads/${REF}"

for cmd in curl tar; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: $cmd is required" >&2
    exit 1
  fi
done

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  if [ -t 0 ] || [ -e /dev/tty ]; then
    printf "Install for [c]laude or [o]pencode? " > /dev/tty
    read -r ans < /dev/tty
    case "$ans" in
      c|C|claude) TARGET="claude" ;;
      o|O|opencode) TARGET="opencode" ;;
      *) echo "error: invalid choice" >&2; exit 1 ;;
    esac
  else
    echo "error: no target given. Pass 'claude' or 'opencode' as argument." >&2
    exit 1
  fi
fi

case "$TARGET" in
  claude)   DEST_DIR=".claude";   DEST_SUB="commands" ;;
  opencode) DEST_DIR=".opencode"; DEST_SUB="command"  ;;
  *) echo "error: target must be 'claude' or 'opencode'" >&2; exit 1 ;;
esac

TARGET_DIR="$(pwd)"
echo "Installing Muxy AI Kit (${REPO}@${REF}) → ${TARGET_DIR}/${DEST_DIR}/${DEST_SUB}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "→ downloading…"
curl -fsSL "$TARBALL" | tar -xz -C "$TMP"

SRC="$(find "$TMP" -maxdepth 2 -type d -name 'commands' | head -n1)"
if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
  echo "error: commands/ folder not found in downloaded archive" >&2
  exit 1
fi

DEST="${TARGET_DIR}/${DEST_DIR}/${DEST_SUB}"
mkdir -p "${TARGET_DIR}/${DEST_DIR}"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"

echo "✓ Done. Installed at ${DEST}"
