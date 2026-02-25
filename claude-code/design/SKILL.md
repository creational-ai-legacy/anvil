# design

Structured workflow for taking ideas from concept to executable task plan.

**Version**: 2.0.0

## Hierarchy

```
Project (e.g., "mission-control")
├── Milestone (grouping layer, e.g., "core", "cloud")
│   ├── Task (e.g., "poc-1", "auth-feature", "fix-bug-42")
│   └── Task ...
└── Milestone (e.g., "integrations")
    └── Task ...
```

**Task Types**: PoC (validate approach) | Feature | Issue | Refactor

**Philosophy**: design handles the **design phase** (0 to 1). Once you have a task plan, hand off to the **dev skill** for the **development loop** (1 to N).

## Stage Overview

| Stage | Output | Purpose |
|-------|--------|---------|
| 1. Vision | `docs/[slug]-vision.md` | Vision & feasibility |
| 2. Architecture | `docs/[slug]-architecture.md` | Technical design |
| 3. Roadmap | `docs/[slug]-roadmap.md` | Strategic milestone breakdown |
| 4. Milestone Spec | `docs/[slug]-milestone-spec.md` | Detailed per-milestone plan |
| 5. Task Spec | `docs/[slug]-task-spec.md` | Atomic tasks with dependencies |

**File Naming**:
- `[slug]`: Project slug for project-level docs (vision, architecture, roadmap)
- `[slug]`: Milestone slug for milestone-level docs (milestone-spec, task-spec)

**Next**: Hand off to **dev skill** for implementation

## Commands

- `/design-vision` - Create or refine Vision document (Stage 1)
- `/design-architecture` - Create architecture and integration plan (Stage 2)
- `/design-roadmap` - Create roadmap with strategic milestones (Stage 3)
- `/design-milestone-spec` - Expand a milestone into detailed design (Stage 4)
- `/design-task-spec` - Define atomic tasks with dependencies and success criteria (Stage 5)

---

## CRITICAL: TEMPLATE & OUTPUT RULES

**THIS IS NOT FREEFORM DOCUMENTATION.**

Templates are mandatory. They define the exact structure curated over months of iteration.

**For EVERY stage output:**
1. **READ the template FIRST** from `assets/templates/[name].md`
2. **FOLLOW the template structure EXACTLY** -- every section, every heading, in order
3. **Fill in project-specific content** within that structure
4. **Write to `docs/` directory** using the naming convention for that stage

**DO NOT:** Skip template | Invent structure | Omit sections | Reorder sections | Add sections

---

## Design Philosophy: 200 Users First

**This skill is for inception** -- structuring ideas into well-defined milestones and tasks.

**Production-grade, but right-sized:**
- Build with production-quality from day one
- BUT size everything for your first 200 users
- Security, data modeling, HA -- include them, but don't over-engineer
- Break 200 paying users, THEN dedicate a milestone to scale

**Why 200?** Enough to validate product-market fit. No users = scaling is a problem you don't have.

---

## CRITICAL: NO-CODE SKILL

**All stages (1-5) are strictly NO-CODE zones.**

**Allowed**: Architecture diagrams, data flow descriptions, workflow descriptions, pseudocode (sparingly), API contracts, tech stack decisions

**NOT allowed**: Implementation code, function definitions, class implementations, copy-paste snippets

**If asked for code**: "We're in design stage -- code comes later in the dev skill. Let me describe how this would work at a high level..."

---

## Stage 1: Vision

**Goal**: Refine the idea into a clear, feasible vision

**Input**: Idea (verbal, notes, rough sketch)
**Template**: `assets/templates/1-vision.md`
**Output**: `docs/[slug]-vision.md` (e.g., `docs/mc-vision.md`)

> See `references/1-vision-guide.md` for detailed process

### Stage 1 Complete Checklist
- [ ] `docs/[slug]-vision.md` created using template
- [ ] Problem clearly stated
- [ ] Solution approach makes sense
- [ ] Technical feasibility seems reasonable
- [ ] No obvious blockers identified

**Next**: Stage 2: Architecture

---

## Stage 2: Architecture

**Goal**: Create technical architecture and integration plan

**Input**: Vision doc (`docs/[slug]-vision.md`)
**Template**: `assets/templates/2-architecture.md`
**Output**: `docs/[slug]-architecture.md` (e.g., `docs/mc-architecture.md`)

> See `references/2-architecture-guide.md` for detailed process

### Market Research Checkpoint (Optional)

Once you have enough context (typically after Stage 2 or 3), consider validating the market:

*"Do market research for this product. Do we have a play in this space? Is it worth pursuing?"*

Validate early. The more context you have, the better the research -- but don't over-design before confirming market fit.

