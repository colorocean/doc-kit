#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Create an Obsidian-friendly mirror of doc-kit prompt files via symlinks.

This creates:
  ./obsidian-links/prompts/*.md  ->  ../../prompts/doc.*

Usage:
  scripts/obsidian-links.sh [--dest <dir>]

Options:
  --dest <dir>   Destination directory (default: ./obsidian-links)
EOF
}

DEST="./obsidian-links"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      DEST="${2:-}"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "[ERROR] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PROMPTS_DIR="$ROOT_DIR/prompts"
if [[ ! -d "$PROMPTS_DIR" ]]; then
  echo "[ERROR] Missing prompts dir: $PROMPTS_DIR" >&2
  exit 1
fi

DEST_DIR="$ROOT_DIR/$DEST/prompts"
mkdir -p "$DEST_DIR"

shopt -s nullglob
for src in "$PROMPTS_DIR"/doc.*; do
  base="$(basename "$src")"
  ln -sf "../../prompts/$base" "$DEST_DIR/$base.md"
done

echo "[OK] Created Obsidian symlink mirror at: $DEST_DIR"
echo "     Open this repo as an Obsidian vault and browse: $DEST/prompts/"

