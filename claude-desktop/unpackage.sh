#!/bin/bash

# Unpackage .skill files back into source folders
# Usage:
#   ./unpackage.sh                              # Unpack all known skills
#   ./unpackage.sh releases/my-skill.skill     # Unpack single skill (new or existing)
#
# Workflow:
# 1. Edit skills in Claude Desktop
# 2. Export .skill files to releases/
# 3. Run this script to update source folders

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASES_DIR="$SCRIPT_DIR/releases"

# Skills to unpackage (when no argument provided)
SKILLS=("design" "market-research" "business-validation" "framework-alignment")

# Function to unpack a single .skill file
unpack_skill() {
    local SKILL_FILE="$1"
    local SKILL_NAME=$(basename "$SKILL_FILE" .skill)
    local SKILL_DIR="$SCRIPT_DIR/$SKILL_NAME"

    if [ ! -f "$SKILL_FILE" ]; then
        echo "❌ Error: $SKILL_FILE not found"
        return 1
    fi

    echo "--- Unpackaging $SKILL_NAME.skill ---"

    # Create temp directory for extraction
    TEMP_DIR=$(mktemp -d)

    # Unzip .skill file (it's a zip archive)
    unzip -q "$SKILL_FILE" -d "$TEMP_DIR"

    # The skill contents are in a folder named after the skill
    EXTRACTED_DIR="$TEMP_DIR/$SKILL_NAME"

    if [ ! -d "$EXTRACTED_DIR" ]; then
        echo "❌ Error: Expected $SKILL_NAME folder not found in archive"
        rm -rf "$TEMP_DIR"
        return 1
    fi

    # Remove old skill directory and replace with extracted
    rm -rf "$SKILL_DIR"
    mv "$EXTRACTED_DIR" "$SKILL_DIR"

    # Cleanup temp directory
    rm -rf "$TEMP_DIR"

    echo "✅ $SKILL_NAME updated"
    echo ""
    echo "📁 Unpacked to: $SKILL_DIR/"
}

echo "📦 Unpackaging Claude Desktop skills..."
echo ""

# Check if argument provided
if [ -n "$1" ]; then
    # Single skill mode
    SKILL_FILE="$1"

    # Handle relative path
    if [[ ! "$SKILL_FILE" = /* ]]; then
        SKILL_FILE="$SCRIPT_DIR/$SKILL_FILE"
    fi

    unpack_skill "$SKILL_FILE"
else
    # All skills mode
    for skill in "${SKILLS[@]}"; do
        SKILL_FILE="$RELEASES_DIR/$skill.skill"

        if [ ! -f "$SKILL_FILE" ]; then
            echo "⚠️  Skipping $skill (.skill file not found)"
            continue
        fi

        unpack_skill "$SKILL_FILE"
    done

    echo ""
    echo "📁 Updated folders:"
    for skill in "${SKILLS[@]}"; do
        if [ -d "$SCRIPT_DIR/$skill" ]; then
            echo "  $skill/"
        fi
    done
fi

echo ""
echo "Changed files:"
cd "$SCRIPT_DIR/.." && git status --short claude-desktop/
