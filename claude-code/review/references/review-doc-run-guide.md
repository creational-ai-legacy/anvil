# Review Document Guide (Parallel Orchestrator)

Orchestrate a parallel doc review using background subagents with incremental processing. This guide is used by `/review-doc-run` in the main conversation. The orchestrator reads the document, extracts items, creates a review doc skeleton, spawns agents in the background, and writes findings incrementally as each agent completes.

**This guide contains orchestration logic only.** Review check logic lives in the item and holistic guides. Report output formats live in the templates.

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
- `docs/core-task-spec.md` -- path only, default mode (report only)
- `docs/core-task-spec.md --auto` -- path + auto-fix
- `docs/core-design.md --auto Fix the naming issues` -- path + auto-fix + notes
- `docs/core-plan.md Some context about this review` -- path + notes, default mode

Strip `--auto` from arguments before processing. Everything else is doc path + optional notes.

---

## Phase 1: Setup (Orchestrator, Sequential)

### 1.1 Read the Document

Read the full document content.

### 1.2 Identify Document Type

Match filename against patterns to determine document type and cross-references.

#### Design Docs (design skill)

| Pattern | Type | Parallel | Cross-Reference |
|---------|------|----------|-----------------|
| `*-vision.md` | Vision | No | None (root document) |
| `*-architecture.md` | Architecture | No | vision |
| `*-roadmap.md` | Roadmap | No | architecture, vision |
| `[milestone]-milestone-spec.md` | Milestone Spec | No | roadmap, architecture |
| `[milestone]-task-spec.md` | Task Spec | **Yes** | milestone-spec |

#### Dev Docs (dev skill)

| Pattern | Type | Parallel | Cross-Reference |
|---------|------|----------|-----------------|
| `docs/[slug]-design.md` | Task Design | **Yes** | task-spec or milestone-spec |
| `docs/[slug]-plan.md` | Plan | **Yes** | design for same slug |
| `docs/[slug]-results.md` | Results | No | plan (rarely reviewed) |
| `docs/[milestone]-milestone-summary.md` | Milestone Summary | No | all task results for milestone |

### 1.3 Determine Review Mode

Only three doc types support parallel review: **Task Spec**, **Task Design**, and **Plan**.

- If the doc type is one of these three, continue with parallel review (Phase 2).
- If the doc type is anything else (Vision, Architecture, Roadmap, Milestone Spec, Results, Milestone Summary), **fall back to sequential review**: follow the sequential review guide at `~/.claude/skills/review/references/review-doc-guide.md` instead. Stop following this guide.

### 1.4 Read Cross-Reference Documents

Based on the doc type, read the cross-reference documents identified in the table above. These will be provided to agents as context.

### 1.5 Extract Items

Parse the document to identify individual items based on doc type rules.

---

#### Task Spec Extraction

**Item boundary**: Each `### Task: [Name]` block.
- Start: `### Task: [Name]` heading
- End: Next `### Task:` heading, or `## Execution Order` section, or end of document

**Shared context** (same for all items): Extract and concatenate:
- The **Milestone Overview** section (from `## Milestone Overview` to the next `##`)
- The **Task Dependency Diagram** section (from `## Task Dependency Diagram` to the next `##`)

**Item count**: Number of `### Task:` blocks found.

---

#### Task Design Extraction

**Item boundary**: Each `### N. [Name]` analysis block.
- Start: `### N. [Name]` heading (where N is a number)
- End: Next `### N+1.` heading, or `## Proposed Sequence` section, or end of document

**Shared context** (same for all items): Extract and concatenate:
- The **Executive Summary** section (from `## Executive Summary` to the next `##`)
- The **Constraints** section (from `## Constraints` to the next `##`)
- The **Target State** section (from `### Target State` to the next `##` or `###` at the same or higher level)

**Item count**: Number of `### N.` analysis blocks found.

---

#### Plan Extraction

**Item boundary**: Each `### Step N:` or `### Step Na:` implementation block.
- Start: `### Step` heading (matches both `### Step 3:` and `### Step 3a:`)
- End: Next `### Step` heading, or `## Test Summary` section, or end of document

**Shared context** (same for all items): Extract and concatenate:
- The **Overview** table (from `## Overview` to the next `##`)
- The **Prerequisites** section (from `## Prerequisites` to the next `##`)
- The **Success Criteria** section (from `## Success Criteria` to the next `##`)

**Item count**: Number of `### Step` headings found (regardless of whether they are whole numbers or sub-steps).

---

### 1.6 Fallback Check

