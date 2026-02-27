# Holistic Review Guide

Review a document for cross-cutting concerns that span multiple items or affect the document as a whole. This guide is used by the `holistic-reviewer` agent, which reviews the entire document in the parallel doc review workflow.

## Scope

This guide covers **cross-cutting checks only**. Per-item correctness checks (individual task fields, design item feasibility, plan step completeness) belong in the item review guide and are NOT your responsibility.

## Input

The orchestrator provides:

- **Document path** and **document type** (Vision, Architecture, Roadmap, Milestone Spec, Task Spec, Task Design, Plan, Results)
- **Full document text** (the complete document content)
- **Cross-reference documents** (full content of parent/sibling documents)

---

## Cross-Cutting Checks

Run all checks below in order. Each check produces a pass/fail with a short rationale.

---

### 1. Template Alignment

Each document type has a corresponding template. Verify the document follows its template structure.

**Document Type to Template Mapping**:

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

**Check**:
- Read the template for the identified document type
- Verify all required sections are present in the document
- Verify section order matches the template
- Flag missing fields or sections
- Note any extra sections not in the template (these are acceptable but worth noting)

---

### 2. Soundness

Assess whether the overall approach is coherent and feasible.

**Check**:
- Overall approach coherent -- does the document tell a consistent story from beginning to end?
- No logical flaws -- does the reasoning hold up? Are conclusions supported by the analysis?
- Realistic scope -- is what the document proposes achievable given stated constraints and timeline?
- Assumptions clearly stated -- are there hidden assumptions that should be made explicit?

---

### 3. Step Flow

For documents with steps, phases, or sequential sections (Plans, Roadmaps, some Designs with Proposed Sequence).

**Check**:
- Logical ordering -- are steps in the right sequence? Could any be reordered for clarity?
- Smooth transitions -- does each step naturally lead to the next?
- Complete before moving on -- does each step finish what it starts, or are there loose ends carried forward?

If the document has no sequential structure, note "N/A -- document has no step-based structure" and move on.

---

### 4. Dependency Chain

For documents with steps or phases, verify the producer-consumer chain.

**Check**:
- Each step produces what the next step needs -- trace outputs from each step to inputs of the next
- No circular dependencies -- step A depends on B depends on A
- No unused outputs -- a step produces something that no subsequent step uses (waste or missing connection)
- Flag: step uses something not yet created by a prior step
- Flag: step creates something never referenced by any subsequent step

Record findings in the Dependency Chain table:

| From | Produces | To | Needs | Status |
|------|----------|----|-------|--------|

If the document has no step-based structure, note "N/A" and move on.

---

### 5. Contradictions

Search for conflicting statements within the document and with cross-referenced documents.

**Check**:
- **Within document**: Conflicting statements (e.g., overview says X, a later section says not-X)
- **With cross-references**: Misaligned definitions, scope differences, or conflicting requirements between this document and its parent/sibling docs
- **Terminology**: Same concept referred to by different names, or same name used for different concepts
- **Success criteria vs implementation**: Success criteria that contradict the implementation approach

Record findings in the Contradictions table:

| Location A | Location B | Contradiction | Severity |
|------------|------------|---------------|----------|

---

### 6. Clarity & Terminology

Verify the document uses precise language and consistent terminology.

**Clarity checks**:
- No vague language -- flag phrases like "should probably", "might need", "could potentially", "works well", "properly handles" without defining what these mean
- Specific examples where needed -- are abstract descriptions backed by concrete examples?
- Consistent terminology -- is the same concept always called the same thing?
- No missing context -- does the document assume knowledge that is not stated or referenced?

