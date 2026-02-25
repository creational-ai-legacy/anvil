# dev

A structured 3-stage workflow for implementing tasks with production-grade quality.

## Hierarchy

```
Project (e.g., "mission-control")
├── Milestone (grouping layer, e.g., "core", "cloud")
│   ├── Task (e.g., "poc-1", "auth-feature", "fix-bug-42")
│   └── Task ...
└── Milestone (e.g., "integrations")
    └── Task ...
```

**Task Types:**
- **PoC** - Proof of Concept (validate technical approach)
- **Feature** - New functionality
- **Issue** - Bug fix
- **Refactor** - Code improvement

## Overview

This skill operates at the **Task level** - one task at a time through a 3-stage workflow:

1. **Stage 1: Design** - Problem analysis and solution design (what and why)
2. **Stage 2: Planning** - Step-by-step breakdown
3. **Stage 3: Execution** - Actual implementation with tests

## Quick Reference

| Stage | Input | Output | Code? |
|-------|-------|--------|-------|
| 1. Design | Bug/feature spec, user notes | `*-design.md` | ❌ NO |
| 2. Planning | `*-design.md` (recommended) | `*-plan.md` | ✅ YES |
| 3. Execution | `*-plan.md` | `*-results.md` + code + tests | ✅ YES |

| Stage | Guide | Template |
|-------|-------|----------|
| 1. Design | `references/1-design-guide.md` | `assets/templates/1-design.md` |
| 2. Planning | `references/2-planning-guide.md` | `assets/templates/2-plan.md` |
| 3a. Execution | `references/3-execution-guide.md` | `assets/templates/3-results.md` |
| 3b. Review | `references/review-guide.md` | (writes to results template) |

| Environment | Guide |
|-------------|-------|
| Python | `references/python-guide.md` |
| Unity | `references/unity-guide.md` |

| Utility | Template | Output |
|---------|----------|--------|
| `/dev-diagram <slug>` | `assets/templates/diagram.md` | Inserts ASCII box into results doc |

## Optional Commands

Users can invoke stages explicitly via commands:
- `/dev-design <notes>` - Start Stage 1
- `/dev-plan <notes>` - Start Stage 2
- `/dev-execute <notes>` - Start Stage 3 (one step)
- `/dev-execute-run <plan>` - Run all steps to completion (auto-finalize)
- `/dev-review <results-doc> <step>` - Review completed step against design
- `/dev-review-run <results-doc>` - Review all completed steps in parallel
- `/dev-finalize <slug>` - Finalize task (timestamp, lessons, diagram, health check)
- `/dev-health` - Project health check
- `/dev-diagram <slug>` - Generate ASCII diagram for task
- `/verify-doc <path>` - Verify design or plan document
- `/milestone-details <slug>` - Generate milestone summary

**Agent commands** (run in background via subagents):
- `/agent-dev-design <notes>` - Design agent for Stage 1
- `/agent-dev-plan <design-doc>` - Plan agent for Stage 2
- `/agent-dev-execute <plan>` - Execute agent for Stage 3
- `/agent-dev-review <results-doc> <step>` - Review agent for conceptual review
- `/agent-dev-finalize <slug>` - Finalize agent (timestamp + lessons + diagram + health)
- `/agent-milestone-details <slug>` - Milestone details agent
- `/agent-verify-doc <path>` - Document verification agent

Or use natural language: "Create design for database abstraction", "Plan the implementation", "Execute step 1"

---

## Stage 1: Design

**Goal**: Analyze problems and design solutions before implementation planning.

**Code Allowed**: ❌ NO full implementations. YES to conceptual patterns, signatures, diagrams.

⚠️ **Stage 1 is strictly a NO-CODE zone.** See guide for what is/isn't allowed.

**Guide**: `references/1-design-guide.md` | **Template**: `assets/templates/1-design.md`

**Output**: `docs/[milestone-slug]-[task-slug]-design.md`

