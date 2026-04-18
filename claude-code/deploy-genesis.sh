#!/bin/bash
# Deploy all Claude Code skills to genesis (Raspberry Pi) via SSH
# Usage: ./deploy-genesis.sh
#
# Requires: ssh genesis configured in ~/.ssh/config
#
# This script mirrors deploy.sh but targets the remote host.
# Keep SKILLS / OLD_* arrays in sync with deploy.sh.

set -e

#=============================================================================
# CONFIGURATION - Keep in sync with deploy.sh
#=============================================================================
REMOTE="genesis"
REMOTE_HOME="/home/pi"

SKILLS=(
    "design"
    "dev"
    "research"
    "review"
)

# Old skill directories to clean up (add deprecated skills here)
OLD_SKILLS=(
    "idea-to-mvp"
    "blueprint"
    "dev-design"
    "dev-cycle"
    "market-research"
    "verify"
    "skill-reviewer"
)

# Old agents to clean up (renamed to role-based names)
OLD_AGENTS=(
    "dev-design-agent.md"
    "dev-plan-agent.md"
    "dev-execute-agent.md"
    "dev-review-agent.md"
    "dev-finalize-agent.md"
    "milestone-details-agent.md"
    "market-research-agent.md"
    "naming-research-agent.md"
    "milestone-summarizer.md"
    "verify-doc-agent.md"
    "skill-review-agent.md"
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
    "agent-dev-design.md"
    "agent-dev-plan.md"
    "agent-dev-execute.md"
    "agent-dev-review.md"
    "agent-dev-finalize.md"
    "agent-milestone-details.md"
    "agent-market-research.md"
    "agent-naming-research.md"
    "milestone-details.md"
    "design-naming-research.md"
    "spawn-milestone-summarizer.md"
    "verify-doc.md"
    "agent-verify-doc.md"
    "skill-review.md"
    "agent-skill-review.md"
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
ssh "$REMOTE" "mkdir -p '$REMOTE_SKILLS' '$REMOTE_COMMANDS' '$REMOTE_AGENTS'"

# Clean up old skill directories
for old_skill in "${OLD_SKILLS[@]}"; do
    if ssh "$REMOTE" "[ -d '$REMOTE_SKILLS/$old_skill' ]"; then
        echo "--- Removing old $old_skill skill ---"
        ssh "$REMOTE" "rm -rf '$REMOTE_SKILLS/$old_skill'"
        echo "  ✓ Removed $REMOTE:$REMOTE_SKILLS/$old_skill"
        echo ""
    fi
done

# Clean up old commands
for old_cmd in "${OLD_COMMANDS[@]}"; do
    if ssh "$REMOTE" "[ -f '$REMOTE_COMMANDS/$old_cmd' ]"; then
        echo "--- Removing old command: $old_cmd ---"
        ssh "$REMOTE" "rm -f '$REMOTE_COMMANDS/$old_cmd'"
        echo "  ✓ Removed $REMOTE:$REMOTE_COMMANDS/$old_cmd"
        echo ""
    fi
done

# Clean up old agents
for old_agent in "${OLD_AGENTS[@]}"; do
    if ssh "$REMOTE" "[ -f '$REMOTE_AGENTS/$old_agent' ]"; then
        echo "--- Removing old agent: $old_agent ---"
        ssh "$REMOTE" "rm -f '$REMOTE_AGENTS/$old_agent'"
        echo "  ✓ Removed $REMOTE:$REMOTE_AGENTS/$old_agent"
        echo ""
    fi
done

# Deploy each skill
for skill in "${SKILLS[@]}"; do
    echo "--- Deploying $skill skill ---"

    SKILL_SRC="$SCRIPT_DIR/$skill"
    SKILL_DST="$REMOTE_SKILLS/$skill"

    if [ ! -d "$SKILL_SRC" ]; then
        echo "  ⚠️  Source directory not found: $SKILL_SRC"
        echo ""
        continue
    fi

    ssh "$REMOTE" "mkdir -p '$SKILL_DST'"
    echo "Target: $REMOTE:$SKILL_DST"

    # Copy SKILL.md
    if [ -f "$SKILL_SRC/SKILL.md" ]; then
        scp -q "$SKILL_SRC/SKILL.md" "$REMOTE:$SKILL_DST/"
        echo "  ✓ Copied SKILL.md"
    fi

    # Copy assets/templates/ (wipe first to remove old-named files)
    if [ -d "$SKILL_SRC/assets/templates" ]; then
        ssh "$REMOTE" "rm -rf '$SKILL_DST/assets/templates' && mkdir -p '$SKILL_DST/assets/templates'"
        scp -q -r "$SKILL_SRC/assets/templates/"* "$REMOTE:$SKILL_DST/assets/templates/"
        echo "  ✓ Copied assets/templates/"
    fi

    # Copy references/ (wipe first to remove old-named files)
    if [ -d "$SKILL_SRC/references" ]; then
        ssh "$REMOTE" "rm -rf '$SKILL_DST/references' && mkdir -p '$SKILL_DST/references'"
        scp -q -r "$SKILL_SRC/references/"* "$REMOTE:$SKILL_DST/references/"
        echo "  ✓ Copied references/"
    fi

    # Copy commands/ to global commands dir
    if [ -d "$SKILL_SRC/commands" ]; then
        count=$(ls -1 "$SKILL_SRC/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt "0" ]; then
            scp -q "$SKILL_SRC/commands/"*.md "$REMOTE:$REMOTE_COMMANDS/"
            echo "  ✓ Copied $count commands"
        fi
    fi

    # Copy agents/ to global agents dir
    if [ -d "$SKILL_SRC/agents" ]; then
        count=$(ls -1 "$SKILL_SRC/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt "0" ]; then
            scp -q "$SKILL_SRC/agents/"*.md "$REMOTE:$REMOTE_AGENTS/"
            echo "  ✓ Copied $count agents"
        fi
    fi

    # Copy scripts/
    if [ -d "$SKILL_SRC/scripts" ]; then
        ssh "$REMOTE" "mkdir -p '$SKILL_DST/scripts'"
        scp -q -r "$SKILL_SRC/scripts/"* "$REMOTE:$SKILL_DST/scripts/"
        ssh "$REMOTE" "chmod +x '$SKILL_DST/scripts/'*.sh 2>/dev/null || true"
        echo "  ✓ Copied scripts/"
    fi

    echo ""
done

# Deploy common commands (no skill, just commands)
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
echo "✓ Deployment to $REMOTE complete!"
echo "=============================================="
echo ""
echo "Deployed ${#SKILLS[@]} skills to $REMOTE:"
for skill in "${SKILLS[@]}"; do
    echo "  - $REMOTE_SKILLS/$skill"
done
echo "  - $REMOTE_COMMANDS (commands)"
echo "  - $REMOTE_AGENTS (agents)"
echo ""
echo "Run ./verify-genesis.sh to validate deployment."
echo ""
