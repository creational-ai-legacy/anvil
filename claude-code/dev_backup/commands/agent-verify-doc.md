---
description: Verify design or implementation documents
argument-hint: <doc-path> [notes]
context: fork
agent: verify-doc-agent
disable-model-invocation: true
---

Verify a design or implementation document.

**Input**: $ARGUMENTS

**Examples**:
- `/agent-verify-doc core-architecture.md` - Verify architecture doc
- `/agent-verify-doc docs/core-poc2-plan.md check dependency chain` - Verify plan with focus area
- `/agent-verify-doc docs/core-poc3-design.md` - Verify design doc
