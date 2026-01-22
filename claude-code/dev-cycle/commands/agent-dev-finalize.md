---
description: Finalize task with timestamp, lessons, diagram, and health check (all 4 steps)
argument-hint: <task-slug>
---

Use the **dev-finalize-agent** subagent to finalize a completed task.

**Input**: $ARGUMENTS

**Examples**:
```bash
/agent-dev-finalize core-poc2
/agent-dev-finalize cloud-auth-fix
```

The agent will complete ALL 4 steps without stopping:
1. Timestamp the results doc
2. Consolidate lessons learned
3. Generate ASCII diagram
4. Run health check and update PROJECT_STATE.md
