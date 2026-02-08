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

| Utility | Template | Output |
|---------|----------|--------|
| `/dev-diagram <slug>` | `assets/templates/diagram.md` | Inserts ASCII box into results doc |
| `/dev-lessons <slug>` | `assets/templates/lessons-learned.md` | Consolidates lessons from results |

## Optional Commands

Users can invoke stages explicitly via commands:
- `/dev-design <notes>` - Start Stage 1
- `/dev-plan <notes>` - Start Stage 2
- `/dev-execute <notes>` - Start Stage 3 (one step)
- `/dev-execute-run <plan>` - Run all steps to completion (auto-finalize, with review gate)
- `/dev-review <results-doc> <step>` - Review completed step against design
- `/dev-diagram <slug>` - Generate ASCII diagram for task
- `/dev-lessons <slug>` - Consolidate lessons learned

Or use natural language: "Create design for database abstraction", "Plan the implementation", "Execute step 1"

---

## ⛔ CRITICAL: NO-CODE STAGE (Stage 1)

**Stage 1 (Design) is strictly a NO-CODE zone.**

### What IS allowed in Stage 1:
- High-level architecture diagrams
- Data flow descriptions
- Workflow descriptions
- Concept explanations
- Pseudocode for complex logic (sparingly)
- API contract descriptions (endpoints, payloads)
- Technology stack decisions with rationale
- Current vs target code comparisons (showing what exists vs what should exist)

### What is NOT allowed in Stage 1:
- Python/JavaScript/any implementation code
- Function definitions for new features
- Class implementations for new features
- Code snippets that could be copy-pasted
- "Here's how you'd implement this..." with actual new code

---

## Stage 1: Design

**Goal**: Analyze problems and design solutions before implementation planning.

**Code Allowed**: NO full implementations. YES to conceptual patterns, signatures, diagrams.

### When to Use

Run Stage 1 when:
- Starting a new feature
- Planning how to fix a complex bug
- Breaking down a milestone into PoCs
- User explicitly requests a design

### Two-Section Structure

**Part A: Analysis** (Non-Sequential) — Each item independently: What → Why → Approach (patterns, files, diagrams, validation). No implied order. Conceptual code OK, not full implementations.

**Part B: Proposed Sequence** — Recommended order using #1 → #2 → #3 notation. Each with Depends On + Rationale. NOT "Steps" (that's Planning stage).

### Process

See `references/1-design-guide.md` for detailed guidance on:
- Document current vs target state
- Identify and analyze each item independently
- Propose solution approach for each item
- Define proposed sequence with rationale
- Document design decisions
- Update PoC plan (if applicable)

### Output

Create using `assets/templates/1-design.md`:

**File**: `docs/[milestone-slug]-[task-slug]-design.md`

**Examples**:
- `core-poc6-design.md` (PoC 6 in Core milestone)
- `core-database-abstraction-design.md` (feature in Core milestone)
- `cloud-fix-auth-bug-design.md` (bug fix in Cloud milestone)

**Contents**:
- Executive summary (challenge + solution one-liners)
- Context (current state, target state)
- Analysis (non-sequential, each item independently)
- Proposed Sequence (item order with rationale)
- Success criteria
- Risks and mitigations
- Decisions log

### Stage 1 Complete Checklist

