#!/bin/bash

SKILL_NAME="commit-msg"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORCE=false
TARGET="claude"
# DeepSeek Harness scans <dshHome>/skills, where dshHome is $DSH_HOME or ~/.dsh
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install the $SKILL_NAME skill into a tool's skills directory.

Options:
  -f, --force          Overwrite the target SKILL.md if it already exists
  -t, --target TARGET  Which tool to install for: claude (default), qoder, or dsh
  -h, --help           Show this help message and exit

Examples:
  $0                     Install to ~/.claude/skills/$SKILL_NAME/
  $0 -t dsh              Install to \$DSH_HOME/skills/$SKILL_NAME/
  $0 -f -t qoder         Force install to ~/.qoder/skills/$SKILL_NAME/
EOF
}

die() {
    echo "Error: $*" >&2
    echo "Try '$0 --help' for usage." >&2
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            FORCE=true
            shift
            ;;
        -t|--target)
            if [[ $# -lt 2 || -z "$2" ]]; then
                die "$1 requires a value (claude, qoder, or dsh)"
            fi
            TARGET="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "unknown argument '$1'"
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
    dsh)
        TARGET_DIR="$DSH_HOME/skills/$SKILL_NAME"
        ;;
    *)
        die "--target must be 'claude', 'qoder', or 'dsh' (got '$TARGET')"
        ;;
esac

TARGET_FILE="$TARGET_DIR/SKILL.md"

if [[ -e "$TARGET_FILE" ]] && ! $FORCE; then
    die "$TARGET_FILE already exists. Use -f to overwrite."
fi

mkdir -p "$TARGET_DIR"
rm -f "$TARGET_FILE"
cp "$SCRIPT_DIR/SKILL.md" "$TARGET_FILE"

echo "Installed $SKILL_NAME ($TARGET) -> $TARGET_FILE"
