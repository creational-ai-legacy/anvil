---
description: Execute implementation step with tests (Stage 3)
argument-hint: <plan-doc> [step-id]
context: fork
agent: dev-executor
disable-model-invocation: true
---

Execute an implementation step following the dev Stage 3 workflow.

**Input**: $ARGUMENTS

**Examples**:
- `/spawn-dev-executor docs/core-poc6-plan.md` - Execute next incomplete step
- `/spawn-dev-executor docs/core-poc6-plan.md 3` - Execute step 3 specifically
