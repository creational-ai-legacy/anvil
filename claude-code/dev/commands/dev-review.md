---
description: Review a completed execution step for conceptual errors (design-anchored). Runs in main conversation.
argument-hint: [results-doc] [step-number]
disable-model-invocation: true
---

# /dev-review

Review a completed execution step against the design doc for conceptual errors.

## What This Does

Post-execution conceptual review. Compares the implementation output against the design doc's intent. Catches errors that tests miss: wrong assumptions, silent trade-offs, architectural drift, over-engineering.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev/references/review-guide.md` - Review process and checklist
- `docs/[milestone-slug]-[task-slug]-design.md` - The design to review against
- `docs/[milestone-slug]-[task-slug]-plan.md` - Risk profile and plan details
- `docs/[milestone-slug]-[task-slug]-results.md` - Step output + trade-offs to review

## Input

**First argument (required):**
- File path to results doc (e.g., `docs/core-poc6-results.md`)
- Task name (e.g., `core-poc6`) → Will look for `docs/[task-name]-results.md`

**Second argument (required):**
- Step number just completed (e.g., `3`)

**User notes (optional):**
{{notes}}

**Examples:**
```
/dev-review docs/core-poc6-results.md 3
/dev-review core-poc6 2 --notes "Watch for auth assumptions"
```

## Key Rules

- READ-ONLY — Do not modify implementation code
- DESIGN-ANCHORED — Compare against design intent, not just code correctness
- RISK-CALIBRATED — Apply checks at depth matching the plan's Risk Profile
- HONEST — Flag real concerns. Don't rubber-stamp.

## Process

Follow `review-guide.md`:

1. Read plan doc Overview → extract Risk Profile
2. Read design doc → understand original intent
3. Read results.md → find step output + Trade-offs & Decisions section
4. Read actual code changes (git diff or file reads)
5. Run Conceptual Review Checklist at appropriate depth
6. Append review findings to the step in results.md
7. Report PASS or FLAG

## Output

- Updated `docs/[milestone-slug]-[task-slug]-results.md` with review section for the step
- Completion report with verdict
