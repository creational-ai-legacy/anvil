# dev-cycle

A structured 3-stage workflow for building features, fixing bugs, and implementing PoCs with production-grade quality.

## Overview

This skill guides you through a complete development cycle:

1. **Stage 1: Overview** - High-level design (what and why)
2. **Stage 2: Implementation Plan** - Step-by-step breakdown
3. **Stage 3: Execution** - Actual implementation with tests

**Works for**: Features, bugs, PoCs, milestones, or any development work.

## Quick Reference

| Stage | Code? | Guide | Template | Output |
|-------|-------|-------|----------|--------|
| 1. Overview | ❌ NO | `references/1-overview-guide.md` | `assets/templates/overview.md` | `docs/[name]-overview.md` |
| 2. Planning | ✅ YES | `references/2-planning-guide.md` | `assets/templates/implementation-plan.md` | `docs/[name]-implementation.md` |
| 3. Execution | ✅ YES | `references/3-execution-guide.md` | `assets/templates/implementation-results.md` | `docs/[name]-results.md`<br>Implementation files<br>Test files |

## Optional Commands

Users can invoke stages explicitly via commands:
- `/dev-overview <notes>` - Start Stage 1
- `/dev-plan <notes>` - Start Stage 2
- `/dev-execute <notes>` - Start Stage 3

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

### Why This Matters:
- Preserves token space for what matters: thinking and design
- Prevents premature implementation decisions
- Forces clear conceptual understanding before coding
- Ensures design is sound before investing in implementation

### If Asked to Write Code in Stage 1:
Respond: "We're in the Overview stage — let's keep focus on architecture and design. Code comes in Stage 2 (Planning with code snippets) and Stage 3 (Execution with full implementation). For now, let me describe how this would work at a high level..."

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
- Break down into self-contained work items
- Evaluate implementation approaches
- Document design decisions
- Update PoC plan (if applicable)

### Output

Create using `assets/templates/overview.md`:

**File**: `docs/[name]-overview.md`

Where `[name]` is descriptive:
- `database-abstraction-overview.md` (feature)
- `fix-auth-bug-overview.md` (bug)
- `poc6-overview.md` (PoC)

**Contents**:
- Executive summary
- Current vs target architecture
- What needs to change
- Work item breakdown (PoCs/phases)
- Implementation approaches
- Risks and mitigations
- Design decisions

### Stage 1 Complete Checklist

