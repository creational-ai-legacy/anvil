# Review Document Guide (Sequential)

Review design or implementation documents for soundness, logic, consistency, and surprises. This guide runs all checks in a single pass -- no agent coordination required.

## Input

- **Document**: Single file path
- **Notes**: Optional user context

## Document Type Recognition

Identify document type from filename pattern:

### Design Docs (design skill)

| Pattern | Type | Cross-Reference |
|---------|------|-----------------|
| `*-vision.md` | Vision | None (root document) |
| `*-architecture.md` | Architecture | vision |
| `*-roadmap.md` | Roadmap | architecture, vision |
| `[milestone]-milestone-spec.md` | Milestone Spec | roadmap, architecture |
| `[milestone]-task-spec.md` | Task Spec | milestone-spec |

### Dev Docs (dev skill)

| Pattern | Type | Cross-Reference |
|---------|------|-----------------|
| `docs/[slug]-design.md` | Task Design | task-spec or milestone-spec |
| `docs/[slug]-plan.md` | Plan | design for same slug |
| `docs/[slug]-results.md` | Results | plan (rarely reviewed) |
| `docs/[milestone]-milestone-summary.md` | Milestone Summary | all task results for milestone |

## Verification Process

### 1. Identify Document Type

Match filename against patterns above to determine:
- Document type
- Which supporting docs to read

### 2. Load Supporting Docs

Read cross-reference documents based on type. These provide context for verification.

### 3. Template Alignment

Each doc type has a template. Verify the document follows its template structure:

| Doc Type | Template Location |
|----------|-------------------|
| Vision | `~/.claude/skills/design/assets/templates/1-vision.md` |
| Architecture | `~/.claude/skills/design/assets/templates/2-architecture.md` |
| Roadmap | `~/.claude/skills/design/assets/templates/3-roadmap.md` |
| Milestone Spec | `~/.claude/skills/design/assets/templates/4-milestone-spec.md` |
| Task Spec | `~/.claude/skills/design/assets/templates/5-task-spec.md` |
| Task Design | `~/.claude/skills/dev/assets/templates/1-design.md` |
| Plan | `~/.claude/skills/dev/assets/templates/2-plan.md` |
| Results | `~/.claude/skills/dev/assets/templates/3-results.md` |

Check:
- Required sections present
- Section order matches template
- No missing fields

### 4. Type-Specific Checks

**Design Docs** (vision, architecture, roadmap, milestone-spec, task-spec):
- Vision alignment with parent docs
- Scope consistency
- Terminology consistency
- Feasibility of proposed approach

**Task Design** (NO CODE - design only):
- Alignment with task-spec or milestone design
- Clear challenge statement
- Defined success criteria
- Reasonable scope
- **Approach is sound** - makes technical sense
- **Approach is incremental** - builds on existing code, doesn't require big-bang rewrites
- **No full code in document** - this is design phase only (patterns/signatures OK)
- **Single task only** - Design should not list "Task 1, Task 2, Task 3" (each task gets its own design)
- **Analysis is non-sequential** - Each item (1, 2, 3...) analyzed independently
- **Proposed Sequence uses item notation** - #1 -> #2 -> #3 (NOT "Step 1, Step 2")
- **Proposed Sequence has per-item reasoning** - Each item has Depends On, Rationale, and optional Notes
- **Risk Profile present** - Executive Summary has Risk Profile with valid level: Critical, Standard, or Exploratory
- **Risk Justification present** - Executive Summary has Risk Justification as one sentence explaining why this level
- **Constraints section present** - H2 section between Context and Analysis (or explicitly noted as "No constraints identified")
- **Implementation Options included** - Section present when any design decision has multiple viable approaches (omit only if genuinely no alternatives exist)

**Plan**:
- Steps follow design's Proposed Sequence
- Dependency chain complete (each step sets up the next)
- Self-contained steps (specification + acceptance criteria together in each step)
- No missing prerequisites
- Each implementation step (Step 1+) has Specification and Acceptance Criteria sections
- Contract framing note present at top of Implementation Steps section
- Step 0 and Prerequisites retain concrete commands and setup instructions
- Optional Trade-offs field present for anticipated decisions

**Milestone Summary** (rarely reviewed):
- Accurate status for each task
- Consistent with individual results docs
- Complete coverage of all tasks

