# Review Document Guide (Sequential)

Review design or implementation documents for soundness, logic, consistency, and surprises. This guide runs all checks in a single pass -- no agent coordination required.

## Input

- **Document**: Single file path
- **Flags**: Optional `--auto` (apply fixes immediately after report)
- **Notes**: Optional user context

### Argument Parsing

Parse the arguments string to extract:

1. **Document path**: The file path (required)
2. **`--auto` flag**: If present, apply all fixes after report without prompting
3. **Notes**: Any remaining text after path and flag

Example inputs:
- `docs/core-task-spec.md` -- path only, default mode (prompt user on fixes)
- `docs/core-task-spec.md --auto` -- path + auto-fix
- `docs/core-design.md --auto Fix the naming issues` -- path + auto-fix + notes
- `docs/core-plan.md Some context about this review` -- path + notes, default mode

Strip `--auto` from arguments before processing. Everything else is doc path + optional notes.

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

### Classification Guidance

The sequential reviewer must classify its findings into **per-item** vs **holistic** buckets for the review document. This classification is needed because the sequential path runs all checks in a single pass, unlike the parallel path which naturally separates them via distinct agents.

| Check Step | Bucket | Rationale |
|------------|--------|-----------|
| Step 3 (Template Alignment) | Holistic | Cross-cutting structural check |
| Step 4 (Type-Specific Checks) | Per-item | Findings map to specific items/steps/tasks |
| Step 5 (Universal Checks) | Holistic | Cross-cutting quality checks (soundness, flow, dependencies, contradictions, clarity, terminology, surprises) |
| Step 6 (Codebase Verification) | Per-item | Findings reference specific items/steps/tasks |

Per-item findings go into the Item/Step/Task Summary and Details sections. Holistic findings go into the Holistic Summary and Details sections.

### 8. Cross-Reference Issues Against History

If no issues were found in Steps 3-7, skip this step entirely.

1. **Derive review doc path**: Strip `.md` from the document path, append `-review.md`. Example: `docs/core-poc6-plan.md` becomes `docs/core-poc6-plan-review.md`.
2. **Check if review doc exists** (Read). If it does not exist, skip this step (first review, no history).
3. If it exists, for each item that has issues in this review:
   - Read that item's detail section in the review doc (e.g., "### Step 3: Build API endpoints").
   - Scan prior review entries for matching issues (match by description similarity).
   - If a match is found in a prior entry:
     - If the issue was present in the **most recent** prior entry: annotate as `[Recurring from RN]`. Read the prior entry's suggested fix text and check the current document state to understand why the fix didn't resolve the issue. Append context to the annotation: `[Recurring from RN -- prior fix: <summary of what was applied>; root cause: <why it persists>]`. This gives the fix-applier visibility into the prior attempt so they can craft a more targeted fix.
     - If the issue was **absent** in the most recent prior entry but present in an **earlier** one: annotate as `[Regression from RN]`
   - If no match: leave as-is (new issue).
4. Pass the annotated issues list forward to the write step.

**Matching guidance**: Compare issues within the same item's section, so context is already scoped. Match on issue description similarity. False negatives (missing a match) are acceptable -- false positives (wrong match) are worse. If unsure, treat as a new issue.

### 9. Write to Review Document

Write the full review findings to a persistent review document. The review doc is the primary output -- the conversation gets only a simplified summary (Step 10).

1. **Derive path**: Strip `.md` from the document path, append `-review.md`. Example: `docs/core-poc6-plan.md` becomes `docs/core-poc6-plan-review.md`.
2. **Read tracking template**: Load `~/.claude/skills/review/assets/templates/review-tracking.md`.
3. **Check if review file exists** (Read):
   - **Does not exist**: Create the full structure -- header table, summary tables with R1 column, all item detail sections with R1 entries, holistic sections with R1 entries, review log with R1 row.
   - **Exists**: Determine review number N by counting R columns in the item summary table header. Add RN column to summary tables, append timestamped entries to each item detail section, append holistic entry, add review log row.
4. **Populate per-item findings**: For each item/step/task, set the summary table cell to issue counts (e.g., `1 HIGH 2 MED`) or `✅` for sound. Write the detail entry with timestamp, command, and issues in `- [SEV] Description -> Suggested fix` format. Include history annotations from Step 8 if present (e.g., `[Recurring from R1]`). **Important**: When appending a new review entry (R2, R3, ...) after an existing entry that ends with list items, always insert a blank line before the `**RN**` line. Without the blank line, markdown renders the RN label as a continuation of the preceding list.
5. **Populate holistic findings**: For each concern area, set the holistic summary table cell. Write holistic detail entries by concern with `- **[Concern]** [SEV] Description -> Suggested fix` format.
6. **Set review log entry**:
   - Timestamp: current ISO 8601 with timezone
   - Command: `review-doc`
   - Mode: `Sequential`. Append ` --auto` if the `--auto` flag is active (e.g., `Sequential --auto`)
   - Issues: total counts (e.g., `1 HIGH 3 MED`)
   - Status: `Clean` (no issues) or `Pending` (issues found, not yet fixed)