**Terminology rules** (critical for Design and Plan docs):
- **Task** = a unit of work (PoC, Feature, Issue, Refactor) -- each task gets its own Design
- **Analysis** = non-sequential section analyzing each item independently (numbered 1, 2, 3...)
- **Proposed Sequence** = item order with rationale (#1, #2, #3) -- NOT "Steps"
- **Step** = implementation sub-unit -- used ONLY in Planning stage, not Design

**Terminology flags**:
- Flag if a Design doc uses "Step 1, Step 2" terminology (should use #1, #2 item notation)
- Flag if a Design doc lists multiple tasks ("Task 1, Task 2" or "Phase 1, Phase 2") -- each task gets its own Design
- Flag if an Analysis section implies sequential ordering (that belongs in the Proposed Sequence section)

---

### 7. Hunt for Surprises

Look for hidden risks, unstated assumptions, and edge cases.

**Check**:
- **Hidden dependencies**: Assumes something exists that is not explicitly created or referenced
- **External dependencies**: APIs, services, credentials, or third-party tools that might not be available
- **Environment assumptions**: Tools, versions, permissions, or configurations assumed but not checked
- **Edge cases**: What could go wrong that is not addressed? What happens if a step fails?
- **Missing error handling**: Are failure modes considered? Is there a recovery path?

Rate each surprise as High/Med/Low severity.

---

### 8. Cross-Reference Alignment

Verify the document aligns with its parent and sibling documents.

**Check**:
- Read the cross-reference documents provided by the orchestrator
- Verify scope alignment -- does this document stay within the scope defined by its parent?
- Verify terminology alignment -- are the same terms used consistently across documents?
- Verify requirement coverage -- does this document address all relevant requirements from the parent?
- Flag any conflicts between this document and its cross-references

Record findings as a checklist:
- `[x]` Aligned with [parent doc]: [brief detail]
- `[!]` Conflict found with [doc]: [description]

---

## Type-Specific Checks

In addition to the universal cross-cutting checks above, apply these checks based on document type.

### Design Docs (Vision, Architecture, Roadmap, Milestone Spec, Task Spec)

- Vision alignment with parent docs
- Scope consistency across sections
- Terminology consistency throughout
- Feasibility of proposed approach

### Task Design (NO CODE -- design only)

- Alignment with task-spec or milestone design
- Clear challenge statement
- Defined success criteria
- Reasonable scope
- **Approach is sound** -- makes technical sense
- **Approach is incremental** -- builds on existing code, does not require big-bang rewrites
- **No full code in document** -- this is design phase only (patterns/signatures OK)
- **Single task only** -- Design should not list "Task 1, Task 2, Task 3" (each task gets its own design)
- **Analysis is non-sequential** -- Each item (1, 2, 3...) analyzed independently
- **Proposed Sequence uses item notation** -- #1, #2, #3 (NOT "Step 1, Step 2")
- **Proposed Sequence has per-item reasoning** -- Each item has Depends On, Rationale, and optional Notes
- **Risk Profile present** -- Executive Summary has Risk Profile with valid level: Critical, Standard, or Exploratory
- **Risk Justification present** -- Executive Summary has Risk Justification as one sentence explaining why this level
- **Constraints section present** -- H2 section between Context and Analysis (or explicitly noted as "No constraints identified")
- **Implementation Options included** -- Section present when any design decision has multiple viable approaches (omit only if genuinely no alternatives exist)

### Plan

- Steps follow design's Proposed Sequence
- Dependency chain complete (each step sets up the next)
- Self-contained steps (specification + acceptance criteria together in each step)
- No missing prerequisites
- Each implementation step (Step 1+) has Specification and Acceptance Criteria sections
- **Contract framing note present** at top of Implementation Steps section
- **Step 0 and Prerequisites retain concrete commands** and setup instructions
- Optional Trade-offs field present for anticipated decisions

### Results (rarely reviewed)

- Accurate status for each step
- Consistent with the plan document
- Test results present for completed steps

---

## Output Format

Produce your report using the holistic report template at `~/.claude/skills/review/assets/templates/holistic-report.md`.

Fill in:
- **Status**: "Pass" if no issues found, "Issues Found" if any issues
- **Template Alignment**: Summary of template conformance
- **Soundness**: Assessment of overall coherence and feasibility
- **Step Flow**: Assessment of ordering and transitions (or N/A)
- **Dependency Chain**: Table of producer-consumer relationships (or N/A)
- **Contradictions**: Table of any conflicts found
- **Clarity & Terminology**: Assessment of language precision and consistency
- **Surprises**: List of hidden risks and edge cases
- **Cross-Reference Alignment**: Checklist of alignment with parent/sibling docs
- **Issues**: Table of all issues found, with severity (HIGH/MEDIUM/LOW), location, description, and suggested fix

### Severity Guidelines

- **HIGH**: Template section missing entirely, circular dependency, direct contradiction between document and cross-reference, terminology that would cause misimplementation
- **MEDIUM**: Vague language in critical sections, missing optional template section, unstated assumption that could cause problems, terminology inconsistency
- **LOW**: Minor ordering suggestions, style improvements, optional enhancements, extra sections beyond template