If extraction finds zero items (the document has the right type but no parseable items), fall back to sequential review: follow `~/.claude/skills/review/references/review-doc-guide.md` instead. Stop following this guide.

### 1.7 Prepare Cross-Reference Excerpts

For item agents, prepare condensed cross-reference excerpts. Read the cross-reference documents and extract the sections most relevant to item-level review:

- **Task Spec** cross-refs: From the milestone-spec, extract the milestone overview and relevant task descriptions
- **Task Design** cross-refs: From the task-spec, extract the specific task block that matches this design
- **Plan** cross-refs: From the design, extract the Executive Summary, Constraints, and Proposed Sequence

Keep excerpts concise. The item agents have access to Read and can look up additional details themselves.

### 1.8 Create Review Doc Skeleton

Before spawning agents, create the review document structure so it exists while agents are running.

1. **Derive review doc path**: Strip `.md` from the document path, append `-review.md`. Example: `docs/core-poc6-plan.md` becomes `docs/core-poc6-plan-review.md`.
2. **Read tracking template**: Load `~/.claude/skills/review/assets/templates/review-tracking.md`.
3. **Check if review doc exists** (Read):
   - **Does not exist**: Create the skeleton — header table, summary tables with all items/concerns listed and a single review column where every cell is `...`, empty detail sections (headers only, no entries yet), empty holistic detail section, review log with a pending row. This is R1.
   - **Exists**: Determine review number N by counting R columns in the item summary table header. Add RN column to summary tables with all cells set to `...`.
4. **Write** the skeleton. The `...` cells indicate "in progress" — they will be replaced with issue counts or `✅` as each agent completes.

---

## Phase 2: Background Spawning (Subagents)

**Spawn ALL agents in a SINGLE message with `run_in_background: true`** — one Task tool call per item agent plus one for the holistic agent, all in one response. Collect all returned agent task IDs. Proceed immediately to Phase 3 without waiting for any agent to complete.

### Item Agent Prompt (one per extracted item)

Spawn one `item-reviewer` agent per extracted item using the Task tool with this prompt:

```
Review this {doc_type} item.

## Instructions
Read the item review guide: ~/.claude/skills/review/references/review-item-guide.md
Use the item report template: ~/.claude/skills/review/assets/templates/item-report.md

## Document
**Path**: {doc_path}
**Type**: {doc_type} (Task Spec / Design / Plan)

## Item to Review
{item_text}

## Shared Context
{shared_context}

## Cross-Reference
{cross_ref_excerpts}
```

Replace the placeholders:
- `{doc_type}`: The identified document type (Task Spec, Design, or Plan)
- `{doc_path}`: Full path to the document being reviewed
- `{item_text}`: The full markdown content of this specific item (from boundary start to boundary end)
- `{shared_context}`: The shared context sections extracted in Phase 1.5
- `{cross_ref_excerpts}`: The condensed cross-reference excerpts from Phase 1.7

### Holistic Agent Prompt (exactly one)

Spawn one `holistic-reviewer` agent using the Task tool with this prompt:

```
Review the cross-cutting concerns of this {doc_type} document.

## Instructions
Read the holistic review guide: ~/.claude/skills/review/references/review-holistic-guide.md
Use the holistic report template: ~/.claude/skills/review/assets/templates/holistic-report.md

## Document
**Path**: {doc_path}
**Type**: {doc_type}

## Cross-Reference Documents
{cross_ref_paths}

## Document Template
{template_path}
```

Replace the placeholders:
- `{doc_type}`: The identified document type
- `{doc_path}`: Full path to the document being reviewed
- `{cross_ref_paths}`: List of cross-reference document paths (the holistic agent will read them itself)
- `{template_path}`: Path to the template for this doc type (from the template mapping table in the holistic guide)

After spawning, produce a brief status message (e.g., "Spawned N item agents + holistic agent. Processing as they complete."). This ends the current turn and allows background agent completion notifications to arrive.

---

## Phase 3: Report and Fix (Orchestrator, Sequential)

### 3.1 Process Agents as They Complete

Background agents auto-notify on completion — each notification contains the agent's full result. **Write to the review doc immediately for each notification** using the Edit tool. Do not batch writes or defer them to the end.

For each notification, in the same turn:

