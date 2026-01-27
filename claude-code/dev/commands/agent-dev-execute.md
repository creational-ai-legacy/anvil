---
description: Execute implementation step with tests (Stage 3)
argument-hint: <plan-doc> [step-number]
context: fork
agent: dev-execute-agent
disable-model-invocation: true
---

Execute an implementation step following the dev Stage 3 workflow.

**Input**: $ARGUMENTS

**Examples**:
- `/agent-dev-execute docs/core-poc6-plan.md` - Execute next incomplete step
- `/agent-dev-execute docs/core-poc6-plan.md 3` - Execute step 3 specifically
