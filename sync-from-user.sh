#!/bin/bash
# Sync changes from ~/.claude/ back to this repo
# Usage: ./sync-from-user.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVDESIGN_SKILL_DIR="$HOME/.claude/skills/dev-design"
DEVCYCLE_SKILL_DIR="$HOME/.claude/skills/dev-cycle"
COMMANDS_DIR="$HOME/.claude/commands"

echo "=============================================="
echo "Syncing from user directories..."
echo "=============================================="
echo ""

# Check sources exist
if [ ! -d "$DEVDESIGN_SKILL_DIR" ]; then
    echo "Warning: $DEVDESIGN_SKILL_DIR does not exist"
fi

if [ ! -d "$DEVCYCLE_SKILL_DIR" ]; then
    echo "Warning: $DEVCYCLE_SKILL_DIR does not exist"
fi

# Sync dev-design skill
if [ -d "$DEVDESIGN_SKILL_DIR" ]; then
    echo "--- Syncing dev-design skill ---"
    echo "Source: $DEVDESIGN_SKILL_DIR"

    cp "$DEVDESIGN_SKILL_DIR/SKILL.md" "$SCRIPT_DIR/dev-design/"
    echo "  ✓ Synced SKILL.md"

    cp -r "$DEVDESIGN_SKILL_DIR/assets/templates/"* "$SCRIPT_DIR/dev-design/assets/templates/"
    echo "  ✓ Synced assets/templates/"

    cp -r "$DEVDESIGN_SKILL_DIR/references/"* "$SCRIPT_DIR/dev-design/references/"
    echo "  ✓ Synced references/"

    echo ""
fi

# Sync dev-cycle skill
if [ -d "$DEVCYCLE_SKILL_DIR" ]; then
    echo "--- Syncing dev-cycle skill ---"
    echo "Source: $DEVCYCLE_SKILL_DIR"

    cp "$DEVCYCLE_SKILL_DIR/SKILL.md" "$SCRIPT_DIR/dev-cycle/"
    echo "  ✓ Synced SKILL.md"

    cp -r "$DEVCYCLE_SKILL_DIR/assets/templates/"* "$SCRIPT_DIR/dev-cycle/assets/templates/"
    echo "  ✓ Synced assets/templates/"

    cp -r "$DEVCYCLE_SKILL_DIR/references/"* "$SCRIPT_DIR/dev-cycle/references/"
    echo "  ✓ Synced references/"

    echo ""
fi

# Sync global commands (all .md files that exist in repo's commands/)
echo "--- Syncing global commands ---"
echo "Source: $COMMANDS_DIR"

mkdir -p "$SCRIPT_DIR/commands"
for cmd in "$SCRIPT_DIR/commands/"*.md; do
    cmd_name=$(basename "$cmd")
    if [ -f "$COMMANDS_DIR/$cmd_name" ]; then
        cp "$COMMANDS_DIR/$cmd_name" "$SCRIPT_DIR/commands/"
        echo "  ✓ Synced $cmd_name"
    fi
done

echo ""
echo "=============================================="
echo "✓ Sync complete!"
echo "=============================================="
echo ""
echo "Synced to: $SCRIPT_DIR"
echo ""
echo "Changed files:"
git status --short
