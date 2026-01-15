# Planning Guide (Stage 2)

## Goal
Break the task (PoC, feature, bug fix, refactor) into bite-sized, production-grade implementation steps.

## Code Allowed
YES

## ⚠️ ONE TASK AT A TIME

Only generate implementation plan for:
- The next logical task (based on dependency graph), OR
- The specific task you explicitly choose

**Why one at a time?**
- Learnings from one task often change subsequent tasks
- Keeps planning nimble and agile
- Avoids wasted effort on plans that become obsolete

## Input
- Single task from `docs/[slug]-poc-design.md` OR feature/bug to implement

## Process
1. List all prerequisites (setup Supabase, configure AWS, API keys, etc.)
2. Break implementation into bite-sized steps (max 30 min each)
3. Define verification for EACH step (not just end result)
4. Include specific code snippets, commands, configs
5. Identify what makes this "production-grade" vs "demo"
6. Identify affected tests and test scope

## Output

One document is created:

**Implementation Plan**: `docs/[milestone-slug]-[task-slug]-implementation.md` using `assets/templates/implementation-plan.md`
- Prerequisites with setup instructions
- Step-by-step implementation guide
- Code snippets, commands, configs
- Verification commands
- **NO status indicators** - keep it clean and focused on "how to implement"

**Examples**: `docs/core-poc6-implementation.md`, `docs/cloud-auth-fix-implementation.md`

**Note**: The results tracking document (`docs/[milestone-slug]-[task-slug]-results.md`) will be created later during Stage 3 (Execution) when `/dev-execute` is run.

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
- [ ] Implementation doc created (`docs/[milestone-slug]-[task-slug]-implementation.md`)
- [ ] Prerequisites explicitly listed with setup instructions
- [ ] **Affected test files identified** in Prerequisites section
- [ ] Each step is small enough to verify independently
- [ ] Each step has clear verification criteria (with code)
- [ ] **Each step includes its tests** - code and tests written/run together, never separated
- [ ] **Implementation steps use pytest** (inline Python OK for prerequisites/Step 0 only)
- [ ] **Test scope is intentional** (test specific change → affected tests → full suite when it makes sense)
- [ ] No step relies on mock data where real data is needed
- [ ] Implementation would work in production context
- [ ] Implementation doc contains NO status indicators (keep it clean)
- [ ] **Task is self-contained** - fully functional without requiring future tasks

## What CODE IS Allowed

Unlike Stage 1, implementation planning gets into specifics:
- Concrete code snippets for each step
- Specific function signatures
- Exact commands to run
- Configuration examples
- Test code structure

## Code Quality Principles

**Write production-grade, maintainable code from the start:**

### Object-Oriented Design
- **Classes over functions**: Encapsulate related behavior and state
- **Single Responsibility**: Each class has one clear purpose
- **Composition**: Build complex behavior from simple, composable classes
- **Clear interfaces**: Public methods are intuitive and well-documented

### Strong Typing with Pydantic
- **Use Pydantic models** for all data structures (configs, API payloads, database records)
- **Type everything**: All function signatures, class attributes, variables
- **Validation built-in**: Pydantic handles validation, serialization, and documentation
- **No dictionaries for structured data**: Use Pydantic models instead

## Step Size Guidelines

Each step should be:
- **Completable in ~30 minutes or less**
- **Independently verifiable** (you can prove it works)
- **Self-contained** (doesn't require other steps to test)
- **Tests included** (write AND run tests in the same step)

## Tests Must Be In The Same Step

**CRITICAL**: Each implementation step includes writing AND running tests for that step's code.

**Never separate code and tests into different steps:**
- ❌ Step 1: Write the class → Step 2: Write tests for the class
- ✅ Step 1: Write the class + tests → verify all pass → move on

**Why?**
- Catch bugs immediately while context is fresh
- Ensures each step is verified before building on it
- Prevents "I'll test it later" which becomes never
- Each step stands alone as complete, tested work

**Step structure:**
1. Write the code
2. Write the tests
3. Run the tests
4. All pass → move to next step

If a step is too big, break it into sub-steps (3a, 3b, 3c).

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
- [ ] **Pydantic Models**: All data structures use Pydantic (no raw dicts for structured data)
- [ ] **Strong Typing**: Type hints on all functions, methods, and attributes
- [ ] No mock data where real data is needed
- [ ] Real integrations, not stubs
- [ ] Error handling included
- [ ] Would work at 10x scale
- [ ] Tests can be written
- [ ] No breaking changes to existing functionality

## Verification & Testing

### Prefer pytest Over Inline Python

**pytest is always preferred** for verification. Inline Python (`python -c`) is acceptable only for:
- Prerequisites (e.g., "is database connected?", "can we import the module?")
- Step 0 setup verification (e.g., "did the config load correctly?")

**For implementation steps (Step 1+), always use pytest:**

```bash
# ✅ Prerequisites/Step 0 - inline OK for quick checks
python -c "from mymodule import MyClass; print('Import works')"

# ✅ Implementation steps - always pytest
cd [directory] && uv run pytest tests/test_mymodule.py -v
```

**Why pytest for implementation steps:**
- Repeatable and documented
- Part of the test suite
- Catches regressions
- Professional standard

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
- **Separating code and tests into different steps** - tests must be written AND run in the same step as the code
- **Using raw dicts instead of Pydantic models** (loses validation, type safety, documentation)
- **Procedural code instead of OOP** (harder to test, maintain, extend)
- **Missing type hints** (reduces IDE support, increases bugs)
- **Breaking self-contained requirement** (add alongside don't replace; task must work independently without future tasks)
- **Running tests without knowing what you're testing** (be intentional; test specific change, then affected tests, then expand)
- **Using inline Python for implementation step verification** - use pytest for Steps 1+ (inline OK for prerequisites/Step 0)

## Next Stage
→ Stage 3: Execution (use 3-execution-guide.md)

## After Task Complete
→ Return to Stage 2 for next task
