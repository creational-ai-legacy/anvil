#!/bin/bash
# Deploy all Claude Code skills to genesis (Raspberry Pi) via SSH
# Usage: ./deploy-genesis.sh
#
# Requires: ssh genesis configured in ~/.ssh/config

set -e

#=============================================================================
# CONFIGURATION
#=============================================================================
REMOTE="genesis"
REMOTE_HOME="/home/pi"

SKILLS=(
    "design"
    "dev"
    "market-research"
    "video-professor"
)
#=============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE_SKILLS="$REMOTE_HOME/.claude/skills"
REMOTE_COMMANDS="$REMOTE_HOME/.claude/commands"
REMOTE_AGENTS="$REMOTE_HOME/.claude/agents"

echo "=============================================="
echo "Deploying Claude Code skills to $REMOTE..."
echo "=============================================="
echo ""

# Test SSH connection
if ! ssh -o ConnectTimeout=5 "$REMOTE" "echo ok" > /dev/null 2>&1; then
    echo "Error: Cannot connect to $REMOTE" >&2
    exit 1
fi

# Create target directories
ssh "$REMOTE" "mkdir -p '$REMOTE_COMMANDS' '$REMOTE_AGENTS'"

# Deploy each skill
for skill in "${SKILLS[@]}"; do
    echo "--- Deploying $skill skill ---"

    SKILL_SRC="$SCRIPT_DIR/$skill"
    SKILL_DST="$REMOTE_SKILLS/$skill"

    if [ ! -d "$SKILL_SRC" ]; then
        echo "  ⚠  Source not found: $SKILL_SRC"
        echo ""
        continue
    fi

    echo "Target: $REMOTE:$SKILL_DST"

    # Create remote skill directories
    ssh "$REMOTE" "mkdir -p '$SKILL_DST/assets/templates' '$SKILL_DST/references' '$SKILL_DST/scripts'" 2>/dev/null

    # Copy SKILL.md
    if [ -f "$SKILL_SRC/SKILL.md" ]; then
        scp -q "$SKILL_SRC/SKILL.md" "$REMOTE:$SKILL_DST/"
        echo "  ✓ Copied SKILL.md"
    fi

    # Copy assets/templates/
    if [ -d "$SKILL_SRC/assets/templates" ]; then
        scp -q "$SKILL_SRC/assets/templates/"* "$REMOTE:$SKILL_DST/assets/templates/" 2>/dev/null
        echo "  ✓ Copied assets/templates/"
    fi

    # Copy references/
    if [ -d "$SKILL_SRC/references" ]; then
        scp -q "$SKILL_SRC/references/"* "$REMOTE:$SKILL_DST/references/" 2>/dev/null
        echo "  ✓ Copied references/"
    fi

    # Copy commands/
    if [ -d "$SKILL_SRC/commands" ]; then
        count=$(ls -1 "$SKILL_SRC/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt "0" ]; then
            scp -q "$SKILL_SRC/commands/"*.md "$REMOTE:$REMOTE_COMMANDS/"
            echo "  ✓ Copied $count commands"
        fi
    fi

    # Copy agents/
    if [ -d "$SKILL_SRC/agents" ]; then
        count=$(ls -1 "$SKILL_SRC/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt "0" ]; then
            scp -q "$SKILL_SRC/agents/"*.md "$REMOTE:$REMOTE_AGENTS/"
            echo "  ✓ Copied $count agents"
        fi
    fi

    # Copy scripts/
    if [ -d "$SKILL_SRC/scripts" ]; then
        scp -q "$SKILL_SRC/scripts/"* "$REMOTE:$SKILL_DST/scripts/" 2>/dev/null
        ssh "$REMOTE" "chmod +x '$SKILL_DST/scripts/'*.sh 2>/dev/null || true"
        echo "  ✓ Copied scripts/"
    fi

    echo ""
done

# Deploy common commands
if [ -d "$SCRIPT_DIR/common/commands" ]; then
    echo "--- Deploying common commands ---"
    count=$(ls -1 "$SCRIPT_DIR/common/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt "0" ]; then
        scp -q "$SCRIPT_DIR/common/commands/"*.md "$REMOTE:$REMOTE_COMMANDS/"
        echo "  ✓ Copied $count common commands"
    fi
    echo ""
fi

echo "=============================================="
echo "✓ Deployed to $REMOTE!"
echo "=============================================="
echo ""
echo "Deployed ${#SKILLS[@]} skills to $REMOTE:"
for skill in "${SKILLS[@]}"; do
    echo "  - $REMOTE_SKILLS/$skill"
done
echo "  - $REMOTE_COMMANDS (commands)"
echo "  - $REMOTE_AGENTS (agents)"
echo ""
