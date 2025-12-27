#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Uninstall the locally installed Codex skill.

Usage:
  scripts/uninstall.sh [--dest <path>]

Options:
  --dest <path>  Skill install directory (default: $CODEX_HOME/skills/<skill-name>).

Env:
  CODEX_HOME     Defaults to ~/.codex
EOF
}

DEST=""
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
SKILLS_DIR="$CODEX_HOME/skills"
DEFAULT_DEST="$SKILLS_DIR/$SKILL_NAME"
DEST="${DEST:-$DEFAULT_DEST}"

if [[ ! -e "$DEST" ]]; then
  echo "[OK] Not installed: $DEST"
  exit 0
fi

case "$DEST" in
  "$SKILLS_DIR"/*) ;;
  *)
    echo "[ERROR] Refusing to remove destination outside $SKILLS_DIR: $DEST" >&2
    exit 1
    ;;
esac

rm -rf "$DEST"
echo "[OK] Removed: $DEST"
echo "Restart Codex to pick up changes."
