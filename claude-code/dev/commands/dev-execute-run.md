---
description: Execute all remaining steps, spawning fresh subagent for each step. Runs in main conversation.
argument-hint: <plan-doc>
disable-model-invocation: true
---

# /dev-execute-run

Execute all remaining implementation steps, spawning a fresh subagent for each.

## What This Does

Orchestrates Stage 3 execution by looping through steps, launching a fresh `dev-executor` for each step. This avoids context exhaustion since each agent gets a clean context.

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

## Process

**You are the orchestrator. Follow these steps exactly:**

### 1. Setup

1. Resolve the plan path (if task name given, convert to `docs/[name]-plan.md`)
2. Read the plan and extract the ordered list of step identifiers by scanning for `### Step [ID]:` headings (e.g., `0, 1, 2, 3` or `0, 1, 2, 3a, 3b, 3c, 4`)
3. Read or create results.md to find current progress
4. Identify all incomplete steps

### 2. For Each Step

**First**: Prereqs + Step 0 (if exists)
```
Spawn dev-executor: "[plan-path] Prereqs + Step 0 (if exists)"
```

**Then** iterate through remaining step IDs in order:

1. **Execute** → `Spawn dev-executor: "[plan-path] [step-id]"`
   - Fails → STOP.
   - Succeeds → Next step.

### Stop Template

**Execution failure or unrecoverable stop:**
```markdown
## Execution Stopped

**Task**: [task-name]
**Steps Completed**: [X] of [Total]
**Stopped At**: Step [N] - [reason]

### Next Action
Fix issues, then run `/dev-execute-run [plan]` to continue
```

### 3. Completion

When all steps complete successfully:
1. Show brief summary
2. Spawn `dev-finalizer`:

| Parameter | Value |
|-----------|-------|
| `subagent_type` | `dev-finalizer` |
| `description` | `Finalize [task-slug]` |
| `prompt` | `Finalize the task at [results-path]. Run all 4 steps: timestamp, lessons, diagram, health check.` |

3. Report final status

## Key Rules

1. **Fresh agent per step** - Always use Task tool to spawn agents
2. **Stop on failure** - Do NOT continue if a step fails
3. **Report between steps** - Brief status update so user sees progress
4. **NEVER SKIP STEPS on your own judgment** - Even if you think a step is done, DELEGATE IT ANYWAY. User notes override this (e.g., user says "skip step 3" → respect that)

## CRITICAL: You Are a Dumb Orchestrator

**You MUST NOT:** skip steps, make completion decisions, update results.md, or be "smart" about what needs to run.

**Your job:** Spawn agents in order. Continue or stop. That's it.

Only subagents determine completion, update results, skip done work, or judge quality. If you skip steps, results.md gets corrupted. ALWAYS DELEGATE.
