---
description: Create implementation plan for a task (Stage 2). Runs in main conversation.
argument-hint: [design-doc] [notes]
disable-model-invocation: true
---

# /dev-plan

Create a detailed implementation plan for a single task.

## What This Does

Stage 2 of dev: Break down one task into bite-sized, production-grade steps.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev/SKILL.md` - See "Stage 2: Planning" section
- `~/.claude/skills/dev/references/2-planning-guide.md` - Detailed process
- `~/.claude/skills/dev/assets/templates/2-plan.md` - Plan template

## Input

**First argument (recommended):**
- Design doc path: `docs/[slug]-design.md` → use as blueprint
- If omitted → plan from scratch (for simple tasks)

**Other input modes:**
- Task identifier (e.g., `PoC 6`, `Feature 3`) → Reads from `[slug]-task-spec.md`
- Plan doc path + `update` → Updates to match current template

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Plan from design document (recommended)
/dev-plan docs/cloud-mcp-ux-design.md

# Plan a specific task from task-spec.md
/dev-plan "PoC 6" --notes "Focus on error handling"

# Plan from scratch (simple task, no design doc)
/dev-plan --notes "Add logging to cache_service.py"

# Update existing plan doc to match current template
/dev-plan docs/core-poc6-plan.md update
```

**The command will:**
1. Read design doc if provided
2. Verify Proposed Sequence against codebase
3. Break each Design item into bite-sized steps
4. Write specifications, acceptance criteria, and verification for each implementation step

**Update mode** (when input is plan doc + `update`):
1. Read the current template
2. Read the existing plan doc
3. Restructure to match template (preserve content, update structure)
4. Write updated plan doc

## Key Requirements

✅ **CODE ALLOWED** - Step 0/Prerequisites: concrete commands, configs. Steps 1+: spec-driven (specifications, acceptance criteria, verification commands).

🏗️ **PRODUCTION-GRADE** - OOP, validated data models, type safety, real data

🔒 **SELF-CONTAINED** - Add alongside, don't replace; works independently

🧪 **TESTS IN SAME STEP** - Each step includes writing AND running tests for that step's code (never separate)

## Process

Follow `2-planning-guide.md` exactly. It contains the full process for prerequisites, step breakdown, specifications, acceptance criteria, and trade-offs.

## Output

Create one document:
- `docs/[milestone-slug]-[task-slug]-plan.md` - Evergreen "how to" guide (NO status)

**Examples**: `docs/core-poc6-plan.md`, `docs/cloud-auth-fix-plan.md`

## After Completion

User will run `/review-doc` on the plan, fix issues, then request Stage 3 (Execution).
