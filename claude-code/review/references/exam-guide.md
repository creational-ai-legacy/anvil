# Exam Guide (Independent Critical Assessment)

Independent critical examination of design and implementation documents, and real-time monitoring of plan execution. Deeper than automated review — challenges substance, architecture, and what the reviewer missed.

This guide is loaded fresh on each `/exam` or `/monitor` invocation to prevent instruction drift.

---

## Shared Rules

These apply to both Review Mode and Monitor Mode.

1. **Not a rubber stamp.** Give an honest, critical assessment. Surface things the builder session can't see because it's too close to the work.
2. **Never create or edit docs on your own initiative.** Report findings and pause. The user decides next steps.
3. **Can create or edit docs when the user explicitly asks** (e.g., "write this up", "update the doc accordingly").
4. **Never just verify that review fixes were applied.** That's mechanical. Focus on whether fixes resolved the real issue.
5. **Report findings ranked by severity.** Use `HIGH / MED / LOW` (uppercase, abbreviated).

## Anti-Patterns to Flag

- Designing for hypothetical future requirements instead of current needs
- Solving problems in docs that should be solved by writing code and testing
- Review cycles that polish wording without catching real issues
- Complexity that exists to satisfy a pattern rather than solve a problem
- Over-engineering, premature abstraction, dead code paths
- Assumptions baked into the design that weren't validated against real API behavior or codebase reality

---

## Review Mode

Triggered by `/exam <doc-path> [--auto] [notes]`.

Deep-dive examination of a single document, cross-referencing against code, other docs, and automated review findings.

### Input

- **Document path** (required): Single file path
- **`--auto` flag** (optional): Apply all fixes immediately after report without prompting
- **Notes** (optional): Additional context or focus areas

### Argument Parsing

Parse the arguments string to extract:

1. **Document path**: The file path (required)
2. **`--auto` flag**: If present, apply all fixes after report without prompting
3. **Notes**: Any remaining text after path and flag

Strip `--auto` from arguments before processing. Everything else is doc path + optional notes.

Example inputs:
- `docs/core-settings-redesign-plan.md` -- path only, prompt user on fixes
- `docs/core-settings-redesign-plan.md --auto` -- path + auto-fix
- `docs/core-architecture.md check the migration approach` -- path + notes
- `docs/core-poc6-design.md --auto check the naming` -- path + auto-fix + notes

### Document Type Recognition

Identify document type from filename pattern:

#### Design Docs (design skill)

| Pattern | Type | Cross-Reference |
|---------|------|-----------------|
| `*-vision.md` | Vision | None (root document) |
| `*-architecture.md` | Architecture | vision |
| `*-roadmap.md` | Roadmap | architecture, vision |
| `[milestone]-milestone-spec.md` | Milestone Spec | roadmap, architecture |
| `[milestone]-task-spec.md` | Task Spec | milestone-spec |

#### Dev Docs (dev skill)

| Pattern | Type | Cross-Reference |
|---------|------|-----------------|
| `docs/[slug]-design.md` | Task Design | task-spec or milestone-spec |
| `docs/[slug]-plan.md` | Plan | design for same slug |
| `docs/[slug]-results.md` | Results | plan (rarely reviewed) |
| `docs/[milestone]-milestone-summary.md` | Milestone Summary | all task results for milestone |

### Process

#### 1. Read the Review Doc First

Derive the review doc path: strip `.md` from the document path, append `-review.md`. Example: `docs/core-poc6-plan.md` becomes `docs/core-poc6-plan-review.md`.

If it exists, read it. Understand:
- What the automated reviewer found across all review rounds
- What was applied and what's still open
- What issues were recurring or regressed

Purpose: avoid duplicating known issues. Focus on what the reviewer missed, what was partially applied, and what new issues fixes may have introduced.

If no review doc exists, proceed — this is an unreviewed document.

#### 2. Read the Target Document

Read the full document content.

#### 3. Load Cross-References

Based on the doc type (from the tables above), read the cross-reference documents. These provide context for verification.

#### 4. Deep Examination

Go beyond format and structure. Focus on:

- **Substance over format**: Is the approach actually good, or just well-formatted?
- **Architectural challenge**: Is there a simpler way? A risk not considered?
- **Assumption validation**: Are assumptions validated against real API behavior and codebase reality?
- **Gap analysis**: What do the docs say vs what the code actually does?
- **Over-engineering check**: Premature abstraction, dead code paths, unnecessary complexity
- **Cross-document contradictions**: Design vs plan vs task spec vs code
- **Blind spots**: What can the builder not see because they're too close to the work?
- **Review coverage gaps**: What did the automated review miss? What was partially applied? What new issues did fixes introduce?

#### 5. Codebase Verification

Use Glob, Grep, Read to verify:
- Claims made in docs match actual code
- Referenced files and functions exist
- Proposed patterns are compatible with existing code
- Assumptions about existing code are correct

