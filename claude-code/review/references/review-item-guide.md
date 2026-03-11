# Item Review Guide

Review a single document item for correctness, completeness, and codebase alignment. This guide is used by the `item-reviewer` agent, which reviews one item at a time in the parallel doc review workflow.

## Scope

This guide covers **per-item checks only**. Cross-cutting checks (template alignment, soundness, step flow, dependency chain, contradictions, clarity, terminology, surprises, cross-reference alignment) belong in the holistic review guide and are NOT your responsibility.

## Input

The orchestrator provides:

- **Document path** and **document type** (Task Spec, Design, or Plan)
- **Item text** (the full markdown block for this item)
- **Shared context** (relevant surrounding sections -- varies by doc type)
- **Cross-reference excerpts** (content from parent/sibling documents)

## Per-Item Checks by Document Type

Run the checks for the matching doc type. Each check produces a pass/fail with a one-sentence rationale.

---

### Task Spec Items

Each item is a `### Task: [Name]` block. Shared context includes the Milestone Overview and Task Dependency Diagram.

**Checks**:

1. **Type field valid** -- The `Type` field must be one of: PoC, Feature, Issue, Refactor. Flag if missing or if the value is not one of these four.

2. **Validates field meaningful** -- The `Validates` field must describe what this task proves or delivers. Flag if it is vague (e.g., "validates the thing"), empty, or just repeats the task name.

3. **Unlocks references valid** -- The `Unlocks` field lists tasks that depend on this one. Each referenced task must exist elsewhere in the task spec. Use Grep to search the document for each task name. Flag any reference to a task that does not appear as its own `### Task:` block.

4. **Success Criteria specific** -- Each success criterion must be concrete and verifiable. Flag criteria that use vague language ("works well", "is good", "properly handles") without specifying what "well" or "properly" means. Good criteria state observable outcomes.

5. **Lessons applied concrete** -- If the task has a Lessons Applied section, each lesson must be actionable (states what to do or avoid). Flag lessons that are abstract observations without guidance (e.g., "testing is important" vs "run integration tests before deploying").

---

### Design Items

Each item is a `### N. [Name]` analysis block. Shared context includes the Executive Summary, Constraints section, and Target State section.

**Checks**:

1. **Has What/Why/Approach structure** -- The item must have clearly identifiable What, Why, and Approach content (these may be explicit sub-headers or recognizable paragraphs). Flag if any of the three is missing.

2. **Approach technically sound** -- The proposed approach must be feasible given the constraints and target state. Read the approach and assess whether it would actually work. Flag approaches that contradict known technical limitations, ignore stated constraints, or propose something infeasible. Use codebase verification (below) to check if referenced patterns actually exist.

3. **No full implementation code** -- Design items should describe patterns, signatures, and structure -- not contain full implementation code blocks. Inline code references, type signatures, and short snippets illustrating a pattern are acceptable. Flag items that contain complete function bodies, full class implementations, or copy-paste-ready code blocks (more than ~15 lines of executable code).

4. **File/API references exist** -- If the item references specific files, directories, classes, functions, or API endpoints, verify they exist in the codebase using Glob, Grep, and Read. For new files proposed by the design, verify the parent directory exists. Flag references that point to nonexistent locations.

5. **Internal consistency** -- The item's content must not contradict itself. Check that the What, Why, and Approach sections align with each other. Flag if the Approach solves a different problem than What describes, or if Why gives a rationale that does not match What.

---

### Plan Items

Each item is a `### Step N:` (or `### Step Na:`) implementation block. Shared context includes the Overview table, Prerequisites section, and Success Criteria section.

**Checks**:

1. **Specification and Acceptance Criteria present** (Step 1+ only) -- Implementation steps (Step 1 and above) must have both a Specification section and an Acceptance Criteria section. Step 0 is exempt (it is setup/scaffolding and may use inline commands instead). Flag any Step 1+ that is missing either section.

2. **Self-contained** -- The step must be understandable and executable without reading other steps. All necessary context (what to build, what files to modify, what patterns to follow) must be stated within the step. Flag steps that say "as described in Step N" or "following the pattern from the previous step" without restating the relevant details.

3. **Verification commands present** -- The step should include verification commands or describe how to verify the step's output. This may be in a Verification section, in the Acceptance Criteria, or inline. Flag steps that have no way to verify completion.

4. **Trade-offs documented if applicable** -- If the step involves a design decision with multiple viable approaches, a Trade-offs section should document the choice. Not every step needs this -- only flag when there is an obvious decision point (e.g., choosing between two libraries, two architectures, two API designs) with no Trade-offs documentation.

