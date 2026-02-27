---
description: Review all completed steps in a results doc. Spawns review agents in parallel.
argument-hint: <results-doc>
disable-model-invocation: true
---

# /dev-review-run

Review all completed steps in parallel by spawning a `dev-reviewer` for each.

## Input

**Required**: Path to results document
- File path: `docs/[milestone-slug]-[task-slug]-results.md`
- Task name: `core-poc6` → looks for `docs/core-poc6-results.md`

**Examples**:
```bash
/dev-review-run docs/core-prefab-manager-results.md
/dev-review-run core-prefab-manager
```

## Process

**You are the orchestrator. Follow these steps exactly:**

### 1. Setup

1. Resolve the results path (if task name given, convert to `docs/[name]-results.md`)
2. Read the results doc to find all completed steps (status: ✅ Complete)
3. Find the corresponding plan doc (linked at top of results doc)
4. Read the plan doc's Overview table → extract the **Risk Profile**

### 2. Spawn Reviews in Parallel

For each completed step, spawn a `dev-reviewer` in background. Agents return their review block directly — no temp files needed.

```
Spawn dev-reviewer (run_in_background: true):
"[results-doc-path] step [N]"
```

Launch ALL review agents in a single message — do not wait between spawns.

### 3. Collect and Merge (stream as they finish)

**Do NOT wait for all agents.** Use `block: false` polling to check each agent, merge whichever is done, then loop back for the rest.

```
remaining = [all spawned agent IDs]

while remaining is not empty:
  for each agent_id in remaining:
    check agent_id with TaskOutput (block: false)
    if done:
      1. Extract the review block from the Task result
      2. Insert **Review** section into step {N} block in results.md
      3. Report to user: "Step {N} review: PASS/FLAG"
      4. Remove agent_id from remaining
  if remaining is not empty:
    wait briefly, then poll again (block: true, timeout: 15000 on first remaining agent)
```

**Format for results.md**: Use `~/.claude/skills/dev/assets/templates/review.md` for the review block format.

The **Reviewed** timestamp is the time the orchestrator merges the review into results.md. Run `date "+%Y-%m-%dT%H:%M:%S%z"` to get it.

### 4. Update Summary Table

After all reviews are merged, update the **Reviewed** field in the Summary table at the top of results.md:

```markdown
| **Reviewed** | [ISO 8601 with timezone] |
```

Run `date "+%Y-%m-%dT%H:%M:%S%z"` to get the timestamp. This records when the full review pass completed.

### 5. Report Summary

After all agents have completed, all reviews merged, and Summary table updated:

```markdown
## Review Summary

**Task**: [task-name]
**Steps Reviewed**: [count]
**Risk Profile**: [from plan]

| Step | Name | Verdict |
|------|------|---------|
| 0 | [name] | PASS / FLAG |
| 1 | [name] | PASS / FLAG |
| ... | ... | ... |

**Result**: All PASS / [N] flagged

[If any FLAG:]
### Flagged Issues
**Step [N]**: [issue summary from review agent]
```

## Key Rules

1. **All reviews in parallel** — spawn all agents in a single message with `run_in_background: true`
2. **Agents return reviews directly** — no temp files; read the review block from the Task result
3. **Orchestrator merges** — only the orchestrator writes to results.md
4. **Merge as they arrive** — as each agent completes, extract its review from the Task result and merge immediately
5. **Only review completed steps** — skip steps that are Pending or In Progress
6. **Report all results** — even if all PASS, show the summary table
