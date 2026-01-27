---
description: Finalize task with timestamp, lessons, diagram, and health check (all 4 steps)
argument-hint: <task-slug>
context: fork
agent: dev-finalize-agent
disable-model-invocation: true
---

Finalize a completed task following the dev finalization workflow.

**Input**: $ARGUMENTS

**Examples**:
- `/agent-dev-finalize core-poc2` - Finalize PoC 2 in core milestone
- `/agent-dev-finalize cloud-auth-fix` - Finalize auth fix in cloud milestone

The agent will complete ALL 4 steps without stopping:
1. Timestamp the results doc
2. Consolidate lessons learned
3. Generate ASCII diagram
4. Run health check and update PROJECT_STATE.md