5. **Step scope manageable** (Step 1+ only) -- The step should be focused enough that a single executor can implement and verify it in one pass. Step 0 is exempt (setup/scaffolding steps are inherently varied in scope).

   **When to split -- decision logic** (evaluate in order):

   The primary signal is **low cohesion**, not size alone. A step with 10 tightly-related specification items (e.g., 10 properties on a single model class) is fine. A step with 6 items covering 3 unrelated concerns should be split. Evaluate cohesion first, then use size as an amplifier.

   1. **Does the step mix multiple unrelated concerns?** -- The strongest split signal. Look for specification items that serve different purposes bundled into one step (e.g., "create data model" + "add API endpoint" + "write migration script" + "update CLI output"). If yes, flag for split.

   2. **Does the step have multiple independent deliverables?** -- If the step produces several outputs that don't depend on each other (e.g., "add 3 new commands" where each command is self-contained), each deliverable could be its own sub-step. If yes, flag for split.

   3. **Can the step be verified with a single focused test target?** -- If the Verification section requires running tests across multiple unrelated modules or test files, the step may be covering too much ground. If verification naturally breaks into separate test commands for separate concerns, that is a split signal.

   4. **Is the step large AND unfocused?** -- Size amplifies the problem. Use these thresholds as supporting indicators (not standalone triggers):
      - More than ~8 specification bullet points
      - More than ~5 acceptance criteria
      - More than ~5 files to create/modify

      Large + unfocused = split. Large + focused = OK.

   **NOT a split signal:**
   - A step with many specification items that are all tightly related (e.g., implementing one class with many methods that form a single interface)
   - A step with many acceptance criteria that all verify different aspects of the same feature
   - A step that touches many files but for the same reason (e.g., adding the same import to 6 files)

   **How to split -- splitting strategy:**

   When the check determines a split is warranted, identify natural boundaries and produce a concrete split proposal using one of these strategies:

   | Strategy | When to Use | Example |
   |----------|------------|---------|
   | **By concern** | Step mixes unrelated responsibilities | Model layer -> 8a, API endpoints -> 8b, migration -> 8c |
   | **By layer** | Step spans multiple architectural layers | Data access -> 8a, business logic -> 8b, presentation -> 8c |
   | **By deliverable** | Step produces multiple independent outputs | Command A -> 8a, Command B -> 8b, Command C -> 8c |
   | **By dependency** | Some items within the step must happen before others | Schema changes -> 8a, code that uses new schema -> 8b |

   **Suggested fix format:**

   ```
   [MED] Step 8 specification covers 12 items across 3 unrelated concerns (model, API, migration).
   -> Split by concern into 3 sub-steps:
      - Step 8a: Data Model (spec items 1-4, acceptance criteria 1-2)
      - Step 8b: API Endpoints (spec items 5-8, acceptance criteria 3-5)
      - Step 8c: Migration + Cleanup (spec items 9-12, acceptance criteria 6-7)
      Each sub-step gets its own Specification, Acceptance Criteria, and Verification from the original.
      Order: 8a -> 8b -> 8c (8b depends on model from 8a).
   ```

   The suggested fix must include: the splitting strategy used, what content goes in each sub-step (by reference to original spec item numbers or descriptions), and the sub-step ordering with dependency rationale.

---

## Codebase Verification

For every file, directory, class, function, or API reference found in the item:

1. **Use Glob** to check if referenced file paths or patterns exist
2. **Use Grep** to search for referenced function names, class names, or identifiers
3. **Use Read** to inspect file contents when deeper verification is needed (e.g., confirming a function signature matches what the item describes)

Record each reference in the Codebase Refs table of your report:

| Reference | Exists | Notes |
|-----------|--------|-------|
| `src/models/user.py` | Yes | Contains User class as described |
| `config/settings.yaml` | No | Parent directory exists but file not found |
| `NetworkRegistry.register()` | Yes | Found in src/registry.py line 45 |

**For new files proposed by the design/plan**: Verify the parent directory exists. The file itself is expected to not exist yet -- that is not an issue.

**For function/class references**: Search with Grep. If the reference is to something that will be created in a future step, note "To be created" rather than flagging it as missing.

## Output Format

Produce your report using the item report template at `~/.claude/skills/review/assets/templates/item-report.md`.

Fill in:
- **Item name**: From the item header
- **Status**: "Pass" if no issues found, "Issues Found" if any issues
- **Correctness**: Summary of whether the item is technically sound and complete
- **Codebase Refs**: Table of all verified references
- **Issues**: Table of all issues found, with severity (HIGH/MED/LOW), location within the item, description, and suggested fix

### Severity Guidelines

- **HIGH**: Incorrect information, missing critical section, reference to nonexistent codebase artifact that should exist, approach that would not work
- **MED**: Vague or ambiguous content that could lead to misinterpretation, missing optional section that would add clarity, reference verification inconclusive
- **LOW**: Minor style issues, suggestions for improvement, optional enhancements
