# Review: [Document Name]

| Field | Value |
|-------|-------|
| **Document** | [path] |
| **Type** | [document type] |
| **Created** | [timestamp of first review] |

---

## [Item/Step/Task] Summary

| # | [Item/Step/Task] | R1 |
|---|------------------|----|
| 1 | [Name] | ✅ |
| 2 | [Name] | 1 HIGH 1 MED |

> `...` = In Progress

---

## [Item/Step/Task] Details

### [Item/Step/Task] 1: [Name]
**R1** ([ISO 8601 timestamp], [command]): Sound

### [Item/Step/Task] 2: [Name]
**R1** ([ISO 8601 timestamp], [command]):
- [HIGH] Description -> Suggested fix
- [MED] Description -> Suggested fix

---

## Holistic Summary

| Concern | R1 |
|---------|----|
| Template Alignment | ✅ |
| Soundness | ✅ |
| Flow & Dependencies | ✅ |
| Contradictions | ✅ |
| Clarity & Terminology | ✅ |
| Surprises | ✅ |
| Cross-References | ✅ |

---

## Holistic Details

**R1** ([ISO 8601 timestamp], [command]):
- **[Concern]** [SEV] Description -> Suggested fix

---

## Review Log

| # | Timestamp | Command | Mode | Issues | Status |
|---|-----------|---------|------|--------|--------|
| R1 | [ISO 8601] | [command] | [Sequential / Parallel (N+1)] [--auto] | [counts] | [status] |

---

## Structural Properties

- **First review**: Creates the entire document -- header, summary tables with R1 column, all detail sections with R1 entries, holistic sections with R1 entries, review log with R1 row.
- **Subsequent reviews**: Adds a new column (R2, R3, ...) to summary tables, appends new timestamped entries to each detail section, appends holistic entry, adds review log row.
- **[Item/Step/Task] placeholder**: Substitute based on document type: Design -> Item, Plan -> Step, Task Spec -> Task.
- **Summary table cells**: Show issue counts using severity labels (e.g., `1 HIGH 2 MED`) or `✅` for sound. `...` in summary table cells indicates review is in progress (agent still running). Replaced with issue counts or `✅` when the agent completes.
- **Detail entries**: Timestamped per review. Issues use `- [SEV] Description -> Suggested fix` format. Sound items show single-line "Sound" entry.
- **Recurring/regressed annotations**: Added inline in detail entries (e.g., `[Recurring from R1]`, `[Regression from R2]`). Recurring annotations include prior fix context: `[Recurring from R1 -- prior fix: <summary>; root cause: <why it persists>]`.
- **Skipped fix annotations**: Added inline when a fix is not applied: `[Skipped: reason]`. Common reasons: `user declined`, `already correct`, `ambiguous target`, `outside document scope`.
- **Holistic section**: Same summary/detail pattern as items but organized by concern area.
- **Review Log Status values**: `Clean` (no issues found) / `Pending` (issues found, no fixes applied) / `Applied (X of Y)` (issues found, some/all fixes applied).
- **Split step tracking**: When a step is split into sub-steps (e.g., Step 8 becomes 8a, 8b, 8c) during review round RN: the original Step 8 row in the summary table gets a `split` marker in the RN column; new rows are added for 8a, 8b, 8c with `--` in all prior columns (they did not exist in earlier reviews); the first sub-step's detail section (e.g., 8a) includes a lineage note: `Split from Step 8 in RN`. If Step 8 had findings from prior rounds, the relevant sub-step's reviewer re-evaluates them from context in the current round.
