# dev-cycle

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

1. **Stage 1: Overview** - High-level design (what and why)
2. **Stage 2: Implementation Plan** - Step-by-step breakdown
3. **Stage 3: Execution** - Actual implementation with tests

## Quick Reference

| Stage | Code? | Guide | Template | Output |
|-------|-------|-------|----------|--------|
| 1. Overview | ❌ NO | `references/1-overview-guide.md` | `assets/templates/overview.md` | `docs/[milestone-slug]-[task-slug]-overview.md` |
| 2. Planning | ✅ YES | `references/2-planning-guide.md` | `assets/templates/implementation-plan.md` | `docs/[milestone-slug]-[task-slug]-implementation.md` |
| 3. Execution | ✅ YES | `references/3-execution-guide.md` | `assets/templates/implementation-results.md` | `docs/[milestone-slug]-[task-slug]-results.md`<br>Implementation files<br>Test files |

| Utility | Template | Output |
|---------|----------|--------|
| `/dev-diagram <slug>` | `assets/templates/diagram.md` | Inserts ASCII box into results doc |
| `/dev-lessons <slug>` | `assets/templates/lessons-learned.md` | Consolidates lessons from results |

## Optional Commands

Users can invoke stages explicitly via commands:
- `/dev-overview <notes>` - Start Stage 1
- `/dev-plan <notes>` - Start Stage 2
- `/dev-execute <notes>` - Start Stage 3
- `/dev-diagram <slug>` - Generate ASCII diagram for task
- `/dev-lessons <slug>` - Consolidate lessons learned

Or use natural language: "Create overview for database abstraction", "Plan the implementation", "Execute step 1"

---

## ⛔ CRITICAL: NO-CODE STAGE (Stage 1)

**Stage 1 (Overview) is strictly a NO-CODE zone.**

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

## Stage 1: Overview

**Goal**: Create high-level design document analyzing the feature/bug/issue.

**Code Allowed**: NO - Pure design and analysis

### When to Use

Run Stage 1 when:
- Starting a new feature
- Planning how to fix a complex bug
- Breaking down a milestone into PoCs
- User explicitly requests an overview

### Process

See `references/1-overview-guide.md` for detailed guidance on:
- Document current architecture
- Define target architecture
- Identify what needs to change
- Break down into self-contained tasks
- Evaluate implementation approaches
- Document design decisions
- Update PoC plan (if applicable)

### Output

Create using `assets/templates/overview.md`:

**File**: `docs/[milestone-slug]-[task-slug]-overview.md`

**Examples**:
- `core-poc6-overview.md` (PoC 6 in Core milestone)
- `core-database-abstraction-overview.md` (feature in Core milestone)
- `cloud-fix-auth-bug-overview.md` (bug fix in Cloud milestone)

**Contents**:
- Executive summary
- Current vs target architecture
- What needs to change
- Task breakdown
- Implementation approaches
- Risks and mitigations
- Design decisions

### Stage 1 Complete Checklist

