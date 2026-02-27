---
description: Review a document using parallel subagents for per-item and cross-cutting checks. Runs in main conversation.
argument-hint: <doc-path> [--auto] [notes]
disable-model-invocation: true
---

# /review-doc-run

Review a document using parallel subagents -- item reviewers check each item, holistic reviewer checks cross-cutting concerns, orchestrator merges findings.

**Guide**: `~/.claude/skills/review/references/review-doc-run-guide.md`

## Usage

```bash
/review-doc-run docs/core-poc3-plan.md
/review-doc-run docs/core-poc3-plan.md --auto
/review-doc-run docs/core-task-spec.md focus on dependency chain
```

## Input

- **Argument (required)**: Single document path
- **Flag (optional)**: `--auto` -- apply all fixes immediately instead of presenting report only
- **Notes (optional)**: Additional context or focus areas

## Process

1. Read the guide
2. Identify document type and extract items
3. Spawn item reviewers + holistic reviewer in parallel
4. Merge findings and assemble report
5. Present report (or apply fixes if `--auto`)

Read the guide. Follow it exactly.
