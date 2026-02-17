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

## ⚠️ EVERY STEP REQUIRES TEST VERIFICATION

A step is NOT complete until:
1. Implementation code exists (in appropriate module/file)
2. Tests exist (per environment conventions from the plan)
3. **ALL tests pass** (run test suite per environment guide)
4. Results doc updated with step status

**If tests fail**: Fix the issue and re-run tests. Loop until ALL tests pass.
**When tests pass**: Update docs and STOP. DO NOT continue to next step.

## Input
- Plan from Stage 2 (Planning) (`docs/[milestone-slug]-[task-slug]-plan.md`)
- Results tracking doc (`docs/[milestone-slug]-[task-slug]-results.md`)
- Current step to work on

**Before starting**: If `docs/[milestone-slug]-[task-slug]-results.md` doesn't exist yet, create it using `assets/templates/3-results.md` template. Fill in the Summary, Goal, Success Criteria (from plan.md), and Prerequisites sections. Leave Implementation Progress steps as "Pending". **Record Started timestamp** (ISO 8601 with timezone, e.g., `2024-01-08T22:45:00-0800`).

## Per-Step Workflow (Loop Until Tests Pass)

| Phase | Action | Output | Next |
|-------|--------|--------|------|
| **1. Implement** | Write implementation code for current step | Implementation files in appropriate modules | → Phase 2 |
| **2. Write Tests** | Cover critical paths + edge cases | Test files per environment conventions | → Phase 3 |
| **3. Verify** | Run test suite | Per environment guide commands | IF FAIL → Phase 1 (fix and retry)<br>IF PASS → Phase 4 |
| **4. Document & STOP** | Update results doc, report completion | `docs/[milestone-slug]-[task-slug]-results.md` (step status + lessons learned) | **STOP - Wait for user** |

**Critical**: Loop phases 1-3 until ALL tests pass. Only when tests pass → document and STOP. DO NOT continue to next step.

## Fix Mode (when invoked with `--fix`)

When the orchestrator or user passes `--fix` with review findings, you are in fix mode. Your scope is constrained:

1. Fix ONLY the flagged issues — do not re-implement the entire step
2. Do not restructure code beyond what's needed to address the flags
3. Re-run affected tests
4. Update Trade-offs & Decisions if the fix involves a new decision
5. Update the step block in results.md **IN-PLACE**: replace Implementation, Test Results, and Issues sections with post-fix state. Do not append below the original.

Then STOP and report — the orchestrator will trigger re-review.

## Output (per step)
- Implementation code files — In appropriate modules/directories
- Test files — Per environment conventions (add tests for this step)
- Update results doc — Mark step complete, add test results, note issues

## Output (when work complete)
- All implementation and test files complete
- `docs/[milestone-slug]-[task-slug]-results.md` — Final status with all success criteria met

## Verification Checkpoints

**After each step:**
- [ ] Implementation code works as expected
- [ ] Tests pass (run test suite per environment guide)
- [ ] `docs/[milestone-slug]-[task-slug]-results.md` updated with step progress and lessons learned

**After all steps (work complete):**
- [ ] All tests pass
- [ ] `docs/[milestone-slug]-[task-slug]-results.md` shows all success criteria met
- [ ] Production-grade checklist verified

## Implementation Guidelines

The executor reads the step's **specification** from the plan and writes the implementation based on it. Plans are spec-driven: steps contain behavior descriptions, files to create/modify, patterns to follow, and constraints — not pre-written code blocks to copy. The executor should follow the step's constraints and patterns, but make context-aware decisions about the actual code.

- Clear docstrings with usage examples
- Production-grade (real data, real integrations)
- Proper module structure and organization
- Type hints on public methods/functions

**Acceptance criteria self-check**: Before marking a step complete, verify the implementation meets the step's acceptance criteria from the plan. Acceptance criteria are the executor's checklist for what "done" means for this step. If any criterion is not met, the step is not complete.

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
- Include: step status (⬜ Pending / 🔄 In Progress / ✅ Complete), test results, issues encountered, bug fixes
- **Add "Lessons Learned" section** for each step documenting key insights, patterns, and gotchas
- **Fill "Trade-offs & Decisions" section** for every step. If no meaningful decisions were made, write: "No significant trade-offs — straightforward implementation per plan."
- **Fill "Deviation from Plan" field** for every step. When the executor deviates from the plan's specification (different files, different approach, different structure), document what changed and why. If no deviation, write: "None -- implemented per plan specification."
- Keep implementation doc clean (no status updates there)

## Conceptual Review

After each step, a review agent runs 5 checks at depth determined by the Risk Profile. See `review-guide.md` for the full checklist, depth table, and risk profile behavior.

## After All Steps Complete

When all steps are complete and all success criteria are met, run `/dev-finalize` which handles:
1. Record **Completed timestamp** (ISO 8601 with local timezone)
2. Consolidate lessons learned
3. Generate ASCII diagram
4. Run health check and update PROJECT_STATE.md

## Next Stage
→ Return to Stage 2 for next task (after task complete)
→ MVP complete (when all tasks complete)