- [ ] Overview document created with all sections
- [ ] Current architecture documented with code examples
- [ ] Target architecture clearly defined
- [ ] All files requiring changes identified
- [ ] 🔒 **Each task is self-contained** (works independently; doesn't break existing functionality/tests)
- [ ] Task dependency order makes sense
- [ ] Implementation approaches evaluated
- [ ] Recommended approach selected with rationale
- [ ] Risks identified with mitigations
- [ ] Design decisions documented
- [ ] `docs/[slug]-poc-design.md` updated (if applicable)
- [ ] No code written (only diagrams and descriptions)
- [ ] Run `/verify-doc docs/[milestone-slug]-[task-slug]-overview.md`

### Next Stage

→ **Stage 2: Implementation Plan** (use `references/2-planning-guide.md`)

User should review overview, run `/verify-doc`, fix issues, then request Stage 2.

---

## Stage 2: Implementation Plan

**Goal**: Break down a single task into bite-sized, production-grade implementation steps.

**Code Allowed**: YES - Code snippets, configs, examples

### When to Use

Run Stage 2 when:
- Overview is complete and verified
- Ready to plan implementation for next task
- User explicitly requests implementation plan

⚠️ **ONE TASK AT A TIME** - Only plan the next logical task to keep planning agile

✅ **CODE IS ALLOWED** - Unlike Stage 1, use concrete code snippets, commands, and configs

⚠️ **PRODUCTION-GRADE THIN SLICES** - Real integrations, not mocks; patterns that scale

🏗️ **QUALITY OOP CODE** - Use classes with clear responsibilities, Pydantic models for all data structures, strong typing everywhere

🔒 **SELF-CONTAINED** - Each task must be complete and functional on its own; doesn't break existing functionality and existing tests

### Process

See `references/2-planning-guide.md` for detailed guidance on:
- List prerequisites
- Break into bite-sized steps (~30 min each)
- Define verification for each step
- Include specific code snippets
- Identify production-grade requirements (OOP, Pydantic, typing)
- Ensure self-contained (add alongside, don't replace)

### Output

Create using templates:

**Output**: `docs/[milestone-slug]-[task-slug]-implementation.md` (from `assets/templates/implementation-plan.md`)
- Prerequisites with setup instructions
- Step-by-step implementation guide
- Code snippets, commands, configs
- Verification commands
- **NO status indicators** (evergreen guide)

**Note**: The results tracking document (`docs/[milestone-slug]-[task-slug]-results.md`) will be created later during Stage 3 (Execution).

### Stage 2 Complete Checklist

- [ ] Implementation doc created (`docs/[milestone-slug]-[task-slug]-implementation.md`)
- [ ] Prerequisites explicitly listed with setup instructions
- [ ] Each step is small (~30 min) and independently verifiable
- [ ] Each step has clear verification criteria with commands
- [ ] Code snippets are specific and complete
- [ ] 🏗️ **OOP + Pydantic + Type hints enforced**
- [ ] ⚠️ **No mock data where real data needed**
- [ ] 🔒 **Work is self-contained** (add alongside, don't replace; works independently)
- [ ] Run `/verify-doc docs/[milestone-slug]-[task-slug]-implementation.md`

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
- Each step is bite-sized (~30 min max)
- Steps can break into sub-steps: 3a, 3b, 3c
- Loop: implement → test → if fail, fix → re-test (repeat until pass)
- When tests pass → update results doc → STOP
- Keep implementation doc clean (no status updates)

**After all steps complete**: Ask user "Mark task as complete?" → If confirmed, record **Completed timestamp**, update Status to ✅ Complete, then run `/dev-lessons` to consolidate lessons.

### Process

See `references/3-execution-guide.md` for detailed per-step workflow:
1. Implement code for current step
2. Write tests
3. Run pytest verification
4. **IF FAIL**: Fix and return to step 3 (loop until pass)
5. **IF PASS**: Document in results.md and STOP

**⚠️ Critical Rules:**
- Execute ONLY ONE step, then STOP
- Loop until ALL tests pass for current step
- DO NOT continue to next step automatically
- When tests pass → update docs → STOP and report to user

### Implementation Guidelines

- **OOP Design**: Classes with single responsibility, clear interfaces
- **Pydantic Models**: All data structures use Pydantic (no raw dicts)
- **Strong Typing**: Type hints on all functions, methods, attributes
- **Production-grade**: Real data, real integrations, error handling
- **Clear docstrings**: With usage examples
- **Self-contained**: Add alongside, don't replace

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
- Test files (`tests/test_[task-slug]_*.py`)
- Updated `docs/[milestone-slug]-[task-slug]-results.md`

**When work complete**:
- All implementation and test files complete
- `docs/[milestone-slug]-[task-slug]-results.md` with final status

### Stage 3 Verification Checklist

**After each step**:
- [ ] Implementation code works as expected
- [ ] ⚠️ **Tests pass** (`uv run pytest tests/test_[task-slug]_*.py -v`)
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

1. **No docs exist**: Start with Stage 1 (Overview)
2. **Only overview exists**: Move to Stage 2 (Planning)
3. **Implementation plan exists**: Move to Stage 3 (Execution)
4. **Results doc shows progress**: Continue Stage 3 from current step

Use Glob/Grep to check for existing documents:
- `docs/[milestone-slug]-[task-slug]-overview.md`
- `docs/[milestone-slug]-[task-slug]-implementation.md`
- `docs/[milestone-slug]-[task-slug]-results.md`

---

## Best Practices

1. **User always verifies before proceeding**
   - Complete stage
   - User runs `/verify-doc`
   - User fixes issues
   - User explicitly requests next stage

2. **Documentation stays clean**
   - Implementation docs are evergreen (no status)
   - Results docs track live progress
   - Use `/dev-health` for PROJECT_STATE.md updates

3. **One task at a time**
   - Stage 1: Can plan multiple tasks
   - Stage 2: Only plan one task
   - Stage 3: Only execute one task

4. **Tests are mandatory**
   - Every step requires passing tests
   - No step is complete without tests
   - Catches issues early

5. **Self-contained is non-negotiable**
   - Add alongside, don't replace
   - System works at every task boundary
   - No "TODO: will work after next task" comments

---

## File Naming Conventions

**Project Tracking** (created once, updated throughout):
- `PROJECT_STATE.md` - Milestone progress, key decisions, system status, latest health check
- Template: `~/.claude/skills/dev-cycle/assets/templates/PROJECT_STATE.md`
- Keep it concise - remove resolved questions, keep only latest health check

**Per Task**:
- `docs/[milestone-slug]-[task-slug]-overview.md` - e.g., `core-poc6-overview.md`, `cloud-auth-fix-overview.md`
- `docs/[milestone-slug]-[task-slug]-implementation.md` - e.g., `core-poc6-implementation.md`, `cloud-auth-fix-implementation.md`
- `docs/[milestone-slug]-[task-slug]-results.md` - e.g., `core-poc6-results.md`

**Test Files**:
- `tests/test_[task-slug]_*.py` - e.g., `test_poc6_*.py`, `test_auth_fix_*.py`

**Where**:
- `[milestone-slug]` is the milestone name (e.g., `core`, `cloud`, `mobile`)
- `[task-slug]` is the task name (e.g., `poc6`, `auth-fix`, `database-abstraction`)
- Both are lowercase with hyphens

---

## Integration with dev-design

**Standalone**: Use dev-cycle for any development work (features, bugs, refactoring).

**With dev-design**: dev-design creates the plan (`docs/[slug]-poc-design.md`), then dev-cycle implements it (Stage 1 → Stage 2 → Stage 3, repeat for each task).
