#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Create an Obsidian-friendly mirror of doc-kit prompt files.

This creates:
  <dest>/prompts/*.md  ->  prompts/doc.* (via symlink or hardlink)

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

DEST_ROOT="$DEST"
case "$DEST" in
  /*) ;;
  *) DEST_ROOT="$ROOT_DIR/$DEST" ;;
esac

DEST_DIR="$DEST_ROOT/prompts"
mkdir -p "$DEST_DIR"

shopt -s nullglob
for src in "$PROMPTS_DIR"/doc.*; do
  base="$(basename "$src")"
  out="$DEST_DIR/$base.md"
  rm -f "$out"

  case "$MODE" in
    symlink)
      # Use absolute symlinks so --dest can be nested anywhere under the repo.
      ln -s "$src" "$out"
      ;;
    hardlink)
      # Hardlinks allow Obsidian to treat files as normal markdown.
      # Note: hardlinks require source and dest on the same filesystem.
      ln "$src" "$out"
      ;;
    *)
      echo "[ERROR] Unknown --mode: $MODE (expected symlink|hardlink)" >&2
      exit 2
      ;;
  esac
done

echo "[OK] Created Obsidian mirror at: $DEST_DIR"
echo "     Open this repo as an Obsidian vault and browse: ${DEST#./}/prompts/"
