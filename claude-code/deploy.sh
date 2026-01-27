#!/bin/bash
# Deploy all Claude Code skills to ~/.claude/
# Usage: ./deploy.sh
#
# To add/remove a skill: Edit the SKILLS array below

set -e

#=============================================================================
# CONFIGURATION - Edit this section to add/remove skills
#=============================================================================
SKILLS=(
    "design"
    "dev"
    "market-research"
)

# Old skill directories to clean up (add deprecated skills here)
OLD_SKILLS=(
    "idea-to-mvp"
    "blueprint"
    "dev-design"
    "dev-cycle"
)
#=============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
COMMANDS_DIR="$HOME/.claude/commands"
AGENTS_DIR="$HOME/.claude/agents"

echo "=============================================="
echo "Deploying Claude Code skills..."
echo "=============================================="
echo ""

# Clean up old skill directories
for old_skill in "${OLD_SKILLS[@]}"; do
    if [ -d "$SKILLS_DIR/$old_skill" ]; then
        echo "--- Removing old $old_skill skill ---"
        rm -rf "$SKILLS_DIR/$old_skill"
        echo "  ✓ Removed $SKILLS_DIR/$old_skill"
        echo ""
    fi
done

# Create target directories
mkdir -p "$COMMANDS_DIR"
mkdir -p "$AGENTS_DIR"

# Deploy each skill
for skill in "${SKILLS[@]}"; do
    echo "--- Deploying $skill skill ---"

    SKILL_SRC="$SCRIPT_DIR/$skill"
    SKILL_DST="$SKILLS_DIR/$skill"

    if [ ! -d "$SKILL_SRC" ]; then
        echo "  ⚠️  Source directory not found: $SKILL_SRC"
        echo ""
        continue
    fi

    mkdir -p "$SKILL_DST"
    echo "Target: $SKILL_DST"

    # Copy SKILL.md
    if [ -f "$SKILL_SRC/SKILL.md" ]; then
        cp "$SKILL_SRC/SKILL.md" "$SKILL_DST/"
        echo "  ✓ Copied SKILL.md"
    fi

    # Copy assets/templates/
    if [ -d "$SKILL_SRC/assets/templates" ]; then
        mkdir -p "$SKILL_DST/assets/templates"
        cp -r "$SKILL_SRC/assets/templates/"* "$SKILL_DST/assets/templates/"
        echo "  ✓ Copied assets/templates/"
    fi

    # Copy references/
    if [ -d "$SKILL_SRC/references" ]; then
        mkdir -p "$SKILL_DST/references"
        cp -r "$SKILL_SRC/references/"* "$SKILL_DST/references/"
        echo "  ✓ Copied references/"
    fi

    # Copy commands/ to global commands dir
    if [ -d "$SKILL_SRC/commands" ]; then
        count=$(ls -1 "$SKILL_SRC/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt "0" ]; then
            cp -r "$SKILL_SRC/commands/"*.md "$COMMANDS_DIR/"
            echo "  ✓ Copied $count commands"
        fi
    fi

    # Copy agents/ to global agents dir
    if [ -d "$SKILL_SRC/agents" ]; then
        count=$(ls -1 "$SKILL_SRC/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt "0" ]; then
            cp -r "$SKILL_SRC/agents/"*.md "$AGENTS_DIR/"
            echo "  ✓ Copied $count agents"
        fi
    fi

    echo ""
done

echo "=============================================="
echo "✓ Deployment complete!"
echo "=============================================="
echo ""
echo "Deployed ${#SKILLS[@]} skills to:"
for skill in "${SKILLS[@]}"; do
    echo "  - $SKILLS_DIR/$skill"
done
echo "  - $COMMANDS_DIR (commands)"
echo "  - $AGENTS_DIR (agents)"
echo ""
