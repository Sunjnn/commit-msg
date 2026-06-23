#!/bin/bash

SKILL_NAME="commit-msg"
TARGET_DIR="$HOME/.claude/skills/$SKILL_NAME"
TARGET_FILE="$TARGET_DIR/SKILL.md"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORCE=false

if [[ "$1" == "-f" || "$1" == "--force" ]]; then
    FORCE=true
fi

if [[ -e "$TARGET_FILE" ]] && ! $FORCE; then
    echo "Error: $TARGET_FILE already exists. Use -f to overwrite." >&2
    exit 1
fi

mkdir -p "$TARGET_DIR"
ln -sf "$SCRIPT_DIR/SKILL.md" "$TARGET_FILE"

echo "Installed $SKILL_NAME -> $TARGET_FILE"
