# Planning Guide (Stage 2)

## Goal
Break the task (PoC, feature, bug fix, refactor) into bite-sized, production-grade implementation steps.

## Code Allowed
YES

## Input

**Recommended**: Design document from Stage 1: `docs/[milestone-slug]-[task-slug]-design.md`

If Design doc provided → read and use as blueprint
If no Design doc → plan from scratch (for simple tasks, quick fixes)

## Process
1. List all prerequisites (setup Supabase, configure AWS, API keys, etc.)
2. Break implementation into bite-sized steps (small, completable, testable)
3. Define verification for EACH step (not just end result)
4. Write specifications and acceptance criteria for each step (Steps 1+)
5. Include concrete commands and configs for Step 0 and Prerequisites
6. Identify what makes this "production-grade" vs "demo"
7. Identify affected tests and test scope

## Output

One document is created:

**Plan**: `docs/[milestone-slug]-[task-slug]-plan.md` using `assets/templates/2-plan.md`
- Prerequisites with setup instructions and concrete commands
- Step-by-step implementation guide with specifications and acceptance criteria
- Verification commands per step
- Step 0/Prerequisites: concrete commands, configs, setup instructions
- Steps 1+: specifications describing what to build, acceptance criteria describing how to verify
- **NO status indicators** - keep it clean and focused on "what to build and how to verify"

**Examples**: `docs/core-poc6-plan.md`, `docs/cloud-auth-fix-plan.md`

**Note**: The results tracking document (`docs/[milestone-slug]-[task-slug]-results.md`) will be created later during Stage 3 (Execution) when `/dev-execute` is run.

## From Design to Plan

**Design provides order and approach. Planning provides bite-sized steps.**

When a Design doc exists, follow this process:

### 1. Read Design's Proposed Sequence

- Understand order and dependencies
- Note the rationale for each item's placement
- This is the **starting point**, not the final plan

### 2. Verify by Researching Codebase

- Read files mentioned in Design's "Files to Modify"
- Verify approach is still valid
- Identify gaps or additional work needed

**Planning may discover:**
- Design item needs to be split differently
- Additional prerequisites not in Design
- Order needs adjustment based on code dependencies

### 3. Break Each Item into Steps

