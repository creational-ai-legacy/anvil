# /design-poc-design

Define what needs to be proven and in what order — with PRODUCTION-GRADE thin slices.

## What This Does

Stage 5 of dev-design: Plan atomic PoCs with clear success criteria and dependencies.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-design/SKILL.md` - See "Stage 5: PoC Design" section
- `~/.claude/skills/dev-design/references/5-poc-design-guide.md` - Detailed process
- `~/.claude/skills/dev-design/assets/templates/poc-design.md` - Output template

## Input

**First argument (optional):**
- Milestone name (e.g., "Core", "Cloud Deployment") → Reads milestone from `docs/milestones.md` (RECOMMENDED)
- Milestone number (e.g., "1", "2") → Reads Nth milestone from `docs/milestones.md`
- If not provided, uses first milestone from `docs/milestones.md`
- OR path to architecture doc (e.g., `docs/core-architecture.md`) → Create mode (legacy workflow)
- OR path to existing PoC design doc (e.g., `docs/core-poc-design.md`) → Update mode
- OR path to overview doc (e.g., `docs/feature-x-overview.md`) → Update mode from new feature

**User notes (optional):**
```
{{notes}}
```

**Mode Detection:**
- If argument is milestone name/number (or empty) → **Milestone mode** (reads from `docs/milestones.md`, recommended)
- If argument is `docs/*-poc-design.md` and exists → **Update mode** (add new PoCs from user notes)
- If argument is `docs/*-overview.md` → **Update mode** (extract PoCs from overview document)
- If argument is `docs/*-architecture.md` → **Create mode** (new poc-design from architecture, legacy)

**Output naming:**
- Milestone mode: Uses milestone name from `docs/milestones.md` → `docs/[milestone-name]-poc-design.md`
- Create mode: Derives `[name]` from architecture file → `docs/[name]-poc-design.md`
- Update mode: Uses existing file name

## Key Requirements

⛔ **NO CODE** - This is design only (PoC planning, dependencies, success criteria)

## Process

**Create Mode** - Follow the guidance in `5-poc-design-guide.md`:
1. Refine architecture with implementation perspective
2. Identify atomic things to prove (PoCs)
3. Map dependencies between PoCs
4. Create PoC diagram
5. Define success criteria for each PoC

**Update Mode A** - From overview document (common workflow):
1. Read the overview doc (e.g., `docs/feature-x-overview.md`)
2. Extract work items/PoCs identified in the overview
3. Read existing `docs/[milestone-name]-poc-design.md`
4. **Append** new PoCs with next sequential numbers (e.g., if last PoC is #5, new ones are #6, #7, #8)
5. Update dependency diagram to show where new PoCs fit
6. **DO NOT renumber** existing PoCs

**Update Mode B** - From user notes (quick updates):
1. Read existing `docs/[milestone-name]-poc-design.md`
2. Identify new PoCs needed based on user notes
3. **Append** new PoCs with next sequential numbers
4. Update dependency diagram to show where new PoCs fit
5. **DO NOT renumber** existing PoCs

## Examples

**Milestone workflow** (🔥 RECOMMENDED - after `/design-milestones`):
```bash
# After creating docs/milestones.md, design PoCs for each milestone

# Design PoCs for first milestone (Core)
/design-poc-design
# OR explicitly specify milestone
/design-poc-design "Core"
# OR use milestone number
/design-poc-design "1"

# Later, design PoCs for second milestone
/design-poc-design "Cloud Deployment"
# OR
/design-poc-design "2"
```

**Legacy create mode** (direct from architecture, skips milestone planning):
```bash
/design-poc-design docs/core-architecture.md
```

**Update from overview** (common workflow after `/dev-overview`):
```bash
/dev-overview --notes "Add caching layer to reduce API calls"
# Creates docs/caching-overview.md with work items

/design-poc-design docs/caching-overview.md
# Extracts PoCs from overview and adds to docs/core-poc-design.md
```

**Update from notes** (quick manual updates):
```bash
/design-poc-design docs/core-poc-design.md \
  --notes "Add PoCs for rate limiting and retry logic discovered in PoC 3"
```

## PoC Requirements

Each PoC must be:
- **Atomic**: Proves one specific thing
- **Measurable**: Clear success criteria
- **🔒 Self-contained**: Works independently; doesn't break existing functionality and existing tests

## Output

Create `docs/[milestone-name]-poc-design.md` using the template.

## After Completion

Run `/verify-doc docs/[milestone-name]-poc-design.md` to validate, then hand off to **dev-cycle** skill for implementation.
