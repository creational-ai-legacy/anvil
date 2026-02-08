# Execution Guide (Stage 3)

## Goal
Implement the current task one step at a time.

## Code Allowed
YES

## ⚠️ ONE STEP AT A TIME - THEN STOP

This stage executes the implementation plan from Stage 2 (Planning):
- Execute ONLY the current step
- DO NOT continue to next step automatically
- Each step is bite-sized (small, completable, testable)
- Steps can break into sub-steps: 3a, 3b, 3c
- Document progress in results doc after step completes
- Keep implementation doc clean (no status updates there)
- When step tests pass → STOP and report to user

## ⚠️ EVERY STEP REQUIRES PYTEST VERIFICATION

A step is NOT complete until:
1. Implementation code exists (in appropriate module/file)
2. Tests exist (`tests/test_[task-slug]_*.py`)
3. **ALL tests pass** (`uv run pytest tests/test_[task-slug]_*.py -v`)
4. Results doc updated with step status

**If tests fail**: Fix the issue and re-run tests. Loop until ALL tests pass.
**When tests pass**: Update docs and STOP. DO NOT continue to next step.

## Input
- Plan from Stage 2 (Planning) (`docs/[milestone-slug]-[task-slug]-plan.md`)
- Results tracking doc (`docs/[milestone-slug]-[task-slug]-results.md`)
- Current step to work on

**Before starting**: If `docs/[milestone-slug]-[task-slug]-results.md` doesn't exist yet, create it using `assets/templates/3-results.md` template. Fill in the Summary, Goal, Success Criteria (from plan.md), and Prerequisites sections. Leave Implementation Progress steps as "Pending". **Record Started timestamp** (ISO 8601 with timezone, e.g., `2024-01-08T22:45:00-08:00`).

## Per-Step Workflow (Loop Until Tests Pass)

| Phase | Action | Output | Next |
|-------|--------|--------|------|
| **1. Implement** | Write implementation code for current step | Implementation files in appropriate modules | → Phase 2 |
| **2. Write Tests** | Cover critical paths + edge cases | `tests/test_[task-slug]_*.py` | → Phase 3 |
| **3. Verify** | Run pytest | `uv run pytest tests/test_[task-slug]_*.py -v` | IF FAIL → Phase 1 (fix and retry)<br>IF PASS → Phase 4 |
| **4. Document & STOP** | Update results doc, report completion | `docs/[milestone-slug]-[task-slug]-results.md` (step status + lessons learned) | **STOP - Wait for user** |

**Critical**: Loop phases 1-3 until ALL tests pass. Only when tests pass → document and STOP. DO NOT continue to next step.

## Output (per step)
- Implementation code files — In appropriate modules/directories
- Test files — `tests/test_[task-slug]_*.py` (add tests for this step)
- Update results doc — Mark step complete, add test results, note issues

## Output (when work complete)
- All implementation and test files complete
- `docs/[milestone-slug]-[task-slug]-results.md` — Final status with all success criteria met

## Verification Checkpoints

**After each step:**
- [ ] Implementation code works as expected
- [ ] Tests pass (`uv run pytest tests/test_[task-slug]_*.py -v`)
- [ ] `docs/[milestone-slug]-[task-slug]-results.md` updated with step progress and lessons learned

**After all steps (work complete):**
- [ ] All tests pass
- [ ] `docs/[milestone-slug]-[task-slug]-results.md` shows all success criteria met
- [ ] Production-grade checklist verified

## Implementation Guidelines
- Clear docstrings with usage examples
- Production-grade (real data, real integrations)
- Proper module structure and organization
- Type hints on public methods/functions

## Test Guidelines
- Cover critical paths
- Test edge cases
- Verify outputs match expectations
- Use descriptive test names

### Test Scope: Intentional and Incremental

Testing is about **scope and intentionality**, not speed. Know exactly what you're testing at each step.

**Testing approach (in series):**

1. **Test what you changed** - Run tests for the specific code you modified
2. **Expand to affected tests** - Run tests that might break due to the change
3. **Fix failures before moving on** - Each step should be solid before proceeding
4. **Full suite when it makes sense** - Run full suite at logical checkpoints or when changes are broad

**The implementation plan identifies affected tests in Prerequisites** - use that list to know what to run beyond your immediate changes.

## Documentation Guidelines
- Update `docs/[milestone-slug]-[task-slug]-results.md` after each step
- Include: step status (⏳ Pending / ✅ Complete), test results, issues encountered, bug fixes
- **Add "Lessons Learned" section** for each step documenting key insights, patterns, and gotchas
- Keep implementation doc clean (no status updates there)

## After All Steps Complete

When all steps are complete and all success criteria are met:
1. Record **Completed timestamp** (ISO 8601 with local timezone, e.g., `2024-01-08T22:45:00-08:00`)
2. Update Status to ✅ Complete

## Next Stage
→ Return to Stage 2 for next task (after task complete)
→ MVP complete (when all tasks complete)