- Each Design item (#1, #2, etc.) → multiple Plan steps
- Each step bite-sized, independently verifiable
- Each step includes a specification (what to build) and acceptance criteria (how to verify)

**Example:**
```
Design #1: Async Conversion
  → Plan Step 1: get_transcript_async (spec + acceptance criteria)
  → Plan Step 2: get_metadata_async (spec + acceptance criteria)
  → Plan Step 3: get_video_data_async (spec + acceptance criteria)
  → Plan Step 4: Update routes.py (spec + acceptance criteria)
```

(Tests are inherent to each step -- the acceptance criteria specify what tests must verify, and the executor writes and runs the actual tests during execution)

### 4. Use Analysis Approach for Specification

Design's Analysis has technical details:
- Files to modify
- Patterns to use
- Validation strategy

Planning adds specifications based on these details -- describing behavior, files to create/modify, patterns to follow, and constraints. Function/method signatures (without bodies) are acceptable as part of the specification to communicate interface expectations.

### 5. Inherit and Expand

| Design Section | How Plan Uses It |
|----------------|------------------|
| **Proposed Sequence** | Guides order, Planning creates actual steps |
| **Analysis Approach** | Technical details → step specifications |
| **Files to Modify** | Starting point, verify against codebase |
| **Success Criteria** | Copy to Plan, add verification commands |
| **Testing Strategy** | Expand into acceptance criteria per step |
| **Decisions Log** | Respect - don't re-decide |

## Risk Profile

The plan's Overview table includes a Risk Profile field. Inherit from the design doc. If no design doc exists, see `1-design-guide.md` for selection criteria. Include a one-sentence justification.

## Type Field

Must be exactly one of: **PoC**, **Feature**, **Issue**, **Refactor**

No variations or combinations.

## Deliverables Section

List concrete capabilities as bullets, not prose. Each bullet = one deliverable or proof point.

**Good:**
```
- core/ package structure
- models/, db/, config modules
- AWS RDS connection verified
- FastMCP server starts via stdio
```

**Bad:**
```
Prove that the FastMCP server starts correctly with proper
project structure, and that AWS RDS is accessible...
```

## Verification Checklist
- [ ] Plan doc created (`docs/[milestone-slug]-[task-slug]-plan.md`)
- [ ] **Environment field set** in Overview table (determines tooling guide)
- [ ] Prerequisites explicitly listed with setup instructions and concrete commands
- [ ] **Affected test files identified** in Prerequisites section
- [ ] Each step is small enough to verify independently
- [ ] Each step has Specification and Acceptance Criteria sections (Steps 1+)
- [ ] **Each step includes its tests** - acceptance criteria specify what tests must verify, executor writes and runs during execution
- [ ] **Implementation steps use the environment's test framework** (inline checks OK for prerequisites/Step 0 only)
- [ ] **Test scope is intentional** (test specific change -> affected tests -> full suite when it makes sense)
- [ ] No step relies on mock data where real data is needed
- [ ] Implementation would work in production context
- [ ] Implementation doc contains NO status indicators (keep it clean)
- [ ] **Task is self-contained** - fully functional without requiring future tasks
- [ ] **Contract framing note** present at top of Implementation Steps section

## What CODE IS Allowed

Unlike Stage 1, implementation planning gets into specifics -- but the level of detail depends on the step type:

**Step 0 and Prerequisites** (setup steps keep commands):
- Concrete bash commands, configs, setup instructions
- Exact commands to run for environment setup
- Configuration examples with actual values

**Steps 1+** (specification-driven):
- Specifications describing behavior, files to create/modify, patterns to follow, and constraints
- Acceptance criteria specifying measurable outcomes the reviewer validates
- Function/method signatures (without bodies) to communicate interface expectations
- Verification commands (test commands from environment guide)
- Full code blocks and test code are NOT included -- the executor writes the implementation during execution

## Code Quality Principles

**These are constraints the executor must follow during implementation.** Include them as part of each step's specification constraints when relevant.

> **Environment-specific tooling**: Read the project's environment guide (e.g., `references/python-guide.md`) for concrete data model libraries, type systems, and patterns.

### Object-Oriented Design
- **Classes over functions**: Encapsulate related behavior and state
- **Single Responsibility**: Each class has one clear purpose
- **Composition**: Build complex behavior from simple, composable classes
- **Clear interfaces**: Public methods are intuitive and well-documented

### Validated Data Models
- **Use validated models** for all data structures (configs, API payloads, database records)
- **Type everything**: All function signatures, class attributes, variables
- **No raw untyped containers**: Use validated models instead
- **Specific library**: Per environment guide (e.g., Pydantic for Python)

## Step Size Guidelines

Each step should be:
- **Bite-sized** - small enough to complete comfortably given previous steps are done
- **Independently verifiable** (each step's acceptance criteria should be verifiable on their own)
- **Self-contained** (doesn't require other steps to test)
- **Tests included** (the step specifies what tests must verify; the executor writes and runs tests during execution)

## Tests Must Be In The Same Step

Each step specifies what tests must verify (via acceptance criteria) and the executor writes, runs, and verifies tests pass during execution. Never separate code and tests into different steps. Step names should NOT have "+ Tests" suffix -- tests are inherent. If a step is too big, break it into sub-steps (3a, 3b, 3c).

## Writing Acceptance Criteria

Each step's acceptance criteria should be specific enough that a reviewer can verify pass/fail. The detail level scales with risk profile:

| Risk Profile | Criteria Detail |
|-------------|-----------------|
| **Critical** | Very specific -- exact behaviors, exact error messages, exact edge cases covered |
| **Standard** | Specific -- measurable outcomes, key behaviors verified, test coverage noted |
| **Exploratory** | Loose -- general behaviors, proof-of-concept level verification |

**Good acceptance criteria:**
- "Function returns empty list when no items match filter" (verifiable)
- "API responds with 400 and validation error when required field missing" (specific)
- "Config loads from environment variable with fallback to default" (measurable)

**Bad acceptance criteria:**
- "Code works correctly" (vague)
- "Tests pass" (not specific to what's being tested)
- "Implementation is clean" (subjective)

## Anticipating Trade-offs

Document known decision points the executor will face, with preferred direction and rationale. This helps the executor make context-aware decisions and surfaces choices for the reviewer.

Each trade-off should include:
- **Decision point**: What choice the executor will face
- **Preferred direction**: What the planner recommends
- **Rationale**: Why this direction is preferred
- **Alternative**: What else could be done

Trade-offs are optional per step -- include them when the step has genuine decision points. If a step is straightforward with no meaningful choices, omit the Trade-offs section.

## Self-Contained Task Requirement

**CRITICAL**: Each task must be complete and functional on its own.

**What this means:**
- All existing functionality continues working after task completes
- New capability can be tested/verified immediately
- No "TODO: will work after next task" comments
- Tests pass at end of task

**Strategy: Add Alongside, Don't Replace**

When implementing something that could break existing code, add new functions/classes alongside existing ones rather than modifying them. Migration happens in next task, not this one.

## Production-Grade Checklist

For each step, ensure:
- [ ] **OOP Design**: Classes with single responsibility, clear interfaces
- [ ] **Validated Data Models**: All data structures use validated models (no raw untyped containers)
- [ ] **Strong Typing**: Type annotations on all functions, methods, and attributes
- [ ] No mock data where real data is needed
- [ ] Real integrations, not stubs
- [ ] Error handling included
- [ ] Would work at 10x scale
- [ ] Tests can be written
- [ ] No breaking changes to existing functionality

## Verification & Testing

### Prefer Test Framework Over Inline Checks

**The environment's test framework is always preferred** for verification. Inline/ad-hoc checks are acceptable only for:
- Prerequisites (e.g., "is service reachable?", "can we import the module?")
- Step 0 setup verification (e.g., "did the config load correctly?")

**For implementation steps (Step 1+), always use the test framework** (see environment guide for specific commands).

### Test Scope: Intentional and Incremental

Testing is about **scope and intentionality**, not speed. Know exactly what you're testing at each step.

**Testing approach (in series):**

1. **Test what you changed** - Run tests for the specific code you modified
2. **Expand to affected tests** - Run tests that might break due to the change
3. **Fix failures before moving on** - Each step should be solid before proceeding
4. **Full suite when it makes sense** - Run full suite at logical checkpoints or when changes are broad

### Test File Identification

List affected test files in Prerequisites:
- Which test files exercise the code being changed?
- Which tests might break due to the changes?

## Common Pitfalls
- Steps that are too large
- Missing prerequisites
- No verification criteria
- Mock data that hides real complexity
- Skipping error handling
- Separating code and tests into different steps
- Using raw untyped containers instead of validated models
- Procedural code instead of OOP
- Missing type annotations
- Breaking self-contained requirement
- Running tests without knowing what you're testing
- Using inline checks for implementation step verification (Steps 1+ use test framework)
- Ignoring environment guide

## Next Stage
→ Stage 3: Execution (use 3-execution-guide.md)

## After Task Complete
→ Return to Stage 2 for next task
