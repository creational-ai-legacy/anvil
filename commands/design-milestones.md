# /design-milestones

Create milestone roadmap breaking North Star into strategic phases.

## What This Does

Stage 4 of dev-design: Break North Star + Architecture into 1-3 milestones.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-design/SKILL.md` - See "Stage 4: Milestone Design" section
- `~/.claude/skills/dev-design/references/4-milestone-design-guide.md` - Detailed process
- `~/.claude/skills/dev-design/assets/templates/milestones.md` - Template

## Prerequisites

Must complete before running this command:
- [ ] Stage 1: North Star (`docs/north-star.md`)
- [ ] Stage 2: Architecture (`docs/[name]-architecture.md`)
- [ ] Optional: Stage 3: Research (if applicable)

## Input

**Required docs (auto-read):**
- `docs/north-star.md` - Vision and goals
- `docs/*-architecture.md` - All architecture documents
- Research findings (if any Stage 3 docs exist)

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Basic usage (reads all docs + user context)
/design-milestones

# With specific guidance
/design-milestones "Clear path: Core → Mobile → Enterprise"

# For unclear path
/design-milestones "Small project - just start with Core milestone"
```

## Process

1. **Read all prerequisite docs:**
   - Read `docs/north-star.md`
   - Read all `docs/*-architecture.md` files
   - Read any research findings (Stage 3 outputs)
   - Review user notes

2. **Follow the guidance in `4-milestone-design-guide.md`:**
   - Start with Milestone 1: Core (always)
   - Assess path clarity (can you see the giant steps?)
   - Define 1-3 milestones (Core + others if clear path visible)
   - Document milestone order (sequential: 1 → 2 → 3)

## Output

Creates:
- `docs/milestones.md` - Strategic milestone roadmap

## Key Decisions

**Every project starts with Milestone 1: Core** (core functionality)

**Clear path to north star**: Plan 2-3 milestones upfront if you can see the giant steps

**Unclear path**: Start with just 1 milestone (Core) - common with small/experimental projects

## After Completion

User will run `/verify-doc docs/milestones.md`, fix issues, then proceed to Stage 5 (PoC Design) starting with the first milestone.

**Next Stage**: `/design-poc-design` (run once per milestone, starting with Core)
