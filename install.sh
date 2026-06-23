#!/bin/bash

SKILL_NAME="commit-msg"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORCE=false
TARGET="claude"

usage() {
    echo "Usage: $0 [-f|--force] [-t|--target claude|qoder]" >&2
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            FORCE=true
            shift
            ;;
        -t|--target)
            TARGET="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: unknown argument '$1'" >&2
            usage
            ;;
    esac
done

case "$TARGET" in
    claude)
        TARGET_DIR="$HOME/.claude/skills/$SKILL_NAME"
        ;;
    qoder)
        TARGET_DIR="$HOME/.qoder/skills/$SKILL_NAME"
        ;;
    *)
        echo "Error: --target must be 'claude' or 'qoder' (got '$TARGET')" >&2
        exit 1
        ;;
esac

TARGET_FILE="$TARGET_DIR/SKILL.md"

if [[ -e "$TARGET_FILE" ]] && ! $FORCE; then
    echo "Error: $TARGET_FILE already exists. Use -f to overwrite." >&2
    exit 1
fi

mkdir -p "$TARGET_DIR"
ln -sf "$SCRIPT_DIR/SKILL.md" "$TARGET_FILE"

echo "Installed $SKILL_NAME ($TARGET) -> $TARGET_FILE"
