# dev-design

Structured workflow for taking ideas from concept to executable PoC plan.

**Philosophy**: dev-design handles the **design phase** (0 to 1). Once you have a PoC plan, hand off to the **dev-cycle skill** for the **development loop** (1 to N).

## Stage Overview

| Stage | Output | Environment |
|-------|--------|-------------|
| 1. North Star | `docs/north-star.md` | Claude Desktop |
| 2. Architecture | `docs/[name]-architecture.md` | Claude Desktop |
| 3. Research | Market analysis, validation | Claude Desktop |
| 4. Milestone Design | `docs/milestones.md` | Claude Code |
| 5. PoC Design | `docs/[milestone-name]-poc-design.md` | Claude Code |

**Environment Split**:
- **Claude Desktop** (Stages 1-3): Free-form exploration and research
- **Claude Code** (Stages 4-5): Template-driven structured design

**File Naming**:
- `[name]`: For architecture docs (can be anything - project name, feature name, module name)
- `[milestone-name]`: For PoC design docs (comes from milestone names in `docs/milestones.md`)

**Next**: → Hand off to `dev-cycle` skill for implementation

---

## ⛔ CRITICAL: NO-CODE SKILL

**All stages (1-5) are strictly NO-CODE zones.**

### What IS allowed:
- High-level architecture diagrams
- Data flow descriptions
- Workflow descriptions
- Concept explanations
- Pseudocode for complex logic (sparingly)
- API contract descriptions (endpoints, payloads)
- Technology stack decisions with rationale

### What is NOT allowed:
- Python/JavaScript/any implementation code
- Function definitions
- Class implementations
- Code snippets that could be copy-pasted
- "Here's how you'd implement this..." with actual code

### Why This Matters:
- Preserves token space for what matters: thinking and design
- Prevents premature implementation decisions
- Forces clear conceptual understanding before coding

### If Asked to Write Code:
Respond: "We're in the [North Star/Architecture/Research/Milestone Design/PoC Design] stage — let's keep focus on [vision/architecture/validation/milestones/design]. Code comes later in the dev-cycle skill. For now, let me describe how this would work at a high level..."

---

## Stage 1: North Star

**Goal**: Refine the idea into a clear, feasible vision

**Input**: Idea (verbal, notes, rough sketch)

**Template**: `assets/templates/north-star.md`

**Process**:
1. Understand the core problem being solved
2. Define how it would work (high-level)
3. Identify key components and their relationships
4. Surface assumptions and unknowns

**Output**: `docs/north-star.md`

### Stage 1 Complete Checklist
- [ ] `docs/north-star.md` created using template
- [ ] Problem clearly stated
- [ ] Solution approach makes sense
- [ ] Technical feasibility seems reasonable
- [ ] No obvious blockers identified

**Next**: → Stage 2: Architecture

---

## Stage 2: Architecture

**Goal**: Create technical architecture and integration plan

**Input**: North Star doc (`docs/north-star.md`)

**Template**: `assets/templates/architecture.md`

**Naming**: `docs/[name]-architecture.md` where `[name]` is your project/feature/module name

**Process**:
1. Define system architecture
2. Identify technology stack
3. Map data flows
4. Design component interactions
5. Identify integration points

**Output**: `docs/[name]-architecture.md`

### Stage 2 Complete Checklist
- [ ] `docs/[name]-architecture.md` created using template
- [ ] Architecture diagram complete
- [ ] Tech stack justified
- [ ] Data flows documented
- [ ] Integration points identified
- [ ] No code written (only diagrams and descriptions)
- [ ] Run `/verify-doc docs/[name]-architecture.md`

**Next**: → Stage 3: Research

---

## Stage 3: Research

**Goal**: Validate market fit and competitive landscape

**Input**: North Star doc (`docs/north-star.md`) and Architecture doc (`docs/[name]-architecture.md`)

**Process**:
1. Research competitors
2. Identify market gaps
3. Validate pricing assumptions
4. Assess technical differentiation
5. Multiple research passes to fine-tune

**Output**: Updates to `docs/north-star.md` and `docs/[name]-architecture.md`, market analysis

### Fast-Track Option

If research already exists (from prior sessions, reference docs, or external sources):
1. Review existing research docs for coverage
2. Verify all checklist items are addressed
3. Note source: "Research validated via [reference docs]"
4. Proceed to Stage 4

### Stage 3 Complete Checklist
- [ ] Competitors identified with strengths/weaknesses
- [ ] Market gap clearly articulated
- [ ] Differentiation strategy defined
- [ ] Pricing validated against market (if applicable)
- [ ] Go/no-go decision supported by evidence

