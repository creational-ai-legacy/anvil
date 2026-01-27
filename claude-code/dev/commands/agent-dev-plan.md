---
description: Create implementation plan from design document (Stage 2)
argument-hint: <doc-path> [update]
context: fork
agent: dev-plan-agent
disable-model-invocation: true
---

Create an implementation plan following the dev Stage 2 workflow.

**Input**: $ARGUMENTS

**Examples**:
- `/agent-dev-plan docs/core-poc6-design.md` - Create new plan from design doc
- `/agent-dev-plan docs/core-poc6-plan.md update` - Update existing plan to match template
