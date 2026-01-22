---
description: Create design overview for feature/bug/PoC (Stage 1, NO CODE)
argument-hint: [file-path] [notes]
---

Use the **dev-overview-agent** subagent to create a design overview.

**Input**: $ARGUMENTS

**Examples**:
```bash
# From bug report file
/agent-dev-overview docs/bug-123.md "Focus on performance impact"

# From user description only
/agent-dev-overview "Add caching layer to reduce API calls"
```
