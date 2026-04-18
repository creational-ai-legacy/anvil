#!/bin/bash
# Verify Claude Code skills are deployed correctly on genesis via SSH
# Usage: ./verify-genesis.sh
#
# Requires: ssh genesis configured in ~/.ssh/config
#
# Mirrors verify.sh but runs all existence checks on the remote host.
# Keep arrays in sync with verify.sh.

#=============================================================================
# CONFIGURATION - Keep in sync with verify.sh
#=============================================================================
REMOTE="genesis"
REMOTE_HOME="/home/pi"

SKILLS=(
    "design"
    "dev"
    "research"
    "review"
)

# Old skill directories that should NOT exist
OLD_SKILLS=(
    "idea-to-mvp"
    "blueprint"
    "dev-design"
    "dev-cycle"
    "market-research"
    "verify"
    "skill-reviewer"
)

# Old commands that should NOT exist (replaced by skills or removed)
OLD_COMMANDS=(
    "vp-transcript.md"
    "vp-meta.md"
    "design-northstar.md"
    "design-milestones-overview.md"
    "design-milestone-design.md"
    "design-poc-design.md"
    "dev-lessons.md"
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

# Old agents that should NOT exist (renamed to role-based names)
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

# Key commands that must exist (sanity check)
REQUIRED_COMMANDS=(
    "review-doc.md"
    "review-skill.md"
    "dev-health.md"
    "market-research.md"
)

# Key agents that must exist (sanity check)
REQUIRED_AGENTS=(
    "doc-reviewer.md"
)
#=============================================================================

REMOTE_SKILLS="$REMOTE_HOME/.claude/skills"
REMOTE_COMMANDS="$REMOTE_HOME/.claude/commands"
REMOTE_AGENTS="$REMOTE_HOME/.claude/agents"

PASS_COUNT=0
FAIL_COUNT=0

echo "=============================================="
echo "Verifying deployment on $REMOTE..."
echo "=============================================="
echo ""

# Test SSH connection
if ! ssh -o ConnectTimeout=5 "$REMOTE" "echo ok" > /dev/null 2>&1; then
    echo "Error: Cannot connect to $REMOTE" >&2
    exit 1
fi

# Helper functions
pass() {
    echo "  ✅ $1"
    ((PASS_COUNT++))
}

fail() {
    echo "  ❌ $1"
    ((FAIL_COUNT++))
}

# Remote test helpers
r_dir_exists() { ssh "$REMOTE" "[ -d '$1' ]"; }
r_file_exists() { ssh "$REMOTE" "[ -f '$1' ]"; }
r_count_files() { ssh "$REMOTE" "ls -1 '$1'/*.md 2>/dev/null | wc -l | tr -d ' '"; }
r_head1_grep() { ssh "$REMOTE" "head -1 '$1' | grep -q '^# $2'"; }

# Check old skills are removed
echo "--- Checking old skills removed ---"
for old_skill in "${OLD_SKILLS[@]}"; do
    if ! r_dir_exists "$REMOTE_SKILLS/$old_skill"; then
        pass "$old_skill skill removed"
    else
        fail "$old_skill skill still exists at $REMOTE:$REMOTE_SKILLS/$old_skill"
    fi
done
echo ""

# Check old commands are removed
echo "--- Checking old commands removed ---"
for old_cmd in "${OLD_COMMANDS[@]}"; do
    if ! r_file_exists "$REMOTE_COMMANDS/$old_cmd"; then
        pass "$old_cmd removed"
    else
        fail "$old_cmd still exists at $REMOTE:$REMOTE_COMMANDS/$old_cmd"
    fi
done
echo ""

# Check old agents are removed
echo "--- Checking old agents removed ---"
for old_agent in "${OLD_AGENTS[@]}"; do
    if ! r_file_exists "$REMOTE_AGENTS/$old_agent"; then
        pass "$old_agent removed"
    else
        fail "$old_agent still exists at $REMOTE:$REMOTE_AGENTS/$old_agent"
    fi
done
echo ""

# Check each skill
for skill in "${SKILLS[@]}"; do
    echo "--- Checking $skill skill ---"
    SKILL_DST="$REMOTE_SKILLS/$skill"

    if r_dir_exists "$SKILL_DST"; then
        pass "$skill directory exists"

        # Check SKILL.md
        if r_file_exists "$SKILL_DST/SKILL.md"; then
            pass "SKILL.md exists"

            # Check title matches skill name
            if r_head1_grep "$SKILL_DST/SKILL.md" "$skill"; then
                pass "SKILL.md has correct title"
            else
                fail "SKILL.md title should be '# $skill'"
            fi
        else
            fail "SKILL.md missing"
        fi

        # Check assets/templates/ (optional -- not all skills have templates)
        if r_dir_exists "$SKILL_DST/assets/templates"; then
            pass "assets/templates/ exists"

            template_count=$(r_count_files "$SKILL_DST/assets/templates")
            if [ "$template_count" -gt "0" ]; then
                pass "Has $template_count templates"
            else
                fail "No templates found"
            fi
        else
            echo "  ℹ️  No assets/templates/ (this is OK for some skills)"
        fi

        # Check references/
        if r_dir_exists "$SKILL_DST/references"; then
            pass "references/ exists"
        else
            fail "references/ missing"
        fi
    else
        fail "$skill directory missing at $REMOTE:$SKILL_DST"
    fi

    echo ""
done

# Check commands
echo "--- Checking global commands ---"
if r_dir_exists "$REMOTE_COMMANDS"; then
    pass "commands directory exists"

    total_cmd_count=$(r_count_files "$REMOTE_COMMANDS")
    pass "Has $total_cmd_count total commands"

    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if r_file_exists "$REMOTE_COMMANDS/$cmd"; then
            pass "$cmd exists"
        else
            fail "$cmd missing"
        fi
    done
else
    fail "commands directory missing at $REMOTE:$REMOTE_COMMANDS"
fi

echo ""

# Check agents
echo "--- Checking agents ---"
if r_dir_exists "$REMOTE_AGENTS"; then
    pass "agents directory exists"

    agent_count=$(r_count_files "$REMOTE_AGENTS")
    if [ "$agent_count" -gt "0" ]; then
        pass "Has $agent_count agents"
    else
        echo "  ℹ️  No agents deployed (this may be expected)"
    fi

    for agent in "${REQUIRED_AGENTS[@]}"; do
        if r_file_exists "$REMOTE_AGENTS/$agent"; then
            pass "$agent exists"
        else
            fail "$agent missing"
        fi
    done
else
    echo "  ℹ️  agents directory not found (this may be expected)"
fi

echo ""
echo "=============================================="
echo "Verification Summary ($REMOTE)"
echo "=============================================="
echo "  ✅ Passed: $PASS_COUNT"
echo "  ❌ Failed: $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "🎉 All checks passed! Deployment on $REMOTE is correct."
    exit 0
else
    echo "⚠️  Some checks failed. Please review the output above."
    exit 1
fi
