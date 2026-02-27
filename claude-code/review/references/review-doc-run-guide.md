# Review Document Guide (Parallel Orchestrator)

Orchestrate a parallel doc review using scatter-gather subagents. This guide is used by `/review-doc-run` in the main conversation. The orchestrator reads the document, extracts items, spawns item + holistic agents in parallel, gathers results, merges findings, and generates the final report.

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

**Item boundary**: Each `### Step N:` implementation block.
- Start: `### Step N:` heading
- End: Next `### Step N+1:` heading, or `## Test Summary` section, or end of document

**Shared context** (same for all items): Extract and concatenate:
- The **Overview** table (from `## Overview` to the next `##`)
- The **Prerequisites** section (from `## Prerequisites` to the next `##`)
- The **Success Criteria** section (from `## Success Criteria` to the next `##`)

**Item count**: Number of `### Step N:` blocks found.

---

### 1.6 Fallback Check

If extraction finds zero items (the document has the right type but no parseable items), fall back to sequential review: follow `~/.claude/skills/review/references/review-doc-guide.md` instead. Stop following this guide.

### 1.7 Prepare Cross-Reference Excerpts

For item agents, prepare condensed cross-reference excerpts. Read the cross-reference documents and extract the sections most relevant to item-level review:

- **Task Spec** cross-refs: From the milestone-spec, extract the milestone overview and relevant task descriptions
- **Task Design** cross-refs: From the task-spec, extract the specific task block that matches this design
- **Plan** cross-refs: From the design, extract the Executive Summary, Constraints, and Proposed Sequence

Keep excerpts concise. The item agents have access to Read and can look up additional details themselves.

---

## Phase 2: Parallel Verification (Subagents)

Spawn all agents in parallel using the Task tool. All agents run concurrently.

### 2.1 Spawn Item Agents

For each extracted item, spawn one `item-reviewer` agent using the Task tool with this prompt:

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

### 2.2 Spawn Holistic Agent

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

### 2.3 Wait for Completion

All Task calls (N item agents + 1 holistic agent) run in parallel. Wait for all to complete before proceeding to Phase 3.

---

## Phase 3: Report and Fix (Orchestrator, Sequential)

### 3.1 Gather Results

Collect the output from each completed agent:
- **Item agent results**: Each returns a report following the item-report template (item name, status, correctness, codebase refs, issues table)
- **Holistic agent result**: Returns a report following the holistic-report template (status, all cross-cutting check sections, issues table)

### 3.2 Merge Findings

Apply these merging rules to combine all agent results into a unified report:

**Step 1 -- Collect**: Gather all issues from all agents into a flat list. For each issue, tag it with its source agent (item name or "Holistic").

**Step 2 -- Deduplicate**: If two agents flag the same location (same section heading or same line range) for the same concern, keep the entry with more detail and the higher severity. Discard the duplicate.

**Step 3 -- Elevate**: If an issue appears in both an item agent result AND the holistic agent result, elevate its severity by one level (LOW becomes MEDIUM, MEDIUM becomes HIGH, HIGH stays HIGH). This signals that the issue has both per-item and cross-cutting impact.

**Step 4 -- Sort**: Sort the merged list by:
1. Severity descending (HIGH first, then MEDIUM, then LOW)
2. Document location (order of appearance in the document)

**Step 5 -- Group**: Map findings to the final report sections:

| Finding Source | Final Report Section |
|----------------|---------------------|
| Holistic: Template Alignment | Template Alignment |
| Holistic: Soundness | Soundness |
| Holistic: Step Flow | Step Flow |
| Holistic: Dependency Chain | Dependency Chain |
| Holistic: Contradictions | (merged into Issues table) |
| Holistic: Clarity & Terminology | Clarity & Terminology |
| Holistic: Surprises | Potential Surprises |
| Holistic: Cross-Reference Alignment | Cross-Reference Check |
| All item agents: Codebase Refs | Codebase Verification (merged, with Item column) |
| All agents: Issues tables | Issues Found (merged, deduplicated) |

### 3.3 Assemble Final Report

Read the final report template at `~/.claude/skills/review/assets/templates/final-report.md`.

Populate each section:

- **Document**: The document path
- **Type**: The identified document type
- **Status**: "Sound" if zero issues, "Issues Found" if any issues exist, "Needs Revision" if any HIGH severity issues
- **Review Mode**: `Parallel (N item + 1 holistic)` where N is the number of item agents spawned
- **Template Alignment**: From holistic report
- **Document Analysis** sections (Soundness, Step Flow, Dependency Chain, Clarity & Terminology, Potential Surprises, Cross-Reference Check): From holistic report
- **Codebase Verification**: Merge all item agents' Codebase Refs tables into one table, adding an **Item** column to identify which item each reference came from
- **Issues Found**: Merged issues table with `**Total**` count line. The **Item** column shows which item agent found the issue (or "Holistic" for cross-cutting findings)
- **Recommendations**: Generate a prioritized list of actionable fixes from the highest-severity issues

### 3.4 Present Report

Display the completed report to the user. The report is always shown regardless of the `--auto` flag.

### 3.5 Apply Fixes (Branch on --auto)

**Default (no `--auto` flag)**: STOP here. The report is the final output. Wait for the user to decide what to do.

**With `--auto` flag**: Immediately apply all fixes from the Issues table:
1. Read each issue's "Suggested Fix" column
2. Apply each fix to the document using Edit tool
3. Report what was changed

The orchestrator (main conversation) is the sole editor of the document. Subagents never edit -- they only report.