### Stage 2 Complete Checklist
- [ ] `docs/[slug]-architecture.md` created using template
- [ ] Architecture diagram complete
- [ ] Tech stack justified
- [ ] Data flows documented
- [ ] Integration points identified
- [ ] No code written (only diagrams and descriptions)
- [ ] Run `/verify-doc docs/[slug]-architecture.md`

**Next**: Stage 3: Roadmap

---

## Stage 3: Roadmap

**Goal**: Break Vision + Architecture into strategic milestones with clear progression

**Input**:
- Vision doc (`docs/[slug]-vision.md`)
- Architecture doc (`docs/[slug]-architecture.md`)

**Template**: `assets/templates/3-roadmap.md`
**Output**: `docs/[slug]-roadmap.md` (e.g., `docs/mc-roadmap.md`)

> See `references/3-roadmap-guide.md` for detailed process

### Stage 3 Complete Checklist
- [ ] `docs/[slug]-roadmap.md` created using template
- [ ] Milestone Progression diagram shows overall strategy
- [ ] First milestone (Core) fully defined with all sections
- [ ] Each milestone has Goal, Architecture, What Gets Built, Metrics, Outcomes, Why
- [ ] Strategic Decisions section explains milestone order
- [ ] Success Criteria defined for each milestone
- [ ] Next Steps clear
- [ ] Run `/verify-doc docs/[slug]-roadmap.md`

**Next**: Stage 4: Milestone Spec (detailed design per milestone)

---

## Stage 4: Milestone Spec

**Goal**: Expand a single milestone into comprehensive, self-contained design document

**Input**:
- Roadmap (`docs/[slug]-roadmap.md`)
- Architecture doc (`docs/[slug]-architecture.md`)

**Template**: `assets/templates/4-milestone-spec.md`
**Output**: `docs/[slug]-milestone-spec.md` (e.g., `docs/web-core-milestone-spec.md`)

> See `references/4-milestone-spec-guide.md` for detailed process

### Stage 4 Complete Checklist
- [ ] `docs/[slug]-milestone-spec.md` created using template
- [ ] Executive Summary provides clear context
- [ ] Goal section includes what it proves AND what it doesn't
- [ ] Architecture has all three subsections (Diagram, Stack, Cost)
- [ ] Core Components (3-6) each have all subsections
- [ ] Implementation Phases expanded from overview with details
- [ ] Testing Strategy defines approach and priorities
- [ ] Success Metrics have measurement details and rationale
- [ ] Design Decisions explain why this approach
- [ ] Risks identified with mitigation strategies
- [ ] Open Questions grouped by category
- [ ] Next Steps have three time horizons
- [ ] NO forward references to other milestones
- [ ] Run `/verify-doc docs/[slug]-milestone-spec.md`

**Next**: Stage 5: Task Spec (break milestone into atomic tasks)

---

## Stage 5: Task Spec

**Goal**: Define atomic tasks with dependencies and success criteria -- PRODUCTION-GRADE thin slices

**Input**:
- Milestone Spec (`docs/[slug]-milestone-spec.md`)
- Roadmap (`docs/[slug]-roadmap.md`)
- Architecture doc (`docs/[slug]-architecture.md`)

**Template**: `assets/templates/5-task-spec.md`
**Output**: `docs/[slug]-task-spec.md` (e.g., `docs/core-task-spec.md`)

**Task Requirements** (critical):
- **Atomic**: Validates ONE specific thing
- **Measurable**: Clear success criteria
- **Self-contained**: Works independently, doesn't break existing functionality

**Golden Rule**: One capability = One task (minimize tasks; group related work)

> See `references/5-task-spec-guide.md` for detailed process

### Stage 5 Complete Checklist
- [ ] `docs/[slug]-task-spec.md` created using template
- [ ] Each task validates one specific thing
- [ ] Dependencies mapped (which tasks unlock others)
- [ ] Success criteria measurable
- [ ] Order of execution clear
- [ ] Run `/verify-doc docs/[slug]-task-spec.md`

**Next**: Hand off to **dev skill** for implementation

---

## Handoff to dev

Once `docs/[slug]-task-spec.md` is complete, hand off to the **dev skill** for implementation.

**dev** handles all development work through a repeating cycle: plan tasks, execute step-by-step, test, repeat.

---

## Reference Guides

Read when you need detailed process, examples, or edge case handling.

| When to Read | Reference File |
|--------------|----------------|
| Starting Stage 1 or refining vision | `references/1-vision-guide.md` |
| Starting Stage 2 or designing architecture | `references/2-architecture-guide.md` |
| Starting Stage 3 or breaking into milestones | `references/3-roadmap-guide.md` |
| Starting Stage 4 or expanding a milestone | `references/4-milestone-spec-guide.md` |
| Starting Stage 5 or defining tasks | `references/5-task-spec-guide.md` |
