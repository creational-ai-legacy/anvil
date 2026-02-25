---
description: "Define atomic tasks with dependencies and success criteria (Stage 5)"
argument-hint: "<milestone-slug-or-path>"
disable-model-invocation: true
---

# /design-task-spec

Break a milestone into atomic, executable tasks -- with PRODUCTION-GRADE thin slices.

## What This Does

Stage 5 of design skill: Define atomic tasks with clear success criteria and dependencies.

## Resources

**Read these for guidance**:
- `~/.claude/skills/design/SKILL.md` - See "Stage 5: Task Spec" section
- `~/.claude/skills/design/references/5-task-spec-guide.md` - Detailed process
- `~/.claude/skills/design/assets/templates/5-task-spec.md` - Output template

## Prerequisites

Must complete before running this command:
- [ ] Stage 4: Milestone Spec (`docs/[milestone-slug]-milestone-spec.md`)
- [ ] Stage 3: Roadmap (`docs/[project-slug]-roadmap.md`)

## Input

**First argument (optional):**
- Milestone slug (e.g., "core", "cloud") → Finds `docs/[milestone-slug]-milestone-spec.md`
- If not provided, uses first milestone from `docs/[project-slug]-roadmap.md`
- OR path to existing task spec (e.g., `docs/core-task-spec.md`) → Update mode

**Required docs (auto-read):**
- `docs/[milestone-slug]-milestone-spec.md` - Detailed milestone design
- `docs/[project-slug]-roadmap.md` - Milestone context

**User notes (optional):**
```
{{notes}}
```

**Mode Detection:**
- If argument is milestone name (or empty) → **Create mode** (new task spec from milestone spec)
- If argument is `docs/*-task-spec.md` → **Update mode** (add new tasks)

**Output naming:**
- Derives from milestone slug → `docs/[slug]-task-spec.md`
- Example: `docs/web-core-milestone-spec.md` → `docs/web-core-task-spec.md`

## Key Requirements

⛔ **NO CODE** - This is design only (task planning, dependencies, success criteria)

## Process

**Create Mode** - Follow the guidance in `5-task-spec-guide.md`:
1. Read the detailed milestone spec (`docs/[slug]-milestone-spec.md`)
2. Identify atomic tasks from the design
3. Map dependencies between tasks
4. Create task diagram
5. Define success criteria for each task

**Update Mode** - Add new tasks to existing design:
1. Read existing `docs/[slug]-task-spec.md`
2. Identify new tasks needed based on user notes
3. **Append** new tasks with next sequential numbers
4. Update dependency diagram to show where new tasks fit
5. **DO NOT renumber** existing tasks

## Examples

**Create task spec** (after `/design-milestone-spec`):
```bash
# After completing docs/web-core-milestone-spec.md

# Design tasks for milestone
/design-task-spec "web-core"

# Later, design tasks for another milestone
/design-task-spec "cloud"
```

**Update existing task spec** (add new tasks):
```bash
/design-task-spec docs/web-core-task-spec.md \
  --notes "Add tasks for rate limiting discovered during planning"
```

## Task Requirements

Each task must be:
- **Atomic**: Validates one specific thing
- **Measurable**: Clear success criteria
- **Self-contained**: Works independently; doesn't break existing functionality and existing tests

## Output

Creates:
- `docs/[slug]-task-spec.md` - Task spec derived from milestone spec

## After Completion

Run `/verify-doc docs/[slug]-task-spec.md` to validate, then hand off to **dev** skill for implementation.

**Next Stage**: Implementation via **dev** skill.
