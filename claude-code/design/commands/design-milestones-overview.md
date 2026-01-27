# /design-milestones-overview

Create milestones overview roadmap breaking North Star into strategic phases.

## What This Does

Stage 3 of design skill: Break North Star + Architecture into strategic milestones.

## Resources

**Read these for guidance**:
- `~/.claude/skills/design/SKILL.md` - See "Stage 3: Milestones Overview" section
- `~/.claude/skills/design/references/3-milestones-overview-guide.md` - Detailed process
- `~/.claude/skills/design/assets/templates/milestones-overview.md` - Template

## Prerequisites

Must complete before running this command:
- [ ] Stage 1: North Star (`docs/[slug]-north-star.md`)
- [ ] Stage 2: Architecture (`docs/[slug]-architecture.md`)

## Input

**Required docs (auto-read):**
- `docs/[slug]-north-star.md` - Vision and goals
- `docs/[slug]-architecture.md` - Architecture document
- Research findings (if any exist)

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Basic usage (reads all docs + user context)
/design-milestones-overview

# With specific guidance
/design-milestones-overview "Clear path: Core → Mobile → Enterprise"

# For unclear path
/design-milestones-overview "Small project - just start with Core milestone"
```

## Key Requirements

⛔ **NO CODE** - This is design only (milestone planning, strategic roadmap)

## Process

1. **Read all prerequisite docs:**
   - Read `docs/[slug]-north-star.md`
   - Read `docs/[slug]-architecture.md`
   - Read any research findings (Stage 3 outputs)
   - Review user notes

2. **Follow the guidance in `4-milestones-overview-guide.md`:**
   - Start with Core milestone (always)
   - Assess path clarity (can you see the giant steps?)
   - Define milestones based on strategic phases
   - Document milestone progression and rationale

## Output

Creates:
- `docs/[slug]-milestones-overview.md` - Strategic milestone roadmap (e.g., `docs/mc-milestones-overview.md`)

## Key Decisions

**Every project starts with a Core milestone** (core functionality)

**Clear path to north star**: Define multiple milestones upfront if you can see the strategic phases

**Unclear path**: Start with just Core milestone - expand as clarity emerges through execution

## After Completion

User will run `/verify-doc docs/[slug]-milestones-overview.md`, fix issues, then proceed to Stage 4 (Milestone Design).

**Next Stage**: Create detailed design for Core milestone, then proceed to PoC design for Core. Repeat for subsequent milestones as needed.
