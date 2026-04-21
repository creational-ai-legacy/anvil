---
description: Run /exam in a tick-driven loop, coordinating with /review-doc-run-loop via the shared review doc. Long-running loop; main conversation only.
argument-hint: <doc-path> [N] [--first | --follow] [notes]
disable-model-invocation: true
---

# /exam-loop

Tick-driven loop that coordinates with `/review-doc-run-loop` via the shared review doc. Runs N additive rounds of E following R (default) or leading R (with `--first`). Long-running, main conversation only.

**Guide**: `~/.claude/skills/review/references/review-loop-guide.md`

## Usage

```bash
# Default workflow (exam follows, N defaults to 2)
/exam-loop docs/core-settings-redesign-plan.md

# Explicit N
/exam-loop docs/core-settings-redesign-plan.md 3

# Resume (adds one more E round)
/exam-loop docs/core-poc6-design.md 1

# Warning: exam-first workflows require coordinated flags on BOTH commands --
# --first on /exam-loop AND --follow on /review-doc-run-loop. Missing --follow
# silently degrades to parallel execution; missing --first causes both sides to
# wait until idle termination. Always pair the flags.
# Exam-first workflow -- MUST be paired with /review-doc-run-loop --follow in another session
/exam-loop docs/core-poc6-design.md --first

# With notes
/exam-loop docs/core-poc6-plan.md 3 check the gate arithmetic
```

## Input

- `<doc-path>` (required) -- the review target document
- `[N]` (optional, default 2) -- positive integer in `[1, 20]`, number of MORE rounds to run (additive). Omit to accept the default `DEFAULT_ROUNDS = 2`. See guide for parse rules. The command body does NOT validate N -- the loop guide's Argument Parsing step owns all parsing.
- `--first` or `--follow` (optional, mutually exclusive) -- overrides this side's default role (default: exam=follower). Use `--first` to pair with `/review-doc-run-loop --follow` for exam-first workflow.
- `[notes]` (optional) -- free-form text appended after the flag

## Process

1. Read the loop guide.
2. Parse `<doc>`, `<N>`, `--first`/`--follow`, notes. Error if both flags are present.
3. Determine role from own flags: `--first` forces leader, `--follow` forces follower, else side default (review=leader, exam=follower).
4. Initial entry: evaluate gate for this side/role; either run round 1 (review: arm pre-round sentinel, spawn Phase 1 (setup) followed by Phase 2 (background spawning), end turn) or arm timer and wait.
5. On tick wake: parse TIMER echo, re-read doc, evaluate gate, run round or wait, arm next timer or exit.
6. Terminate when `rounds_done >= N`, 4 consecutive idle ticks, or counterpart never started.

Read the guide. Follow it exactly.
