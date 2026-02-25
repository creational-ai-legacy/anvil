---
description: "Expand a milestone into detailed design document (Stage 4 of design skill)"
argument-hint: "<milestone-slug>"
disable-model-invocation: true
---

# /design-milestone-spec

Expand a single milestone into comprehensive, self-contained design document.

## What This Does

Stage 4 of design skill: Create detailed design for one milestone with implementation perspective.

## Resources

**Read these for guidance**:
- `~/.claude/skills/design/SKILL.md` - See "Stage 4: Milestone Spec" section
- `~/.claude/skills/design/references/4-milestone-spec-guide.md` - Detailed process
- `~/.claude/skills/design/assets/templates/4-milestone-spec.md` - Output template

## Prerequisites

Must complete before running this command:
- [ ] Stage 3: Roadmap (`docs/[slug]-roadmap.md`)
- [ ] Stage 2: Architecture (`docs/[slug]-architecture.md`)

## Input

**First argument (required):**
- Milestone slug (e.g., "core", "cloud") → Reads milestone from `docs/[project-slug]-roadmap.md`

**Required docs (auto-read):**
- `docs/[project-slug]-roadmap.md` - Roadmap with high-level sections
- `docs/[project-slug]-architecture.md` - Architecture document

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Design first milestone
/design-milestone-spec "core"

# Later, design another milestone
/design-milestone-spec "cloud"
```

**Output naming:**
- Derives from milestone in `docs/[project-slug]-roadmap.md`
- Creates `docs/[milestone-slug]-milestone-spec.md`
- Example: `docs/core-milestone-spec.md`, `docs/cloud-milestone-spec.md`

## Key Requirements

⛔ **NO CODE** - This is design only (detailed architecture, components, phases)

## Process

Follow the guidance in `4-milestone-spec-guide.md`:
1. Select milestone from product roadmap
2. Write Executive Summary (2-3 paragraphs + key principle)
3. Expand Goal section (what it proves + what it doesn't)
4. Expand Architecture Overview (diagram, stack, cost)
5. Design Core Components (3-6 components with full detail)
6. Detail Implementation Phases
7. Expand Success Metrics
8. Define Testing Strategy
9. Add Key Outcomes
10. Document Design Decisions & Rationale
11. Identify Risks & Mitigation
12. Document Open Questions
13. Define Next Steps (three time horizons)

## Output

Creates:
- `docs/[slug]-milestone-spec.md` - Comprehensive milestone design

## Key Principles

**Self-Contained**: Focus ONLY on this milestone (no forward references to other milestones)

**Implementation Perspective**: Production-grade design, not prototypes

**Design-Focused**: Focus on WHAT and WHY, not rigid WHEN

## After Completion

User will run `/verify-doc docs/[slug]-milestone-spec.md`, fix issues, then proceed to Stage 5 (Task Spec).

**Next Stage**: Create task spec for this milestone, breaking it into atomic tasks.