**Structure**: Part A (Analysis — each item independently) + Part B (Proposed Sequence — #1 → #2 → #3)

**After completion**: User reviews, runs `/verify-doc`, then requests Stage 2.

---

## Stage 2: Planning

**Goal**: Break down a single task into bite-sized, production-grade implementation steps.

**Code Allowed**: ✅ YES — Step 0/Prerequisites: concrete commands. Steps 1+: spec-driven (behavior, acceptance criteria, no code blocks).

**Guide**: `references/2-planning-guide.md` | **Template**: `assets/templates/2-plan.md`

**Input**: `docs/[milestone-slug]-[task-slug]-design.md` (recommended) | **Output**: `docs/[milestone-slug]-[task-slug]-plan.md`

**Key rules**: Production-grade (OOP, validated models, typing). Self-contained (add alongside, don't replace). Each step includes its tests.

**After completion**: User reviews, runs `/verify-doc`, then requests Stage 3.

---

## Stage 3: Execution

**Goal**: Implement the current task one step at a time.

**Code Allowed**: ✅ YES — Full implementation.

**Guide**: `references/3-execution-guide.md` | **Template**: `assets/templates/3-results.md`

**Input**: `docs/[milestone-slug]-[task-slug]-plan.md` | **Output**: `docs/[milestone-slug]-[task-slug]-results.md` + code + tests

**Key rules**:
- ⚠️ ONE STEP THEN STOP — execute only current step, do not continue automatically
- ⚠️ LOOP UNTIL TESTS PASS — if tests fail, fix and re-test
- 📝 DOCUMENT AND STOP — when tests pass, update results doc and stop

**Review gate** (opt-in): Run `/dev-review-run` separately after execution to review all completed steps in parallel. See `references/review-guide.md`.

**After all steps**: Run `/dev-finalize` to record timestamp, consolidate lessons, generate diagram, and run health check.

---

## State Detection

The skill should detect where the user is in the workflow:

1. **No docs exist**: Start with Stage 1 (Design)
2. **Only design exists**: Move to Stage 2 (Planning)
3. **Plan exists**: Move to Stage 3 (Execution)
4. **Results doc shows progress**: Continue Stage 3 from current step

Use Glob/Grep to check for existing documents:
- `docs/[milestone-slug]-[task-slug]-design.md`
- `docs/[milestone-slug]-[task-slug]-plan.md`
- `docs/[milestone-slug]-[task-slug]-results.md`

---

## Best Practices

1. **Execute, review, auto-fix** — Execute step → review → if flagged: up to 2 fix→re-review cycles → if still flagged: stop for human. Most steps pass on first try.
2. **User always verifies** — Complete stage → user runs `/verify-doc` → user requests next stage.
3. **Documentation stays clean** — Implementation docs evergreen (no status). Results docs track progress.
4. **Tests are mandatory** — Every step requires passing tests before moving on.
5. **Self-contained is non-negotiable** — Add alongside, don't replace. System works at every task boundary.

---

## File Naming Conventions

**Project Tracking** (created once, updated throughout):
- `PROJECT_STATE.md` - Milestone progress, key decisions, system status, latest health check
- Template: `~/.claude/skills/dev/assets/templates/PROJECT_STATE.md`
- Keep it concise - remove resolved questions, keep only latest health check

**Per Task**:
- `docs/[milestone-slug]-[task-slug]-design.md` - e.g., `core-poc6-design.md`, `cloud-auth-fix-design.md`
- `docs/[milestone-slug]-[task-slug]-plan.md` - e.g., `core-poc6-plan.md`, `cloud-auth-fix-plan.md`
- `docs/[milestone-slug]-[task-slug]-results.md` - e.g., `core-poc6-results.md`

**Test Files**:
- Follow environment conventions (e.g., Python: `tests/test_[task-slug]_*.py`)

**Where**:
- `[milestone-slug]` is the milestone name (e.g., `core`, `cloud`, `mobile`)
- `[task-slug]` is the task name (e.g., `poc6`, `auth-fix`, `database-abstraction`)
- Both are lowercase with hyphens

---

## Integration with design skill

**Standalone**: Use dev for any development work (features, bugs, refactoring).

**With design skill**: The design skill creates the plan (`docs/[slug]-task-spec.md`), then dev implements it (Stage 1 → Stage 2 → Stage 3, repeat for each task).