> **Environment-specific verification**: If the project has an environment guide (e.g., `~/.claude/skills/dev/references/unity-guide.md`, `python-guide.md`), consult it for additional verification tools (e.g., Unity MCP for hierarchy/component/wiring checks).

### 6. Write to Review Document

Write exam findings to the persistent review document. This is the same `-review.md` file used by `/review-doc` and `/review-doc-run`. The exam adds E columns alongside R columns in chronological order (R1 → E1 → R2 → E2 → ...).

1. **Derive path**: Strip `.md` from the document path, append `-review.md`. Example: `docs/core-poc6-plan.md` becomes `docs/core-poc6-plan-review.md`.
2. **Read tracking template**: Load `~/.claude/skills/review/assets/templates/review-tracking.md`.
3. **Check if review file exists** (Read):
   - **Does not exist**: Create the full structure -- header table, summary tables with E1 column, all item detail sections with E1 entries, holistic sections with E1 entries, review log with E1 row.
   - **Exists**: Determine exam number N by counting E columns in the item summary table header (count only E columns, not R columns). Add EN column to summary tables, append timestamped entries to each item detail section, append holistic entry, add review log row.
4. **Populate per-item findings**: For each item/step/task, set the summary table cell to issue counts (e.g., `1 HIGH 2 MED`) or `✅` for sound. Write the detail entry with timestamp, command (`exam`), and issues in `- [SEV] Description -> Suggested fix` format. **Important**: When appending a new entry after an existing entry that ends with list items, always insert a blank line before the `**EN**` line.
5. **Populate holistic findings**: Map the examiner's cross-cutting observations (architectural challenge, cross-doc contradictions, blind spots, over-engineering) to the holistic concern areas. Set holistic summary table cells. Write holistic detail entries with `- **[Concern]** [SEV] Description -> Suggested fix` format.
6. **Set review log entry**:
   - Timestamp: current ISO 8601 with timezone
   - Command: `exam`
   - Mode: `Exam`. Append ` --auto` if the `--auto` flag is active.
   - Issues: total counts (e.g., `1 HIGH 3 MED`)
   - Status: `Clean` (no issues) or `Pending` (issues found, not yet fixed)
7. **Write** the review file (full rewrite since summary tables require column addition).

### Output Format

Present findings conversationally in addition to the review doc. The review doc is the persistent record; the conversation gets the full assessment.

```
## Examination: [document name]

| # | Severity | Step/Item | Finding |
|---|----------|-----------|---------|
| E1 | HIGH | [location] | [description] |
| E2 | MED | [location] | [description] |
| E3 | LOW | [location] | [description] |

### Verification Checks
- [x] Review doc read first (RN findings understood)
- [x] Cross-references checked
- [x] Codebase verified
- [ ] [any checks that couldn't be completed]

### Bottom Line
[1-2 sentence honest assessment — is this ready to proceed or does it need rework?]
```

Note: E1, E2, E3 in the conversational output are **finding numbers within this exam round**. In the review doc, the round itself is labeled EN (E1 for first exam, E2 for second exam, etc.) and individual findings use `- [SEV] Description` format, same as R rounds.

### Applying Fixes

**If no issues found**: Report "Sound" and stop.

**If issues found — with `--auto`**: Apply all fixes immediately using Edit tool. Report each fix applied. If a fix cannot be applied (ambiguous target, already correct, or outside document scope), annotate the issue line in the review doc with `[Skipped: reason]` and report the skip to the user. Update the current exam entry's Status from `Pending` to `Applied (X of Y)`.

**If issues found — without `--auto`**: Report findings, then prompt the user:
- Apply all fixes
- Pick which fixes to apply
- Done (no fixes)

### Update Review Doc Fix Status

Update the review document's Review Log entry for the current exam based on what happened.

- If fixes were applied (auto or user-chosen): for any fix the user explicitly declines or that cannot be applied, annotate the issue line in the review doc with `[Skipped: reason]`. Update Status to `Applied (X of Y)` where X is fixes applied and Y is total issues.
- If user chose "Done" or no fixes were applied: leave Status as `Pending`.
- If no issues were found (Status is `Clean`): no update needed.

### Completion Notification

After the exam is fully done (report presented, review doc written, fixes applied or declined), play an audio notification and speak a brief one-line summary. Same format for both `--auto` and non-auto modes.

```bash
afplay /System/Library/Sounds/Glass.aiff && say "Examination completed for [project] [task-slug] [doc-type] doc"
```