**Next**: → Stage 4: Milestone Design

---

## Stage 4: Milestone Design

**Goal**: Break North Star + Architecture into strategic milestones with clear progression, detailed architecture per milestone, and measurable outcomes

**Input**:
- North Star doc (`docs/north-star.md`)
- Architecture docs (`docs/[name]-architecture.md`)

**Template**: `assets/templates/milestones.md`

**Output**: `docs/milestones.md`

**Process**:
1. Create Milestone Progression diagram (visual roadmap)
2. Define Milestone 1: Core with full detail (Goal, Architecture, What Gets Built, Metrics, Outcomes, Why)
3. Assess path clarity (can you see the giant steps?)
4. Design milestone progression (each should build, validate, progress)
5. Define additional milestones (if clear path visible)
6. Add Strategic Decisions section (explain milestone order rationale)
7. Document Success Criteria (per milestone + long-term)
8. Add Next Steps

**Key Principles**:
- **Every project starts with Milestone 1: Core** (core functionality)
- **Clear path to north star**: Plan multiple milestones upfront if you can see the giant steps
- **Unclear path**: Start with just Core - add milestones as clarity emerges through execution
- **Each milestone should**: Build on previous learnings, validate a capability, progress toward north star
- **Design-focused, not timeline-focused**: Focus on WHAT gets built and WHY, not rigid WHEN
- **Visual-first**: Diagrams communicate strategy faster than text

**Per-Milestone Sections**:
- **Goal**: 2-3 sentences on what this achieves and why
- **Architecture Diagram**: Visual specific to this milestone
- **What Gets Built**: Phases with specific deliverables
- **Success Metrics**: Measurable outcomes grouped by category
- **Key Outcomes**: Checkbox list of what this proves
- **Why [This Order]?**: Strategic rationale

### Stage 4 Complete Checklist
- [ ] `docs/milestones.md` created using template
- [ ] Milestone Progression diagram shows overall strategy
- [ ] Milestone 1: Core fully defined with all sections
- [ ] Each milestone has Goal, Architecture, What Gets Built, Metrics, Outcomes, Why
- [ ] Strategic Decisions section explains milestone order
- [ ] Success Criteria defined for each milestone
- [ ] Next Steps clear
- [ ] Run `/verify-doc docs/milestones.md`

**Next**: → Stage 5: PoC Design (run once per milestone, starting with Core)

---

## Stage 5: PoC Design

**Goal**: Define what needs to be proven and in what order — with PRODUCTION-GRADE thin slices

**Input**:
- Milestone definition from `docs/milestones.md`
- Validated architecture doc (`docs/[name]-architecture.md`)

**Template**: `assets/templates/poc-design.md`

**Naming**: `docs/[milestone-name]-poc-design.md` where `[milestone-name]` comes from your milestone in `docs/milestones.md`

**Examples**: `docs/core-poc-design.md`, `docs/cloud-deployment-poc-design.md`

**Process**:
1. Refine architecture with implementation perspective
2. Identify atomic things to prove (PoCs)
3. Map dependencies between PoCs
4. Create PoC diagram
5. Define success criteria for each PoC

**PoC Requirements**:

Each PoC must be:
- **Atomic**: Proves one specific thing (one capability/assumption, NOT one task - may include multiple related tasks)
- **Measurable**: Clear success criteria
- **🔒 Self-contained**: Works independently; doesn't break existing functionality and existing tests

**Golden Rule**: One feature = One PoC (minimize the number of PoCs; group related work)

**Output**: `docs/[milestone-name]-poc-design.md`

### Stage 5 Complete Checklist
- [ ] `docs/[milestone-name]-poc-design.md` created using template
- [ ] Each PoC proves one specific thing
- [ ] Dependencies mapped (which PoCs unlock others)
- [ ] Success criteria measurable
- [ ] Order of execution clear
- [ ] Run `/verify-doc docs/[milestone-name]-poc-design.md`

**Next**: → Hand off to **dev-cycle skill** for implementation

---

## Next: Hand Off to dev-cycle

Once you have `docs/[milestone-name]-poc-design.md` completed, hand off to the **dev-cycle** skill for implementation.

**dev-cycle** handles all development work through a repeating cycle: plan work items → execute step-by-step → test → repeat.

---

## Reference Guides

For detailed guidance on each stage:
- `references/1-north-star-guide.md` - Stage 1 process
- `references/2-architecture-guide.md` - Stage 2 process
- `references/3-research-guide.md` - Stage 3 process
- `references/4-milestone-design-guide.md` - Stage 4 process
- `references/5-poc-design-guide.md` - Stage 5 process
