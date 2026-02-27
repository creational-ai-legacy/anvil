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

Each item is a `### Step N:` implementation block. Shared context includes the Overview table, Prerequisites section, and Success Criteria section.

**Checks**:

1. **Specification and Acceptance Criteria present** (Step 1+ only) -- Implementation steps (Step 1 and above) must have both a Specification section and an Acceptance Criteria section. Step 0 is exempt (it is setup/scaffolding and may use inline commands instead). Flag any Step 1+ that is missing either section.

2. **Self-contained** -- The step must be understandable and executable without reading other steps. All necessary context (what to build, what files to modify, what patterns to follow) must be stated within the step. Flag steps that say "as described in Step N" or "following the pattern from the previous step" without restating the relevant details.

3. **Verification commands present** -- The step should include verification commands or describe how to verify the step's output. This may be in a Verification section, in the Acceptance Criteria, or inline. Flag steps that have no way to verify completion.

4. **Trade-offs documented if applicable** -- If the step involves a design decision with multiple viable approaches, a Trade-offs section should document the choice. Not every step needs this -- only flag when there is an obvious decision point (e.g., choosing between two libraries, two architectures, two API designs) with no Trade-offs documentation.

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
