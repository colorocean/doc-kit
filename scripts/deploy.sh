#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Install this repo as a local Codex skill.

Usage:
  scripts/deploy.sh [--force] [--link] [--dest <path>]

Options:
  --force        Remove existing destination before installing.
  --link         Install via symlink (dev mode) instead of copying files.
  --dest <path>  Install destination directory (default: $CODEX_HOME/skills/<skill-name>).

Env:
  CODEX_HOME     Defaults to ~/.codex
EOF
}

FORCE=0
LINK=0
DEST=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --link) LINK=1; shift ;;
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

SKILL_MD="$ROOT_DIR/SKILL.md"
if [[ ! -f "$SKILL_MD" ]]; then
  echo "[ERROR] SKILL.md not found at: $SKILL_MD" >&2
  exit 1
fi

SKILL_NAME="$(
  awk '
    BEGIN { in_frontmatter=0 }
    /^---[[:space:]]*$/ { if (in_frontmatter==0) { in_frontmatter=1; next } else { exit } }
    in_frontmatter==1 && $1=="name:" { print $2; exit }
  ' "$SKILL_MD" | sed -E 's/^"(.*)"$/\\1/; s/^'\''(.*)'\''$/\\1/'
)"

if [[ -z "${SKILL_NAME:-}" ]]; then
  echo "[ERROR] Could not parse skill name from SKILL.md frontmatter." >&2
  exit 1
fi

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
DEFAULT_DEST="$CODEX_HOME/skills/$SKILL_NAME"
DEST="${DEST:-$DEFAULT_DEST}"

SKILLS_DIR="$CODEX_HOME/skills"
mkdir -p "$SKILLS_DIR"

if [[ -e "$DEST" ]]; then
  if [[ "$FORCE" -ne 1 ]]; then
    echo "[ERROR] Destination already exists: $DEST" >&2
    echo "        Re-run with --force to overwrite." >&2
    exit 1
  fi

  case "$DEST" in
    "$SKILLS_DIR"/*) ;;
    *)
      echo "[ERROR] Refusing to remove destination outside $SKILLS_DIR: $DEST" >&2
      exit 1
      ;;
  esac

  rm -rf "$DEST"
fi

if [[ "$LINK" -eq 1 ]]; then
  ln -s "$ROOT_DIR" "$DEST"
  echo "[OK] Linked skill: $DEST -> $ROOT_DIR"
else
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete \
      --exclude ".git" \
      --exclude ".DS_Store" \
      "$ROOT_DIR/" "$DEST/"
  else
    mkdir -p "$DEST"
    tar -C "$ROOT_DIR" --exclude ".git" --exclude ".DS_Store" -cf - . | tar -C "$DEST" -xf -
  fi
  echo "[OK] Installed skill to: $DEST"
fi

if [[ ! -f "$DEST/SKILL.md" ]]; then
  echo "[ERROR] Install failed: missing $DEST/SKILL.md" >&2
  exit 1
fi

echo "Restart Codex to pick up new skills."