1. Extract findings from the notification result
2. Read the review doc (find the item's summary table cell, check history if not R1)
3. Edit the review doc — update summary table cell from `...` to issue counts or `✅`, write the detail entry
4. Brief status to user: "[Item/Step/Task] N: Sound / X issues"

When multiple notifications arrive at once, process all of them in one turn — read, edit, report for each.

Continue until all agents have reported back.

**Do NOT call `TaskOutput`** on agents that already auto-notified — the task is cleaned up after notification. Calling `TaskOutput` on a cleaned-up task returns "No task found" and if called in a parallel batch, cascades failure to all sibling calls.

**For each completed item agent**:

1. **Extract findings**: The item agent returns a report following the item-report template (item name, status, correctness, codebase refs, issues table).
2. **History check**: If the review doc has prior entries for this item (i.e., this is not R1), read that item's detail section and scan prior review entries for matching issues:
   - If a match is found in the **most recent** prior entry: annotate as `[Recurring from RN]`. Read the prior entry's suggested fix text and check the current document state to understand why the fix didn't resolve the issue. Append context to the annotation: `[Recurring from RN -- prior fix: <summary of what was applied>; root cause: <why it persists>]`. This gives the fix-applier visibility into the prior attempt so they can craft a more targeted fix.
   - If a match is found in an **older** entry but not the most recent: annotate as `[Regression from RN]`
   - If no match: leave as-is (new issue)
   - **Matching guidance**: Match on issue description similarity. False negatives are acceptable -- false positives are worse. If unsure, treat as a new issue.
3. **Write to review doc**: Update the item's summary table cell from `...` to issue counts (e.g., `1 HIGH 2 MED`) or `✅` for sound. Write the detail entry with timestamp, command (`review-doc-run`), and issues in `- [SEV] Description -> Suggested fix` format. Include history annotations if present.
4. **Report**: Tell the user which item completed and its status.

**For the completed holistic agent**:

1. **Extract findings**: The holistic agent returns a report following the holistic-report template (status, all cross-cutting check sections, issues table).
2. **History check**: Same logic as item agents but applied to holistic detail entries.
3. **Write to review doc**: Update each concern area's holistic summary table cell from `...` to issue counts or `✅`. Write the holistic detail entry with `- **[Concern]** [SEV] Description -> Suggested fix` format.
4. **Report**: Tell the user holistic review completed and its status.

The orchestrator (main conversation) is the sole editor of the review document. Subagents never edit -- they only report.

### 3.2 Elevation Pass

After all agents have completed and their findings are written to the review doc, perform a single elevation pass.

Scan for issues that appear in both an item agent result AND the holistic agent result. If an issue appears in both:
- Elevate its severity by one level: LOW becomes MED, MED becomes HIGH, HIGH stays HIGH
- This signals that the issue has both per-item and cross-cutting impact

Update the affected entries in the review doc (both the summary table cell counts and the detail entry severity tags).

**Why only elevation**: The old Collect/Deduplicate/Sort/Group merge steps are unnecessary because:
- Item agents review disjoint sections, so there are no cross-item duplicates
- Per-item structure already groups findings by item
- Sort is implicit (items appear in document order)

### 3.3 Set Review Log Entry

After the elevation pass, set the review log entry:
- Timestamp: current ISO 8601 with timezone
- Command: `review-doc-run`
- Mode: `Parallel (N item + 1 holistic)` where N is the number of item agents spawned. Append ` --auto` if the `--auto` flag is active (e.g., `Parallel (10 item + 1 holistic) --auto`)
- Issues: total counts (e.g., `1 HIGH 3 MED`) -- recalculated after elevation
- Status: `Clean` (no issues) or `Pending` (issues found, not yet fixed)

### 3.4 Present Simplified Summary and Apply Fixes

Present a simplified summary to the conversation. The full report is already in the review document.

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
Apply each fix from the findings using Edit tool. Report each fix applied. If a fix cannot be applied (ambiguous target, already correct, or outside document scope), annotate the issue line in the review doc with `[Skipped: reason]` and report the skip to the user. Update the current review entry's Status from `Pending` to `Applied (X of Y)` where X is fixes applied and Y is total issues.

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

### 3.5 Update Review Doc Fix Status

After user-chosen fixes in non-auto mode. Update the review document's Review Log entry for the current review based on what happened in Phase 3.4.

- If user chose "Apply all" or "Pick which": apply selected fixes. For any fix the user explicitly declines, annotate the issue line in the review doc with `[Skipped: user declined]`. For fixes that cannot be applied, annotate with `[Skipped: reason]`. Update Status to `Applied (X of Y)` where X is fixes applied and Y is total issues.
- If user chose "Done": leave Status as `Pending`.
- For `--auto` mode: this phase is a no-op (status already updated in Phase 3.4).
