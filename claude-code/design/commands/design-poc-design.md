# /design-poc-design

Define what needs to be proven and in what order — with PRODUCTION-GRADE thin slices.

## What This Does

Stage 5 of design skill: Plan atomic PoCs with clear success criteria and dependencies.

## Resources

**Read these for guidance**:
- `~/.claude/skills/design/SKILL.md` - See "Stage 5: PoC Design" section
- `~/.claude/skills/design/references/5-poc-design-guide.md` - Detailed process
- `~/.claude/skills/design/assets/templates/poc-design.md` - Output template

## Prerequisites

Must complete before running this command:
- [ ] Stage 4: Milestone Design (`docs/[milestone-slug]-milestone.md`)
- [ ] Stage 3: Milestones Overview (`docs/[project-slug]-milestones-overview.md`)

## Input

**First argument (optional):**
- Milestone slug (e.g., "core", "cloud") → Finds `docs/[milestone-slug]-milestone.md`
- If not provided, uses first milestone from `docs/[project-slug]-milestones-overview.md`
- OR path to existing PoC design (e.g., `docs/core-poc-design.md`) → Update mode

**Required docs (auto-read):**
- `docs/[milestone-slug]-milestone.md` - Detailed milestone design
- `docs/[project-slug]-milestones-overview.md` - Milestone context

**User notes (optional):**
```
{{notes}}
```

**Mode Detection:**
- If argument is milestone name/number (or empty) → **Create mode** (new PoC design from milestone design)
- If argument is `docs/*-poc-design.md` → **Update mode** (add new PoCs)

**Output naming:**
- Derives from milestone slug → `docs/[slug]-poc-design.md`
- Example: `docs/web-core-milestone.md` → `docs/web-core-poc-design.md`

## Key Requirements

⛔ **NO CODE** - This is design only (PoC planning, dependencies, success criteria)

## Process

**Create Mode** - Follow the guidance in `5-poc-design-guide.md`:
1. Read the detailed milestone design (`docs/[slug]-milestone.md`)
2. Identify atomic things to prove (PoCs) from the design
3. Map dependencies between PoCs
4. Create PoC diagram
5. Define success criteria for each PoC

**Update Mode** - Add new PoCs to existing design:
1. Read existing `docs/[slug]-poc-design.md`
2. Identify new PoCs needed based on user notes
3. **Append** new PoCs with next sequential numbers
4. Update dependency diagram to show where new PoCs fit
5. **DO NOT renumber** existing PoCs

## Examples

**Create PoC design** (after `/design-milestone-design`):
```bash
# After completing docs/web-core-milestone.md

# Design PoCs for milestone
/design-poc-design "web-core"

# Later, design PoCs for another milestone
/design-poc-design "cloud"
```

**Update existing PoC design** (add new PoCs):
```bash
/design-poc-design docs/web-core-poc-design.md \
  --notes "Add PoCs for rate limiting discovered during planning"
```

## PoC Requirements

Each PoC must be:
- **Atomic**: Proves one specific thing
- **Measurable**: Clear success criteria
- **🔒 Self-contained**: Works independently; doesn't break existing functionality and existing tests

## Output

Creates:
- `docs/[slug]-poc-design.md` - PoC plan derived from milestone design

## After Completion

Run `/verify-doc docs/[slug]-poc-design.md` to validate, then hand off to **dev** skill for implementation.

**Next Stage**: Implementation via **dev** skill.
