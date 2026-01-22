#!/bin/bash
# Verify Claude Code skills are deployed correctly
# Usage: ./verify.sh
#
# To add/remove a skill: Edit the SKILLS array below

#=============================================================================
# CONFIGURATION - Edit this section to add/remove skills
#=============================================================================
SKILLS=(
    "dev-design"
    "dev-cycle"
    "market-research"
)

# Old skill directories that should NOT exist
OLD_SKILLS=(
    "idea-to-mvp"
    "blueprint"
)

# Key commands that must exist (sanity check)
REQUIRED_COMMANDS=(
    "verify-doc.md"
    "dev-health.md"
    "market-research.md"
)
#=============================================================================

SKILLS_DIR="$HOME/.claude/skills"
COMMANDS_DIR="$HOME/.claude/commands"
AGENTS_DIR="$HOME/.claude/agents"

PASS_COUNT=0
FAIL_COUNT=0

echo "=============================================="
echo "Verifying deployment..."
echo "=============================================="
echo ""

# Helper functions
pass() {
    echo "  ✅ $1"
    ((PASS_COUNT++))
}

fail() {
    echo "  ❌ $1"
    ((FAIL_COUNT++))
}

# Check old skills are removed
echo "--- Checking old skills removed ---"
for old_skill in "${OLD_SKILLS[@]}"; do
    if [ ! -d "$SKILLS_DIR/$old_skill" ]; then
        pass "$old_skill skill removed"
    else
        fail "$old_skill skill still exists at $SKILLS_DIR/$old_skill"
    fi
done
echo ""

# Check each skill
for skill in "${SKILLS[@]}"; do
    echo "--- Checking $skill skill ---"
    SKILL_DST="$SKILLS_DIR/$skill"

    if [ -d "$SKILL_DST" ]; then
        pass "$skill directory exists"

        # Check SKILL.md
        if [ -f "$SKILL_DST/SKILL.md" ]; then
            pass "SKILL.md exists"

            # Check title matches skill name
            if head -1 "$SKILL_DST/SKILL.md" | grep -q "^# $skill"; then
                pass "SKILL.md has correct title"
            else
                fail "SKILL.md title should be '# $skill'"
            fi
        else
            fail "SKILL.md missing"
        fi

        # Check assets/templates/
        if [ -d "$SKILL_DST/assets/templates" ]; then
            pass "assets/templates/ exists"

            template_count=$(ls -1 "$SKILL_DST/assets/templates/"*.md 2>/dev/null | wc -l | tr -d ' ')
            if [ "$template_count" -gt "0" ]; then
                pass "Has $template_count templates"
            else
                fail "No templates found"
            fi
        else
            fail "assets/templates/ missing"
        fi

        # Check references/
        if [ -d "$SKILL_DST/references" ]; then
            pass "references/ exists"
        else
            fail "references/ missing"
        fi
    else
        fail "$skill directory missing at $SKILL_DST"
    fi

    echo ""
done

# Check commands
echo "--- Checking global commands ---"
if [ -d "$COMMANDS_DIR" ]; then
    pass "commands directory exists"

    # Count total commands
    total_cmd_count=$(ls -1 "$COMMANDS_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
    pass "Has $total_cmd_count total commands"

    # Check required commands
    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if [ -f "$COMMANDS_DIR/$cmd" ]; then
            pass "$cmd exists"
        else
            fail "$cmd missing"
        fi
    done
else
    fail "commands directory missing at $COMMANDS_DIR"
fi

echo ""

# Check agents
echo "--- Checking agents ---"
if [ -d "$AGENTS_DIR" ]; then
    pass "agents directory exists"

    agent_count=$(ls -1 "$AGENTS_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$agent_count" -gt "0" ]; then
        pass "Has $agent_count agents"
    else
        # Agents are optional, so just note it
        echo "  ℹ️  No agents deployed (this may be expected)"
    fi
else
    echo "  ℹ️  agents directory not found (this may be expected)"
fi

echo ""
echo "=============================================="
echo "Verification Summary"
echo "=============================================="
echo "  ✅ Passed: $PASS_COUNT"
echo "  ❌ Failed: $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "🎉 All checks passed! Deployment is correct."
    exit 0
else
    echo "⚠️  Some checks failed. Please review the output above."
    exit 1
fi
