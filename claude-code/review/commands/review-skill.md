---
description: Audit a skill for structural correctness, frontmatter, architecture hierarchy, cross-references, and consistency. Runs in main conversation.
argument-hint: <skill-name>
disable-model-invocation: true
---

# /review-skill

Audit a Claude Code skill for quality and consistency.

## Resources

**Read these for guidance**:
- `~/.claude/skills/review/references/skill-review-guide.md` - Complete validation rules
- `~/.claude/skills/review/assets/templates/skill-review-report.md` - Report format

## Input

**Argument (required):** Skill name or path to skill directory.

Parse the skill name from the argument. It may be:
- A bare name: `dev`, `research`
- A path: `claude-code/dev`, `claude-code/review`
- A path with `@` prefix: `@claude-code/dev`

Extract the skill name from the last path segment (e.g., `claude-code/review` -> `review`).

Resolves to: `claude-code/[skill-name]/` in the project root.

**Examples:**
```bash
/review-skill dev
/review-skill @claude-code/research
```

## Process

Read the guide. Follow it exactly.

## Output

Review report displayed to user with:
- Summary table (8 checks, pass/fail)
- Issues listed by severity (HIGH / MED / LOW)
- Verdict (Clean or issues found)