- [ ] Overview document created with all sections
- [ ] Current architecture documented with code examples
- [ ] Target architecture clearly defined
- [ ] All files requiring changes identified
- [ ] 🔒 **Each work item is self-contained** (works independently; doesn't break existing functionality/tests)
- [ ] Work item dependency order makes sense
- [ ] Implementation approaches evaluated
- [ ] Recommended approach selected with rationale
- [ ] Risks identified with mitigations
- [ ] Design decisions documented
- [ ] `docs/[name]-poc-design.md` updated (if applicable)
- [ ] No code written (only diagrams and descriptions)
- [ ] Run `/verify-doc docs/[name]-overview.md`

### Next Stage

→ **Stage 2: Implementation Plan** (use `references/2-planning-guide.md`)

User should review overview, run `/verify-doc`, fix issues, then request Stage 2.

---

## Stage 2: Implementation Plan

**Goal**: Break down a single work item into bite-sized, production-grade implementation steps.

**Code Allowed**: YES - Code snippets, configs, examples

### When to Use

Run Stage 2 when:
- Overview is complete and verified
- Ready to plan implementation for next work item
- User explicitly requests implementation plan

⚠️ **ONE WORK ITEM AT A TIME** - Only plan the next logical work item to keep planning agile

✅ **CODE IS ALLOWED** - Unlike Stage 1, use concrete code snippets, commands, and configs

⚠️ **PRODUCTION-GRADE THIN SLICES** - Real integrations, not mocks; patterns that scale

🏗️ **QUALITY OOP CODE** - Use classes with clear responsibilities, Pydantic models for all data structures, strong typing everywhere

🔒 **SELF-CONTAINED** - Each work item must be complete and functional on its own; doesn't break existing functionality and existing tests

---

**Why one at a time?** Learnings from one item often change subsequent items.

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

**Output**: `docs/[name]-implementation.md` (from `assets/templates/implementation-plan.md`)
- Prerequisites with setup instructions
- Step-by-step implementation guide
- Code snippets, commands, configs
- Verification commands
- **NO status indicators** (evergreen guide)

**Note**: The results tracking document (`docs/[name]-results.md`) will be created later during Stage 3 (Execution).

### Stage 2 Complete Checklist

- [ ] Implementation doc created (`docs/[name]-implementation.md`)
- [ ] Prerequisites explicitly listed with setup instructions
- [ ] Each step is small (~30 min) and independently verifiable
- [ ] Each step has clear verification criteria with commands
- [ ] Code snippets are specific and complete
- [ ] 🏗️ **OOP + Pydantic + Type hints enforced**
- [ ] ⚠️ **No mock data where real data needed**
- [ ] 🔒 **Work is self-contained** (add alongside, don't replace; works independently)
- [ ] Run `/verify-doc docs/[name]-implementation.md`

### Next Stage

→ **Stage 3: Execution** (use `references/3-execution-guide.md`)

User should review plan, run `/verify-doc`, fix issues, then request Stage 3.

---

## Stage 3: Execution

**Goal**: Implement the current work item one step at a time.

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

Execute the implementation plan:
- Execute ONLY the current step (DO NOT do multiple steps)
- Each step is bite-sized (~30 min max)
- Steps can break into sub-steps: 3a, 3b, 3c
- Loop: implement → test → if fail, fix → re-test (repeat until pass)
- When tests pass → update results doc → STOP
- Keep implementation doc clean (no status updates)

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

- Update `docs/[name]-results.md` after EACH step
- Include: step status, test results, issues, bug fixes
- **Add "Lessons Learned"** for each step (insights, patterns, gotchas)
- Keep implementation doc clean (no status updates there)

### Output

**Per step**:
- Implementation code files (in appropriate modules)
- Test files (`tests/test_[name]_*.py`)
- Updated `docs/[name]-results.md`

**When work complete**:
- All implementation and test files complete
- `docs/[name]-results.md` with final status

### Stage 3 Verification Checklist

**After each step**:
- [ ] Implementation code works as expected
- [ ] ⚠️ **Tests pass** (`uv run pytest tests/test_[name]_*.py -v`)
- [ ] `docs/[name]-results.md` updated with step progress and **lessons learned**

**After all steps (work complete)**:
- [ ] All tests pass (new + existing)
- [ ] `docs/[name]-results.md` shows all success criteria met
- [ ] Production-grade checklist verified

### Common Pitfalls

- Skipping tests
- Not documenting as you go (especially lessons learned)
- Steps that are too large
- Ignoring edge cases
- Using raw dicts instead of Pydantic models
- Missing type hints
- Breaking self-contained requirement

### Next Stage

→ **Return to Stage 2** for next work item (after work complete)

---

## State Detection

The skill should detect where the user is in the workflow:

1. **No docs exist**: Start with Stage 1 (Overview)
2. **Only overview exists**: Move to Stage 2 (Planning)
3. **Implementation plan exists**: Move to Stage 3 (Execution)
4. **Results doc shows progress**: Continue Stage 3 from current step

Use Glob/Grep to check for existing documents:
- `docs/*-overview.md`
- `docs/*-implementation.md`
- `docs/*-results.md`

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
   - Use `/small-win-check` for PROJECT_STATE.md updates

3. **One item at a time**
   - Stage 1: Can plan multiple work items
   - Stage 2: Only plan one work item
   - Stage 3: Only execute one work item

4. **Tests are mandatory**
   - Every step requires passing tests
   - No step is complete without tests
   - Catches issues early

5. **Self-contained is non-negotiable**
   - Add alongside, don't replace
   - System works at every PoC boundary
   - No "TODO: will work after next PoC" comments

---

## File Naming Conventions

**Project Tracking** (created once, updated throughout):
- `PROJECT_STATE.md` - Current work item, progress, latest health check (follow template structure only)
- Template: `~/.claude/skills/dev-cycle/assets/templates/PROJECT_STATE.md`

**Per Work Item**:
- `docs/[name]-overview.md` - e.g., `database-abstraction-overview.md`, `fix-auth-bug-overview.md`, `poc6-overview.md`
- `docs/[name]-implementation.md` - e.g., `poc6-implementation.md`, `auth-fix-implementation.md`
- `docs/[name]-results.md` - e.g., `poc6-results.md`

**Test Files**:
- `tests/test_[name]_*.py` - e.g., `test_poc6_*.py`, `test_auth_fix_*.py`

**Where `[name]` is**:
- Descriptive and readable
- Lowercase with hyphens
- Specific to the work item (can be PoC, feature, bug, milestone)

---

## When to Use This Skill

**Good fits**:
- Building a new feature
- Fixing a complex bug
- Implementing PoCs from dev-design
- Refactoring existing code
- Adding new capabilities

**Not a good fit**:
- Simple one-line fixes (just do it)
- Typos or documentation updates (just do it)
- Pure exploration/research (use Task tool with explore agent)

---

## Integration with dev-design

This skill can be used **standalone** OR as part of the **dev-design workflow**:

**Standalone**: Use dev-cycle for any development work (features, bugs, refactoring, etc.)

**With dev-design**:
1. **dev-design** (Stages 1-4) creates the initial plan: `docs/north-star.md`, `docs/[name]-architecture.md`, `docs/[name]-poc-design.md`
2. **dev-cycle** takes over for the development loop:
   - Pick work item from `docs/[name]-poc-design.md`
   - Stage 1: Create overview if needed (for new issues/features)
   - Stage 2: Plan the implementation
   - Stage 3: Execute step by step
   - Repeat for next work item

**Files Created**:
- `PROJECT_STATE.md` - Created by dev-cycle on first use, updated when work items complete and via `/small-win-check` (follow template structure exactly)
- `docs/[name]-implementation.md` - Implementation guide (evergreen)
- `docs/[name]-results.md` - Progress tracking (live status)