### 5. Universal Checks

Apply to all document types:

**Soundness**
- Overall approach coherent and feasible
- No logical flaws or contradictions
- Realistic scope
- Assumptions clearly stated

**Step Flow** (for docs with steps/phases)
- Logical ordering
- Smooth transitions
- Complete before moving on

**Dependency Chain**
- Each step produces what next step needs
- No circular dependencies
- No unused outputs
- Flag: step uses something not yet created
- Flag: step creates something never used

**Contradictions**
- Within document: conflicting statements
- With cross-referenced docs: misaligned definitions
- Inconsistent terminology (same concept, different names)
- Success criteria that contradict implementation approach

**Clarity**
- No vague language ("should probably", "might need")
- Specific examples where needed
- Consistent terminology
- No missing context (assumes knowledge not stated)

**Terminology** (critical for Design docs)
- **Task** = a unit of work (PoC, Feature, Issue, Refactor) - each task gets its own Design
- **Analysis** = non-sequential section analyzing each item independently (numbered 1, 2, 3...)
- **Proposed Sequence** = item order with rationale (#1 -> #2 -> #3) - NOT "Steps"
- **Step** = implementation sub-unit - used ONLY in Planning stage, not Design
- Flag if Design uses "Step 1, Step 2" terminology (should use #1, #2 item notation)
- Flag if Design lists multiple tasks ("Task 1, Task 2" or "Phase 1, Phase 2") - should be a single task
- Flag if Analysis section implies order (that's for Proposed Sequence)

**Hunt for Surprises**
- Hidden dependencies: assumes something exists that isn't explicitly created
- External dependencies: APIs, services, credentials that might not be available
- Environment assumptions: tools, versions, permissions assumed but not checked
- Edge cases: what could go wrong that isn't addressed
- Missing error handling: what if a step fails

### 6. Codebase Verification

Use Glob, Grep, Read to verify:
- Referenced files/functions exist
- Proposed structure compatible with existing patterns
- Dependencies already configured
- PoC code matches what's described

### 7. External Sources (if needed)

Use WebSearch only if document makes claims about:
- External library APIs or behavior
- Version compatibility
- Third-party service configurations
- Best practices that might have changed

### 8. Generate Report

Use the `final-report.md` template at `~/.claude/skills/review/assets/templates/final-report.md` for report structure.

Set the **Review Mode** field to `Sequential`.

Populate all sections:
- **Template Alignment**: results from Step 3
- **Document Analysis**: results from Steps 4-5 (Soundness, Step Flow, Dependency Chain, Clarity & Terminology, Potential Surprises, Cross-Reference Check)
- **Codebase Verification**: results from Step 6
- **Issues Found**: consolidated table with severity, location, issue, and suggested fix. Set the **Item** column to `--` (sequential mode does not use item agents).
- **Recommendations**: prioritized list of actionable fixes

### 9. Offer Fixes

If issues found, **prompt the user** with options:

1. **Apply all fixes** - Automatically fix all identified issues
2. **Pick which to apply** - Let user select specific fixes
3. **Just the report** - No changes, only the report

Use AskUserQuestion to present these options. Wait for user response before proceeding.

---

## Key Questions

By the end of review, answer:

1. **Is it sound?** Does the overall plan make sense?
2. **Is it logical?** Are steps in the right order?
3. **Is it smooth?** Do steps flow naturally into each other?
4. **Does each step set up the next?** Is the dependency chain complete?
5. **Any surprises?** What could go wrong that we haven't thought of?
6. **Any contradictions?** Do any statements conflict with each other?
7. **Is it clear?** Are instructions unambiguous and complete?
8. **Aligned with parent docs?** Consistent with cross-referenced documents?

---

## Quick Reference

1. **Identify** - Match filename to doc type
2. **Load** - Read cross-reference docs for context
3. **Template** - Check doc follows its template structure
4. **Type-specific** - Checks per doc type (design = NO CODE, sound, incremental)
5. **Universal** - Soundness, flow, dependencies, contradictions, clarity, terminology, surprises
6. **Codebase** - Verify against existing code
7. **External** - WebSearch if needed for APIs/versions
8. **Report** - Use final-report.md template
9. **Fix** - Offer to apply changes