Replace placeholders:
- `[project]`: basename of the current working directory (e.g., `anvil`).
- `[doc-type]`: the filename suffix before `.md` matching one of `design`, `plan`, `results`, `vision`, `architecture`, `roadmap`, `milestone-spec`, `task-spec`, `milestone-summary`.
- `[task-slug]`: the filename with `.md`, the `-[doc-type]` suffix, AND the first milestone segment (everything up to and including the first hyphen of the remaining slug) all stripped.
  - Example: `core-settings-redesign-plan.md` → project=`anvil`, task-slug=`settings-redesign`, doc-type=`plan` → "Examination completed for anvil settings-redesign plan doc"
  - Example: `core-review-staggered-auto-design.md` → project=`anvil`, task-slug=`review-staggered-auto`, doc-type=`design` → "Examination completed for anvil review-staggered-auto design doc"
  - If only ONE segment remains after stripping the doc-type suffix (e.g., `mc-vision.md` → `mc`), there is no separate milestone/task split — use that single segment as `[task-slug]` (voiced: "Examination completed for anvil mc vision doc").

---

## Monitor Mode

Triggered by `/monitor <task-slug>`.

Observe active plan execution by periodically reading the results doc. Report status and perform per-step cross-reference analysis as steps complete. Strictly read-only.

### Input

- **Task slug** (required): Derives all doc paths automatically

### Path Derivation

From the task slug, derive:
- `docs/[slug]-plan.md`
- `docs/[slug]-design.md`
- `docs/[slug]-results.md`
- `docs/[slug]-plan-review.md`
- `docs/[slug]-design-review.md`
- `docs/[slug]-expectations.md` (optional)

Verify which paths exist. Report which docs were found and which are missing. Missing docs are not fatal — the examiner works with what's available.

### Process

#### 1. Establish Baseline

Read all existing docs. Build understanding of:
- Total steps in the plan
- Current progress from the results doc (if it exists yet)
- Design decisions and constraints
- Known review findings per step
- Step-to-design-item mapping (from the plan's overview/approach section)

#### 2. Report Initial Status

Use the `monitor-status.md` template. Present the status table showing all steps with their current state.

#### 3. Set Up Timer

```
Bash(run_in_background: true, command: "sleep 120 && echo TIMER")
```

This runs in the background so the user can still chat.

#### 4. On Each Timer Tick

1. Re-read the results doc
2. Report the status table (every tick)
3. For each step that transitioned to Complete since the last check: run per-step analysis
4. Set up the next timer (repeat Step 3)
5. Report observations if anything notable happened

#### 5. Termination

- **All steps complete**: Report final summary, stop monitoring
- **User says stop**: Acknowledge and stop
- **No changes for 3 consecutive checks**: Notify user and ask whether to continue

### Monitor Rules

- **Strictly read-only** — never touch the plan doc, results doc, or any code files
- **Don't interfere** — no suggestions to the executor, no fixes, no edits. Pure observation and reporting.
- **More than checkmarks** — don't just report step status. Read actual source files to verify implementation quality, check that code matches plan spec, and flag anything the results doc doesn't mention.
- **Background timers** — always run timers in background so the user can still chat
- **Conversational, not transactional** — when the user asks a question mid-monitor, answer immediately using the context already loaded. Don't defer to the next tick. The monitor is a live conversation, not a batch report.

### Per-Step Analysis

Triggers when a step transitions to Complete. For pending and in-progress steps, the status table row is sufficient — no deep analysis.

**The analysis format below is a minimum, not a ceiling.** For critical or complex steps, go deeper: break down individual adaptations, verify each against the plan spec, cross-reference prior examiner findings if they exist, and give quantitative quality signals (LOC comparison, dead code check, test coverage). The examiner's value is in the judgment and initiative that mechanical review cannot provide.

Use the `monitor-status.md` template for output format.

#### vs Plan Spec

Does the code match the step's specification and acceptance criteria? Check:
- Were all specification items implemented?
- Were acceptance criteria met?
- Any deviations noted in the results doc? Were they justified?
- Read the actual code changes to verify (don't just trust the results doc)

#### vs Plan Review

Read this step's section in the `-plan-review.md`. For each reviewer finding:

1. **What was flagged**: The reviewer's concern and severity
2. **What was fixed**: How the plan was updated in response
3. **Examiner judgment**: Was the concern substantive or cosmetic? Did the fix resolve the real execution risk or just improve wording? What's the actual impact on the executor?

The examiner adds the judgment the mechanical reviewer cannot — the "so what?" A HIGH finding that prevented a compile error is genuinely critical. A MED finding that rephrased ambiguous wording may or may not have changed executor behavior.

#### vs Design

Which design item maps to this step? (Use the mapping built during baseline.) Check:
- Does the implementation match the design's intent and constraints?
- Were behavioral expectations met?
- Any architectural drift from what the design prescribed?

#### vs Expectations

Only if an expectations doc exists. Check:
- Does the actual code change match the documented before/after?
- Any call sites or behaviors that diverged from expectations?

If no expectations doc exists, omit this section entirely.

#### Verdict

Rate the step: ✅ Clean / ⚠️ Minor concern / ❌ Needs attention

Include a one-sentence summary explaining the verdict.
