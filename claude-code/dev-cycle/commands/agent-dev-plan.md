---
description: Create implementation plan from overview document (Stage 2)
argument-hint: <doc-path> [update]
---

Use the **dev-plan-agent** subagent to create an implementation plan.

**Input**: $ARGUMENTS

**Examples**:
```bash
# Create new implementation plan from overview doc
/agent-dev-plan docs/core-poc6-overview.md

# Update existing implementation doc to match current template
/agent-dev-plan docs/core-poc6-implementation.md update
```
