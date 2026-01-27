#!/bin/bash

# Package Claude Desktop skills into .skill files
# Usage: ./package.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASES_DIR="$SCRIPT_DIR/releases"

# Ensure releases directory exists
mkdir -p "$RELEASES_DIR"

# Skills to package
SKILLS=("design" "market-research" "business-validation" "framework-alignment")

echo "📦 Packaging Claude Desktop skills..."
echo ""

for skill in "${SKILLS[@]}"; do
    SKILL_DIR="$SCRIPT_DIR/$skill"
    OUTPUT_FILE="$RELEASES_DIR/$skill.skill"
    
    if [ ! -d "$SKILL_DIR" ]; then
        echo "⚠️  Skipping $skill (directory not found)"
        continue
    fi
    
    # Remove old .skill file if exists
    rm -f "$OUTPUT_FILE"
    
    # Create .skill file (zip archive)
    # Package contents inside a folder named after the skill
    cd "$SCRIPT_DIR"
    zip -r "$OUTPUT_FILE" "$skill" \
        -x "*.DS_Store" \
        -x "*/__pycache__/*" \
        -x "*.pyc"
    
    echo "✅ $skill.skill"
done

echo ""
echo "📁 Output: $RELEASES_DIR/"
ls -la "$RELEASES_DIR"/*.skill
