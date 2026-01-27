# /design-milestone-design

Expand a single milestone into comprehensive, self-contained design document.

## What This Does

Stage 4 of design skill: Create detailed design for one milestone with implementation perspective.

## Resources

**Read these for guidance**:
- `~/.claude/skills/design/SKILL.md` - See "Stage 4: Milestone Design" section
- `~/.claude/skills/design/references/4-milestone-design-guide.md` - Detailed process
- `~/.claude/skills/design/assets/templates/milestone-design.md` - Output template

## Prerequisites

Must complete before running this command:
- [ ] Stage 3: Milestones Overview (`docs/[slug]-milestones-overview.md`)
- [ ] Stage 2: Architecture (`docs/[slug]-architecture.md`)

## Input

**First argument (required):**
- Milestone slug (e.g., "core", "cloud") → Reads milestone from `docs/[project-slug]-milestones-overview.md`

**Required docs (auto-read):**
- `docs/[project-slug]-milestones-overview.md` - Milestone overview with high-level sections
- `docs/[project-slug]-architecture.md` - Architecture document

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Design first milestone
/design-milestone-design "core"

# Later, design another milestone
/design-milestone-design "cloud"
```

**Output naming:**
- Derives from milestone in `docs/[project-slug]-milestones-overview.md`
- Creates `docs/[milestone-slug]-milestone.md`
- Example: `docs/core-milestone.md`, `docs/cloud-milestone.md`

## Key Requirements

⛔ **NO CODE** - This is design only (detailed architecture, components, phases)

## Process

Follow the guidance in `4-milestone-design-guide.md`:
1. Select milestone from overview
2. Write Executive Summary (2-3 paragraphs + key principle)
3. Expand Goal section (what it proves + what it doesn't)
4. Expand Architecture Overview (diagram, stack, cost)
5. Design Core Components (3-6 components with full detail)
6. Detail Implementation Phases
7. Expand Success Metrics
8. Add Key Outcomes
9. Document Design Decisions & Rationale
10. Identify Risks & Mitigation
11. Document Open Questions
12. Define Next Steps (three time horizons)

## Output

Creates:
- `docs/[slug]-milestone.md` - Comprehensive milestone design

## Key Principles

**Self-Contained**: Focus ONLY on this milestone (no forward references to other milestones)

**Implementation Perspective**: Production-grade design, not prototypes

**Design-Focused**: Focus on WHAT and WHY, not rigid WHEN

## After Completion

User will run `/verify-doc docs/[slug]-milestone.md`, fix issues, then proceed to Stage 5 (PoC Design).

**Next Stage**: Create PoC design for this milestone, breaking it into atomic proof-of-concepts.
