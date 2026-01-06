# /dev-execute

Execute the implementation plan step by step with tests.

## What This Does

Stage 3 of dev-cycle: Implement one step at a time with pytest verification.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-cycle/SKILL.md` - See "Stage 3: Execution" section
- `~/.claude/skills/dev-cycle/references/3-execution-guide.md` - Detailed process
- `docs/[name]-implementation.md` - The plan to execute
- `docs/[name]-results.md` - Track progress here

## Input

**First argument (required):**
- File path to implementation plan (e.g., `docs/poc6-implementation.md`)
- Work item name (e.g., `poc6`, `feature-x`) → Will look for `docs/[name]-implementation.md`

**Second argument (optional):**
- Step number or identifier (e.g., `3`, `step-3`, `Step 3`)
- If provided: Execute this specific step
- If omitted: Execute the NEXT incomplete step from results.md

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Execute next incomplete step
/dev-execute docs/poc6-implementation.md

# Execute specific step
/dev-execute docs/poc6-implementation.md 3 --notes "Skip database migration for now"

# Using work item name
/dev-execute poc6 step-5
```

**Required files:**
- `docs/[name]-implementation.md` - The plan to execute
- `docs/[name]-results.md` - Will be created if doesn't exist, then updated with progress after each step

## Key Requirements

⚠️ **ONE STEP THEN STOP** - Execute ONLY current step, DO NOT continue to next automatically

⚠️ **LOOP UNTIL TESTS PASS** - If tests fail, fix and re-test until ALL tests pass

📝 **DOCUMENT AND STOP** - When tests pass, update results.md and STOP - report to user

🏗️ **PRODUCTION-GRADE** - OOP, Pydantic, type hints, real data, error handling

## Process

Follow the guidance in `3-execution-guide.md`:

**First time setup**: If `docs/[name]-results.md` doesn't exist, create it using the template (`assets/templates/implementation-results.md`). Fill in Summary, Goal, Success Criteria (from implementation.md), and Prerequisites. Mark all steps as "Pending".

**Execution Mode**: Execute ONLY ONE step, then STOP
- If step number provided: Execute that specific step
- If no step number: Find first incomplete step in results.md and execute it
- DO NOT continue to next step automatically

**Per Step Workflow** (loop until tests pass):
1. Write implementation code for current step
2. Write tests (`tests/test_[name]_*.py`)
3. Run pytest verification
4. **IF TESTS FAIL**: Fix the issue and return to step 3 (loop until all tests pass)
5. **IF TESTS PASS**: Update results.md (status + lessons learned) and STOP
6. Report completion to user

**Critical Rules:**
- Execute ONLY the current step, then STOP
- DO NOT move to next step automatically
- A step is NOT complete until ALL tests pass
- When tests pass, update docs and STOP - let user decide next action

## Output

Per step:
- Implementation code files
- Test files (`tests/test_[name]_*.py`)
- Updated `docs/[name]-results.md`

## After Step Completion

When current step tests pass and docs are updated:
- STOP and report completion to user
- User decides next action (continue to next step, run health check, etc.)

## After All Steps Complete

When all work item steps are complete:
- Run `/small-win-check` to update Latest Health Check in PROJECT_STATE.md
- Return to Stage 2 for next work item
