---
description: Audit a skill for structure, frontmatter, architecture, and consistency in the background
argument-hint: <skill-name>
context: fork
agent: skill-reviewer
disable-model-invocation: true
---

Audit a Claude Code skill using the skill-reviewer agent.

**Skill to review**: $ARGUMENTS

Parse the skill name from the argument. It may be:
- A bare name: `dev`, `research`
- A path: `claude-code/dev`, `claude-code/review`
- A path with `@` prefix: `@claude-code/dev`

Extract the skill name from the last path segment (e.g., `claude-code/review` -> `review`). Do NOT ask the user to clarify -- start immediately.

**Examples**:
- `/spawn-skill-reviewer dev`
- `/spawn-skill-reviewer @claude-code/research`
