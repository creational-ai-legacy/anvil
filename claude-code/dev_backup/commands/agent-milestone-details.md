---
description: Generate comprehensive milestone summary document
argument-hint: <milestone-slug> [update]
context: fork
agent: milestone-details-agent
disable-model-invocation: true
---

Generate a comprehensive milestone summary document.

**Input**: $ARGUMENTS

**Examples**:
- `/agent-milestone-details core` - Create new milestone details doc
- `/agent-milestone-details core update` - Update existing doc with current progress
