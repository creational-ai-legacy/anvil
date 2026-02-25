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
    "skill-reviewer"
)

# Old skill directories to clean up (add deprecated skills here)
OLD_SKILLS=(
    "idea-to-mvp"
    "blueprint"
    "dev-design"
    "dev-cycle"
)

# Old commands to clean up (replaced by skills or removed)
OLD_COMMANDS=(
    "vp-transcript.md"
    "vp-meta.md"
    "design-northstar.md"
    "design-milestones-overview.md"
    "design-milestone-design.md"
    "design-poc-design.md"
    "dev-lessons.md"
    "design-product-vision.md"
    "design-product-roadmap.md"
    "design-poc-spec.md"
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

# Clean up old commands
for old_cmd in "${OLD_COMMANDS[@]}"; do
    if [ -f "$COMMANDS_DIR/$old_cmd" ]; then
        echo "--- Removing old command: $old_cmd ---"
        rm -f "$COMMANDS_DIR/$old_cmd"
        echo "  ✓ Removed $COMMANDS_DIR/$old_cmd"
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

    # Copy assets/templates/ (wipe first to remove old-named files)
    if [ -d "$SKILL_SRC/assets/templates" ]; then
        rm -rf "$SKILL_DST/assets/templates"
        mkdir -p "$SKILL_DST/assets/templates"
        cp -r "$SKILL_SRC/assets/templates/"* "$SKILL_DST/assets/templates/"
        echo "  ✓ Copied assets/templates/"
    fi

    # Copy references/ (wipe first to remove old-named files)
    if [ -d "$SKILL_SRC/references" ]; then
        rm -rf "$SKILL_DST/references"
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

    # Copy scripts/
    if [ -d "$SKILL_SRC/scripts" ]; then
        mkdir -p "$SKILL_DST/scripts"
        cp -r "$SKILL_SRC/scripts/"* "$SKILL_DST/scripts/"
        chmod +x "$SKILL_DST/scripts/"*.sh 2>/dev/null || true
        echo "  ✓ Copied scripts/"
    fi

    echo ""
done

# Deploy common commands (no skill, just commands)
if [ -d "$SCRIPT_DIR/common/commands" ]; then
    echo "--- Deploying common commands ---"
    count=$(ls -1 "$SCRIPT_DIR/common/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt "0" ]; then
        cp -r "$SCRIPT_DIR/common/commands/"*.md "$COMMANDS_DIR/"
        echo "  ✓ Copied $count common commands"
    fi
    echo ""
fi

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
