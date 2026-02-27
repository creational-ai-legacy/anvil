---
description: Execute implementation step by step with tests (Stage 3). Runs in main conversation.
argument-hint: [plan-doc] [step-number]
disable-model-invocation: true
---

# /dev-execute

Execute the implementation plan step by step with tests.

## What This Does

Stage 3 of dev: Implement one step at a time with test verification.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev/SKILL.md` - See "Stage 3: Execution" section
- `~/.claude/skills/dev/references/3-execution-guide.md` - Detailed process
- `~/.claude/skills/dev/assets/templates/3-results.md` - Results template
- `docs/[milestone-slug]-[task-slug]-plan.md` - The plan to execute
- `docs/[milestone-slug]-[task-slug]-results.md` - Track progress here

## Input

**First argument (required):**
- File path to plan (e.g., `docs/core-poc6-plan.md`)
- Task name (e.g., `core-poc6`, `cloud-feature-x`) → Will look for `docs/[task-name]-plan.md`

**Second argument (optional):**
- Step number or identifier (e.g., `3`, `step-3`, `Step 3`)
- If provided: Execute this specific step
- If omitted: Execute the NEXT incomplete step from results.md

**Fix mode (optional):**
- `--fix` followed by review findings
- When present: Fix ONLY the specific flagged issues, update results.md in-place

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Execute next incomplete step
/dev-execute docs/core-poc6-plan.md

# Execute specific step
/dev-execute docs/core-poc6-plan.md 3 --notes "Skip database migration for now"

# Using task name
/dev-execute core-poc6 step-5

# Fix specific issues after review FLAG
/dev-execute docs/core-poc6-plan.md 3 --fix "Intent match: API returns raw dict instead of validated model"
```

**Required files:**
- `docs/[milestone-slug]-[task-slug]-plan.md` - The plan to execute
- `docs/[milestone-slug]-[task-slug]-results.md` - Will be created if doesn't exist, then updated with progress after each step

## Key Requirements

⚠️ **ONE STEP THEN STOP** - Execute ONLY current step, DO NOT continue to next automatically

⚠️ **LOOP UNTIL TESTS PASS** - If tests fail, fix and re-test until ALL tests pass

📝 **DOCUMENT AND STOP** - When tests pass, update results.md and STOP - report to user

🔧 **FIX MODE = SCOPED** - When `--fix` is present, fix ONLY the flagged issues, update results.md in-place

🏗️ **PRODUCTION-GRADE** - OOP, validated data models, type safety, real data, error handling

## Process

Follow `3-execution-guide.md` exactly. It contains the full per-step workflow, fix mode, and documentation requirements.

**First time**: If results doc doesn't exist, create from template. Record Started timestamp.

## Output

Per step:
- Implementation code files
- Test files (per environment conventions from the plan)
- Updated `docs/[milestone-slug]-[task-slug]-results.md`

## After Step Completion

When current step tests pass and docs are updated:
- STOP and report completion to user
- User decides next action (continue to next step, run health check, etc.)

## After All Steps Complete

When all task steps are complete and all success criteria are met:
1. **Ask user**: "All steps complete and tests passing. Mark task as complete?"
2. **If user confirms**: Run `/dev-finalize` to record timestamp, consolidate lessons, generate diagram, and run health check
3. Return to Stage 2 for next task