7. **Write** the review file (full rewrite since summary tables require column addition).

### 10. Present Simplified Summary and Apply Fixes

Present a simplified summary to the conversation. The full report is already in the review document (Step 9).

**If no issues found**:
```
Review #[N] complete: [review-doc-path]
Status: Sound
No issues found.
```

**If issues found -- with `--auto`**:
Show simplified summary, then apply all fixes immediately:
```
Review #[N] complete: [review-doc-path]
Status: Issues Found
Issues: [total] ([X] HIGH, [X] MED, [X] LOW)

See [review-doc-path] for full details.
```
Apply each fix from the findings using Edit tool. Report each fix applied. If a fix cannot be applied (ambiguous target, already correct, or outside document scope), annotate the issue line in the review doc with `[Skipped: reason]` and report the skip to the user.

#### Applying Step-Splitting Fixes (Plan Documents Only)

When a step scope issue suggests splitting a step into sub-steps (e.g., Step 8 into 8a, 8b, 8c), follow this process:

**1. Pre-execution guard**: Before applying, check the results doc (derive path from plan path: replace `-plan.md` with `-results.md`). If the results doc exists, search for the step's status. If the step is `Complete` or `In Progress`, annotate the issue with `[Skipped: step already executed]` and do not apply the split.

**2. Read the full step block**: Extract the entire step from its `### Step N:` heading to the next `### Step` heading (or `## Test Summary`, or end of document). This is the `old_string` for the Edit tool.

**3. Generate sub-step blocks**: Using the reviewer's split guidance (which specifies strategy, content assignment per sub-step, and ordering):
- Create one `### Step Na:` block per sub-step (e.g., `### Step 8a:`, `### Step 8b:`, `### Step 8c:`)
- Each sub-step gets the same structure as a regular step: Goal, checklist, Specification, Acceptance Criteria, Verification, Output
- Distribute the original step's specification items, acceptance criteria, and verification commands across sub-steps as the reviewer's guidance directs
- Each sub-step's Goal is derived from the original Goal, narrowed to its scope
- Each sub-step must be self-contained -- no cross-references between sub-steps (no "as described in Step 8a")
- Determine sub-step ordering based on the reviewer's dependency rationale

**4. Replace using Edit tool**: Use the Edit tool with `old_string` set to the full original step block and `new_string` set to the concatenated sub-step blocks (8a + 8b + 8c).

**5. Match failure handling**: If the Edit tool cannot match the full step block (whitespace variations, block length, concurrent edits):
1. Re-read the plan to get current content
2. Re-extract the step block boundaries
3. Retry the replacement with the updated `old_string`
4. If the retry also fails, annotate the issue with `[Skipped: step block match failed]` and report to the user for manual intervention

**If issues found -- without `--auto`**:
Show simplified summary with issue counts and pointer to review doc:
```
Review #[N] complete: [review-doc-path]
Status: Issues Found
Issues: [total] ([X] HIGH, [X] MED, [X] LOW)

See [review-doc-path] for full details.
```
Then prompt user via AskUserQuestion:
- Apply all fixes
- Pick which fixes to apply
- Done (no fixes)

**Note**: When running in fork context (spawned as a background agent), skip the user prompt. If `--auto` is set, apply fixes. Otherwise, leave Fix Status as `Pending`.

### 11. Update Review Doc Fix Status

Update the review document's Review Log entry for the current review based on what happened in Step 10.

- If fixes were applied (auto or user-chosen): for any fix the user explicitly declines or that cannot be applied, annotate the issue line in the review doc with `[Skipped: reason]`. Update the current review entry's Status from `Pending` to `Applied (X of Y)` where X is fixes applied and Y is total issues.
- If user chose "Done" or no fixes were applied: leave Status as `Pending`.
- If no issues were found (Status is `Clean`): no update needed.

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
8. **History** - Cross-reference issues against item's prior entries in review doc
9. **Write** - Write per-item findings to review document (create or update)
10. **Summary** - Present simplified summary, apply fixes if --auto or prompt user
11. **Fix** - Apply fixes if requested, update Fix Status in review log
