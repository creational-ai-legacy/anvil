#!/bin/bash
# Sync changes from ~/.claude/ back to this repo
# Usage: ./sync-from-user.sh
#
# To add/remove a skill: Edit the SKILLS array below

set -e

#=============================================================================
# CONFIGURATION - Edit this section to add/remove skills
#=============================================================================
SKILLS=(
    "dev-design"
    "dev-cycle"
    "market-research"
)
#=============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
COMMANDS_DIR="$HOME/.claude/commands"
AGENTS_DIR="$HOME/.claude/agents"

echo "=============================================="
echo "Syncing from user directories..."
echo "=============================================="
echo ""

# Check which skills exist
for skill in "${SKILLS[@]}"; do
    if [ ! -d "$SKILLS_DIR/$skill" ]; then
        echo "Warning: $SKILLS_DIR/$skill does not exist"
    fi
done
echo ""

# Sync each skill
for skill in "${SKILLS[@]}"; do
    SKILL_SRC="$SKILLS_DIR/$skill"
    SKILL_DST="$SCRIPT_DIR/$skill"

    if [ ! -d "$SKILL_SRC" ]; then
        continue
    fi

    echo "--- Syncing $skill skill ---"
    echo "Source: $SKILL_SRC"

    # Sync SKILL.md
    if [ -f "$SKILL_SRC/SKILL.md" ]; then
        cp "$SKILL_SRC/SKILL.md" "$SKILL_DST/"
        echo "  ✓ Synced SKILL.md"
    fi

    # Sync assets/templates/
    if [ -d "$SKILL_SRC/assets/templates" ] && [ -d "$SKILL_DST/assets/templates" ]; then
        cp -r "$SKILL_SRC/assets/templates/"* "$SKILL_DST/assets/templates/"
        echo "  ✓ Synced assets/templates/"
    fi

    # Sync references/
    if [ -d "$SKILL_SRC/references" ] && [ -d "$SKILL_DST/references" ]; then
        cp -r "$SKILL_SRC/references/"* "$SKILL_DST/references/"
        echo "  ✓ Synced references/"
    fi

    # Sync commands back to skill's commands/ folder
    if [ -d "$SKILL_DST/commands" ]; then
        synced=0
        for cmd in "$SKILL_DST/commands/"*.md; do
            [ -f "$cmd" ] || continue
            cmd_name=$(basename "$cmd")
            if [ -f "$COMMANDS_DIR/$cmd_name" ]; then
                cp "$COMMANDS_DIR/$cmd_name" "$SKILL_DST/commands/"
                ((synced++))
            fi
        done
        if [ "$synced" -gt "0" ]; then
            echo "  ✓ Synced $synced commands"
        fi
    fi

    # Sync agents back to skill's agents/ folder
    if [ -d "$SKILL_DST/agents" ]; then
        synced=0
        for agent in "$SKILL_DST/agents/"*.md; do
            [ -f "$agent" ] || continue
            agent_name=$(basename "$agent")
            if [ -f "$AGENTS_DIR/$agent_name" ]; then
                cp "$AGENTS_DIR/$agent_name" "$SKILL_DST/agents/"
                ((synced++))
            fi
        done
        if [ "$synced" -gt "0" ]; then
            echo "  ✓ Synced $synced agents"
        fi
    fi

    echo ""
done

echo "=============================================="
echo "✓ Sync complete!"
echo "=============================================="
echo ""
echo "Synced to: $SCRIPT_DIR"
echo ""
echo "Changed files:"
git status --short
