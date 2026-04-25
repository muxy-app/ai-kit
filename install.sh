#!/usr/bin/env bash
# Muxy AI Kit installer — drops .claude/ into the current directory.
# Usage: curl -fsSL https://raw.githubusercontent.com/muxy-app/ai-kit/main/install.sh | bash
set -euo pipefail

REPO="${MUXY_AI_KIT_REPO:-muxy-app/ai-kit}"
REF="${MUXY_AI_KIT_REF:-main}"
TARBALL="https://codeload.github.com/${REPO}/tar.gz/refs/heads/${REF}"

if ! command -v curl >/dev/null 2>&1; then
  echo "error: curl is required" >&2
  exit 1
fi
if ! command -v tar >/dev/null 2>&1; then
  echo "error: tar is required" >&2
  exit 1
fi

TARGET_DIR="$(pwd)"
echo "Installing Muxy AI Kit (${REPO}@${REF}) into: ${TARGET_DIR}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "→ downloading…"
curl -fsSL "$TARBALL" | tar -xz -C "$TMP"

SRC="$(find "$TMP" -maxdepth 2 -type d -name '.claude' | head -n1)"
if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
  echo "error: .claude folder not found in downloaded archive" >&2
  exit 1
fi

if [ -e "${TARGET_DIR}/.claude" ]; then
  BACKUP="${TARGET_DIR}/.claude.bak-$(date +%Y%m%d-%H%M%S)"
  echo "→ backing up existing .claude → $(basename "$BACKUP")"
  mv "${TARGET_DIR}/.claude" "$BACKUP"
fi

echo "→ installing .claude/"
cp -R "$SRC" "${TARGET_DIR}/.claude"

echo "✓ Done. Muxy AI Kit installed at ${TARGET_DIR}/.claude"
