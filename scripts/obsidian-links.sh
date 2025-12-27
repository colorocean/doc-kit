#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Create an Obsidian-friendly mirror of doc-kit prompt files via symlinks.

This creates:
  ./obsidian-links/prompts/*.md  ->  ../../prompts/doc.*

Usage:
  scripts/obsidian-links.sh [--dest <dir>] [--mode symlink|hardlink]

Options:
  --dest <dir>   Destination directory (default: ./obsidian-links)
  --mode <mode>  Link mode (default: symlink). Use hardlink if Obsidian doesn't show symlinks.
EOF
}

DEST="./obsidian-links"
MODE="symlink"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      DEST="${2:-}"
      shift 2
      ;;
    --mode)
      MODE="${2:-}"
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
  target="../../prompts/$base"
  out="$DEST_DIR/$base.md"
  rm -f "$out"

  case "$MODE" in
    symlink)
      ln -s "$target" "$out"
      ;;
    hardlink)
      ln "$ROOT_DIR/prompts/$base" "$out"
      ;;
    *)
      echo "[ERROR] Unknown --mode: $MODE (expected symlink|hardlink)" >&2
      exit 2
      ;;
  esac
done

echo "[OK] Created Obsidian symlink mirror at: $DEST_DIR"
echo "     Open this repo as an Obsidian vault and browse: $DEST/prompts/"
