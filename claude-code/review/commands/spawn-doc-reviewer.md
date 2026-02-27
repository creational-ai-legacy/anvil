---
description: Review a design or implementation document in the background
argument-hint: <doc-path> [notes]
context: fork
agent: doc-reviewer
disable-model-invocation: true
---

Review a design or implementation document.

**Input**: $ARGUMENTS

**Examples**:
- `/spawn-doc-reviewer docs/core-architecture.md` - Review architecture doc
- `/spawn-doc-reviewer docs/core-poc2-plan.md check dependency chain` - Review plan with focus area
- `/spawn-doc-reviewer docs/core-poc3-design.md` - Review design doc