- [ ] Design document created with all sections
- [ ] Current and target state clearly defined
- [ ] Each item analyzed with What/Why/Approach
- [ ] Proposed sequence defined (#1 → #2 → ...)
- [ ] Sequence rationale explains dependencies
- [ ] 🔒 **Task is self-contained** (works independently; doesn't break existing functionality/tests)
- [ ] Risks identified with mitigations
- [ ] Design decisions documented
- [ ] `docs/[slug]-poc-spec.md` updated (if applicable)
- [ ] No full code implementations (concepts and patterns OK)
- [ ] Run `/verify-doc docs/[milestone-slug]-[task-slug]-design.md`

### Next Stage

→ **Stage 2: Planning** (use `references/2-planning-guide.md`)

User should review design, run `/verify-doc`, fix issues, then request Stage 2.

---

## Stage 2: Planning

**Input**: `docs/[milestone-slug]-[task-slug]-design.md` from Stage 1 (recommended)
**Output**: `docs/[milestone-slug]-[task-slug]-plan.md`

**Goal**: Break down a single task into bite-sized, production-grade implementation steps.

**Code Allowed**: YES - Code snippets, configs, examples

### When to Use

Run Stage 2 when:
- Design is complete and verified
- Ready to plan implementation for next task
- User explicitly requests implementation plan

✅ **CODE IS ALLOWED** - Unlike Stage 1, use concrete code snippets, commands, and configs

⚠️ **PRODUCTION-GRADE THIN SLICES** - Real integrations, not mocks; patterns that scale

🏗️ **QUALITY OOP CODE** - Use classes with clear responsibilities, validated data models, strong typing everywhere

🔒 **SELF-CONTAINED** - Each task must be complete and functional on its own; doesn't break existing functionality and existing tests

### Process

See `references/2-planning-guide.md` for detailed guidance on:
- List prerequisites
- Break into bite-sized steps (small, completable, testable)
- Define verification for each step
- Include specific code snippets
- Identify production-grade requirements (OOP, data models, typing) per environment guide
- Ensure self-contained (add alongside, don't replace)

### Output

Create using templates:

**Output**: `docs/[milestone-slug]-[task-slug]-plan.md` (from `assets/templates/2-plan.md`)
- Prerequisites with setup instructions
- Step-by-step implementation guide
- Code snippets, commands, configs
- Verification commands
- **NO status indicators** (evergreen guide)

**Note**: The results tracking document (`docs/[milestone-slug]-[task-slug]-results.md`) will be created later during Stage 3 (Execution).

### Stage 2 Complete Checklist

- [ ] Plan doc created (`docs/[milestone-slug]-[task-slug]-plan.md`)
- [ ] Prerequisites explicitly listed with setup instructions
- [ ] Each step is bite-sized and independently verifiable
- [ ] Each step has clear verification criteria with commands
- [ ] Code snippets are specific and complete
- [ ] 🏗️ **OOP + Validated data models + Type safety enforced** (per environment guide)
- [ ] ⚠️ **No mock data where real data needed**
- [ ] 🔒 **Work is self-contained** (add alongside, don't replace; works independently)
- [ ] Run `/verify-doc docs/[milestone-slug]-[task-slug]-plan.md`

### Next Stage

→ **Stage 3: Execution** (use `references/3-execution-guide.md`)

User should review plan, run `/verify-doc`, fix issues, then request Stage 3.

---

## Stage 3: Execution

**Goal**: Implement the current task one step at a time.

**Code Allowed**: YES - Full implementation

### When to Use

Run Stage 3 when:
- Implementation plan is complete and verified
- Ready to start coding
- User explicitly requests execution

⚠️ **ONE STEP THEN STOP** - Execute ONLY current step, DO NOT continue automatically

⚠️ **LOOP UNTIL TESTS PASS** - If tests fail, fix and re-test until ALL pass

📝 **DOCUMENT AND STOP** - When tests pass, update docs and STOP - wait for user

---

**First time setup**: If results doc doesn't exist, create it from template. **Record Started timestamp** (ISO 8601 with timezone, e.g., `2024-01-08T22:45:00-08:00`).

Execute the implementation plan:
- Execute ONLY the current step (DO NOT do multiple steps)
- Each step is bite-sized (small, completable, testable)
- Steps can break into sub-steps: 3a, 3b, 3c
- Loop: implement → test → if fail, fix → re-test (repeat until pass)
- When tests pass → update results doc → STOP
- Keep implementation doc clean (no status updates)

**After all steps complete**: Ask user "Mark task as complete?" → If confirmed, record **Completed timestamp**, update Status to ✅ Complete, then run `/dev-lessons` to consolidate lessons.

### Review Gate (after each execution step)

After each step's tests pass, a review agent examines the output:
- Compares implementation against design doc intent
- Cross-references the Trade-offs & Decisions section
- Checks for conceptual errors at depth matching the Risk Profile
- Reports PASS or FLAG

If flagged, the orchestrator sends findings back to a fresh executor for one fix attempt. If re-review still flags, it stops for human intervention. Most steps pass review on first try — the fix loop is the exception, not the norm.

Review runs automatically in `/dev-execute-run`. Can also run standalone via `/dev-review [results-doc] [step-number]`.

### Process

See `references/3-execution-guide.md` for detailed per-step workflow:
1. Implement code for current step
2. Write tests
3. Run test verification
4. **IF FAIL**: Fix and return to step 3 (loop until pass)
5. **IF PASS**: Document in results.md and STOP

**⚠️ Critical Rules:**
- Execute ONLY ONE step, then STOP and report to user
- Loop until ALL tests pass for current step

### Implementation Guidelines

- **OOP Design**: Classes with single responsibility, clear interfaces
- **Validated Data Models**: All data structures use validated models (no raw untyped containers)
- **Strong Typing**: Type annotations on all functions, methods, attributes
- **Production-grade**: Real data, real integrations, error handling
- **Clear docstrings**: With usage examples
- **Self-contained**: Add alongside, don't replace
- **Environment guide**: Follow the project's environment guide for tooling specifics

### Test Guidelines

- Cover critical paths
- Test edge cases
- Verify outputs match expectations
- Use descriptive test names
- Arrange-Act-Assert pattern

### Documentation Guidelines

- Update `docs/[milestone-slug]-[task-slug]-results.md` after EACH step
- Include: step status, test results, issues, bug fixes
- **Add "Lessons Learned"** for each step (insights, patterns, gotchas)
- Keep implementation doc clean (no status updates there)

### Output

**Per step**:
- Implementation code files (in appropriate modules)
- Test files (per environment conventions)
- Updated `docs/[milestone-slug]-[task-slug]-results.md`

**When work complete**:
- All implementation and test files complete
- `docs/[milestone-slug]-[task-slug]-results.md` with final status

### Stage 3 Verification Checklist

**After each step**:
- [ ] Implementation code works as expected
- [ ] ⚠️ **Tests pass** (run test suite per environment guide)
- [ ] `docs/[milestone-slug]-[task-slug]-results.md` updated with step progress and **lessons learned**

**After all steps (work complete)**:
- [ ] All tests pass (new + existing)
- [ ] `docs/[milestone-slug]-[task-slug]-results.md` shows all success criteria met
- [ ] Production-grade checklist verified

### Next Stage

→ **Return to Stage 2** for next task (after task complete)

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

1. **Execute, review, auto-fix** — Execute step → review → if flagged: one fix attempt → re-review → if still flagged: stop for human. Most steps pass on first try.
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

**With design skill**: The design skill creates the plan (`docs/[slug]-poc-spec.md`), then dev implements it (Stage 1 → Stage 2 → Stage 3, repeat for each task).
