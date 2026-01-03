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

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Basic usage (reads from north-star.md and architecture docs)
/design-milestones

# With specific guidance
/design-milestones "Clear path: Core → Mobile → Enterprise"

# For unclear path
/design-milestones "Small project - just start with Core milestone"
```

## Process

Follow the guidance in `4-milestone-design-guide.md`:
1. Start with Milestone 1: Core (always)
2. Assess path clarity (can you see the giant steps?)
3. Define 1-3 milestones (Core + others if clear path visible)
4. Document milestone order and dependencies
5. Add organic growth notes

## Output

Creates:
- `docs/milestones.md` - Strategic milestone roadmap

## Key Decisions

**Every project starts with Milestone 1: Core** (core functionality)

**Clear path to north star**: Plan 2-3 milestones upfront if you can see the giant steps

**Unclear path**: Start with just 1 milestone (Core) - common with small/experimental projects

**Milestones grow organically**: Add more as the path becomes clearer

## After Completion

User will run `/verify-doc docs/milestones.md`, fix issues, then proceed to Stage 5 (PoC Design) starting with the first milestone.

**Next Stage**: `/design-poc-design` (run once per milestone, starting with Core)
