---
description: Execute all remaining steps, spawning fresh subagent for each step. Runs in main conversation.
argument-hint: <plan-doc>
disable-model-invocation: true
---

# /dev-execute-run

Execute all remaining implementation steps, spawning a fresh subagent for each. After each step, a review agent checks for conceptual errors before moving to the next step.

## What This Does

Orchestrates Stage 3 execution by looping through steps, launching a fresh `dev-execute-agent` for each step and a fresh `dev-review-agent` after each. This avoids context exhaustion since each agent gets a clean context. The review agent catches conceptual errors that tests miss.

## Input

**Required**: Path to plan document
- File path: `docs/[milestone-slug]-[task-slug]-plan.md`
- Task name: `core-poc6` → looks for `docs/core-poc6-plan.md`

**User notes (optional)**:
```
{{notes}}
```

**Examples**:
```bash
/dev-execute-run docs/core-poc6-plan.md
/dev-execute-run core-poc6 --notes "Skip step 3, already done manually"
```

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `MAX_FIX_ATTEMPTS` | 3 | Fix→re-review cycles before stopping for human intervention |

## Process

**You are the orchestrator. Follow these steps exactly:**

### 1. Setup

1. Resolve the plan path (if task name given, convert to `docs/[name]-plan.md`)
2. Read the plan to get total step count
3. **Read the plan's Overview table → extract Risk Profile** (Critical / Standard / Exploratory)
4. Read or create results.md to find current progress
5. Identify all incomplete steps

### 2. For Each Step

**First**: Prereqs + Step 0 (if exists)
```
Spawn dev-execute-agent: "[plan-path] Prereqs + Step 0 (if exists)"
```

**Then** Step 1, 2, 3... repeat:

1. **Execute** → `Spawn dev-execute-agent: "[plan-path] [N]"`
   The agent handles its own test→fix→re-test cycle internally.
   - Fails → STOP.
   - Succeeds → Review.

2. **Review** → `Spawn dev-review-agent: "[results-doc] [N]"`
   - Skip for Exploratory risk profile → next step.
   - **PASS** → Next step.
   - **FLAG** → Re-execute using the **fix prompt** below, then review again. Repeat up to `MAX_FIX_ATTEMPTS` times. Still flagged → stop for human.

### Fix Prompt

When re-executing after a FLAG, paste the findings verbatim:
```
Spawn dev-execute-agent: "[plan-path] [N] --fix

Review flagged the following issues for step [N]:

1. [Check name]: [Exact details from review — paste verbatim]
2. [Check name]: [Exact details]

Fix ONLY these specific issues:
- Do not re-implement the entire step
- Do not restructure code beyond what's needed to address the flags
- Re-run affected tests after fixing
- Update the Trade-offs & Decisions section if the fix involves a new decision
- Update the step block in results.md IN-PLACE: replace Implementation, Test Results,
  and Issues sections with post-fix state. Do not append below the original."
```

### Stop Templates

**All fix attempts exhausted:**
```markdown
## Review Still Flagging After Fix

**Task**: [task-name]
**Step**: [N] - [Step Name]
**Remaining Issues**: [paste from latest re-review]

All fix attempts exhausted. This likely requires a design-level decision, not a code-level fix.

### Next Action
Review the flagged issues, update the design doc if needed, then run `/dev-execute-run [plan]` to continue.
```

**Execution failure or unrecoverable stop:**
```markdown
## Execution Stopped

**Task**: [task-name]
**Steps Completed**: [X] of [Total]
**Stopped At**: Step [N] - [reason: test failure / review flag after fix]

### Next Action
Fix issues, then run `/dev-execute-run [plan]` to continue
```

### 3. Completion

When all steps complete successfully:
1. Show brief summary
2. Spawn `dev-finalize-agent`:

| Parameter | Value |
|-----------|-------|
| `subagent_type` | `dev-finalize-agent` |
| `description` | `Finalize [task-slug]` |
| `prompt` | `Finalize the task at [results-path]. Run all 4 steps: timestamp, lessons, diagram, health check.` |

3. Report final status

## Key Rules

1. **Fresh agent per step** - Always use Task tool to spawn agents
2. **Stop on failure** - Do NOT continue if a step fails (tests or review)
3. **Report between steps** - Brief status update so user sees progress
4. **NEVER SKIP STEPS** - Even if you think a step is done, DELEGATE IT ANYWAY
5. **Review gate is mandatory** for Critical and Standard risk profiles

## CRITICAL: You Are a Dumb Orchestrator

**You MUST NOT:** skip steps, make completion decisions, update results.md, interpret review content, or be "smart" about what needs to run.

**Your job:** Spawn agents in order. Read PASS/FLAG. Paste FLAG details verbatim into fix prompts. Continue or stop. That's it.

Only subagents determine completion, update results, skip done work, or judge quality. If you skip steps, results.md gets corrupted. ALWAYS DELEGATE.
