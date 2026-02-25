---
name: design
description: >
  Structured workflow for taking ideas from concept to executable task plan.
  Use when starting a new project, designing architecture, planning milestones,
  or creating task specs. Covers 5 stages - Vision (refine idea into
  vision), Architecture (technical design), Roadmap (strategic milestone
  breakdown), Milestone Spec (detailed per-milestone planning), Task Spec
  (atomic task definitions with dependencies). This is a NO-CODE skill focused
  on design and planning only.
---

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

**Philosophy**: design handles the **design phase** (0→1). Once you have a task plan, hand off to implementation.

## Stage Overview

| Stage | Output | Purpose |
|-------|--------|---------|
| 1. Vision | `[slug]-vision.md` | Vision & feasibility |
| 2. Architecture | `[slug]-architecture.md` | Technical design |
| 3. Roadmap | `[slug]-roadmap.md` | Strategic milestone breakdown |
| 4. Milestone Spec | `[slug]-milestone-spec.md` | Detailed per-milestone plan |
| 5. Task Spec | `[slug]-task-spec.md` | Atomic tasks with dependencies |

---

## ⛔ CRITICAL: TEMPLATE & OUTPUT RULES

**Output**: All outputs are **markdown artifacts** presented directly to the user. Do NOT write to filesystem.

**THIS IS NOT FREEFORM DOCUMENTATION.**

Templates are mandatory. They define the exact structure curated over months of iteration.

**For EVERY stage artifact:**
1. **READ the template FIRST** from `assets/templates/[name].md`
2. **FOLLOW the template structure EXACTLY** — every section, every heading, in order
3. **Fill in project-specific content** within that structure
4. **Present as a markdown artifact**

**DO NOT:** Skip template | Invent structure | Omit sections | Reorder sections | Add sections

---

## 🎯 Design Philosophy: 200 Users First

**This skill is for inception** — structuring ideas into well-defined milestones and tasks.

**Production-grade, but right-sized:**
- Build with production-quality from day one
- BUT size everything for your first 200 users
- Security, data modeling, HA — include them, but don't over-engineer
- Break 200 paying users → THEN dedicate a milestone to scale

**Why 200?** Enough to validate product-market fit. No users = scaling is a problem you don't have.

---

## ⛔ CRITICAL: NO-CODE SKILL

**All stages (1-5) are strictly NO-CODE zones.**

**Allowed**: Architecture diagrams, data flow descriptions, workflow descriptions, pseudocode (sparingly), API contracts, tech stack decisions

**NOT allowed**: Implementation code, function definitions, class implementations, copy-paste snippets

**If asked for code**: "We're in design stage — code comes during implementation. Let me describe how this would work at a high level..."

---

## Stage 1: Vision

**Goal**: Refine the idea into a clear, feasible vision

**Input**: Idea (verbal, notes, rough sketch)
**Template**: `assets/templates/1-vision.md`
**Output**: `[slug]-vision.md` artifact

→ See `references/1-vision-guide.md` for detailed process

---

## Stage 2: Architecture

**Goal**: Create technical architecture and integration plan

**Input**: Vision doc
**Template**: `assets/templates/2-architecture.md`
**Output**: `[slug]-architecture.md` artifact

→ See `references/2-architecture-guide.md` for detailed process

### 💡 Market Research Checkpoint (Optional)

Once you have enough context (typically after Stage 2 or 3), consider validating the market:

*"Do market research for this product. Do we have a play in this space? Is it worth pursuing?"*

Validate early. The more context you have, the better the research — but don't over-design before confirming market fit.

---

## Stage 3: Roadmap

**Goal**: Break Vision + Architecture into strategic milestones with clear progression

**Input**: Vision doc, Architecture doc
**Template**: `assets/templates/3-roadmap.md`
**Output**: `[slug]-roadmap.md` artifact

→ See `references/3-roadmap-guide.md` for detailed process

---

## Stage 4: Milestone Spec

**Goal**: Expand a single milestone into comprehensive, self-contained design document

**Input**: Roadmap, Architecture doc
**Template**: `assets/templates/4-milestone-spec.md`
**Output**: `[slug]-milestone-spec.md` artifact

→ See `references/4-milestone-spec-guide.md` for detailed process

---

## Stage 5: Task Spec

**Goal**: Define atomic tasks with dependencies and success criteria — PRODUCTION-GRADE thin slices

**Input**: Milestone Spec, Roadmap, Architecture doc
**Template**: `assets/templates/5-task-spec.md`
**Output**: `[slug]-task-spec.md` artifact

**Task Requirements** (critical):
- **Atomic**: Validates ONE specific thing
- **Measurable**: Clear success criteria
- **Self-contained**: Works independently, doesn't break existing functionality

**Golden Rule**: One capability = One task (minimize tasks; group related work)

→ See `references/5-task-spec-guide.md` for detailed process

---

## Handoff to Implementation

Once `[slug]-task-spec.md` is complete, you're ready to implement.

**Options**: Manual implementation | Claude Code dev | Other tools

design ends here. Implementation = plan tasks → execute → test → repeat.

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
