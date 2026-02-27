# Design Guide (Stage 1)

## Goal

Analyze and design solutions for a task (PoC, Feature, Issue, or Refactor) before implementation planning.

## Code Allowed

NO full implementations. YES to:
- Conceptual code patterns/structure (signatures, not bodies)
- Architecture diagrams (ASCII)
- File/component identification
- Technical approach explanation

## When This Stage Happens

This stage is **user-initiated**:

1. **User discovers new requirement**: "I found an issue/feature we need to handle"
2. **User requests analysis**: "Are there any new features/issues we should address?"

**Important**: This is NOT automatic. Claude should only create a design when explicitly asked by the user.

## Input

- Understanding of current architecture (from implemented work)
- New feature or issue identified
- Existing `docs/[slug]-task-spec.md` (if applicable)

## Key Concept: Two-Section Structure

Stage 1 produces a design document with two distinct sections:

### Part A: Analysis (Non-Sequential)

- Each item gets its own numbered subsection (1, 2, 3...)
- Analyzed independently - no implied order
- Can be read in any sequence
- Format for each item:
  - **What**: Description - what needs to be built/fixed/proven
  - **Why**: Impact and importance
  - **Approach**: How we'll solve it (detailed, but not full code)

### Part B: Proposed Sequence

- Shows recommended order for addressing Analysis items
- Uses item notation (#1 → #2 → #3) not "Step" terminology
- Captures dependency thinking and rationale
- Planning stage will create actual implementation steps from this

## Process

### 1. Establish Context

**Document current state:**
- What components/systems exist today
- How they currently work
- Limitations or issues

**Define target state:**
- Desired end state
- How it should work
- Benefits achieved

**Assign Risk Profile:**

After establishing context, assign a Risk Profile in the Executive Summary table. This value is inherited by downstream stages (Plan, Execute, Review) and determines review depth.

| Level | When to Use | Examples |
|-------|-------------|---------|
| **Critical** | Production systems, money/data/auth flows, hard to rollback | Payment processing, auth changes, data migrations, public API changes |
| **Standard** | Internal tools, non-critical features, reversible changes | Internal skill updates, new optional features, refactoring with tests |
| **Exploratory** | Prototypes, greenfield experiments, throwaway code | PoC spikes, new tool evaluation, experimental features |

Choose the level that best fits the task's blast radius and reversibility. Include a one-sentence justification in the Risk Justification field explaining why this level was chosen.

**Write Constraints:**

After context and Risk Profile, define the hard boundaries for the task in the Constraints section. Constraints are firm limits you design within -- they differ from risks (things that might go wrong) and from scope (what you will build).

**Categories to consider:**
- **Scope boundaries**: What is explicitly out of scope for this task
- **Must NOT happen**: Changes, behaviors, or side effects that are off-limits
- **Compatibility**: Existing interfaces, APIs, or contracts that must not break
- **Performance**: Latency, throughput, or resource limits if applicable
- **Other guardrails**: Any additional hard constraints (regulatory, team policy, etc.)

Not every category will apply to every task. Include the ones that are relevant and remove the rest. If a task genuinely has no constraints beyond the default "don't break existing tests," note that explicitly rather than leaving the section empty.

### 2. Analyze (Non-Sequential)

For each distinct item to address (feature component, issue, proof point, etc.):

**Create a numbered subsection with:**
- **What**: Clear description - what needs to be built/fixed/proven
- **Why**: Why it matters (impact, importance)
- **Approach**: How we'll solve it - detailed technical approach

**Approach should include** (as relevant):
- Technical patterns/techniques to use
- Architecture or flow diagrams (ASCII)
- Files/components to modify or create
- Implementation options with trade-offs (if multiple approaches exist)
- Validation strategy (how to verify it works)
- Conceptual code structure (signatures, patterns - not full implementations)

**Implementation Options:** For each Analysis item where multiple viable approaches exist, include an Implementation Options comparison (pros/cons/recommendation) within that item's Approach. This is a standard part of thorough analysis -- not reserved for the task overall.

**Guidelines:**
- Each item is independent - no implied order
- Don't reference "first we do X, then Y" - that's for Proposed Sequence
- Focus on understanding before sequencing
- Include all items, even small ones
- Be detailed - this drives the implementation plan

**Example (shown in Python; adapt patterns to project language):**
```markdown
### 2. Blocking Sync Calls

**What**: Current service methods are synchronous, blocking the event loop.

**Why**: Slower response times, can't handle concurrent requests efficiently.

**Approach**:
Use `asyncio.to_thread()` to wrap blocking yt-dlp and API calls.
Add async methods alongside sync versions for backwards compatibility.
Enable parallel fetch via `asyncio.gather()`.

Files to modify:
- `cache_service.py` - add `get_transcript_async`, `get_metadata_async`, `get_video_data_async`
- `routes.py` - update routes to await async methods

Pattern:
```python
async def get_transcript_async(self, video_id: str) -> CacheResult:
    # Check cache (sync, fast)
    # Run blocking extractor in thread pool
    return await asyncio.to_thread(self.extractor.extract, video_id)
```

Validate: `get_video_data` completes faster than sequential (parallel fetch working)
```

### 3. Define Proposed Sequence

After analyzing all items, define the recommended order with dedicated reasoning for each item's placement.

**Structure:**
- Start with the overall order: `#1 → #2 → #3 → #4`
- Give each item its own subsection
- For each, explain: dependencies and rationale for placement

**Guidelines:**
- Use item numbers (#1, #2) not "Step" terminology
- Focus on dependencies and logical flow
- Explain the reasoning - don't just list the order
- Planning stage will create actual implementation steps from this

**Example:**
```markdown
## Proposed Sequence

**Order**: #1 → #2 → #3 → #4

### #1: Template Rename

**Depends On**: None

**Rationale**: Template is the foundation - all other files reference it.

---

### #2: Guide Update

**Depends On**: #1

**Rationale**: Guide references template paths and structure. Must reflect new template first.

---

### #3: Command Update

**Depends On**: #1, #2

**Rationale**: Command references guide for process details.

---

### #4: Verification

**Depends On**: #1, #2, #3

**Rationale**: Can only verify all changes work together after everything is updated.
```

### 4. Ensure Self-Contained Scope

**Critical**: Task must be self-contained — works independently, no breaking changes, safe to pause after completion.

**Strategy**: Add alongside, don't replace. New functions/classes alongside existing ones rather than modifying them.

### 5. Document Decisions

**Capture key decisions:**
- What was decided
- Why that choice was made
- What alternatives were considered

Use the Decisions Log table in the template.

### 6. Update Plan (If Applicable)

**If this task relates to a task spec:**
- Add new tasks to `docs/[slug]-task-spec.md`
- **DO NOT renumber existing items** - just add new sequential numbers
- Update dependency graph
- Verify dependencies still make sense

## Output

**Design document**: `docs/[milestone-slug]-[task-slug]-design.md` using `assets/templates/1-design.md`

**Created timestamp**: Use ISO 8601 with timezone (e.g., `2024-01-08T22:45:00-0800`). Run `date "+%Y-%m-%dT%H:%M:%S%z"` to get current timestamp.

**Required sections:**
- Executive summary (challenge + solution one-liners, includes Risk Profile and Risk Justification)
- Context (current state, target state - include architecture diagrams)
- Constraints (hard boundaries -- scope, must-not-happen, compatibility, guardrails)
- Analysis (non-sequential, each item independently with detailed approach)
- Implementation Options (when any design decision has multiple viable approaches; omit only if genuinely no alternatives exist)
- Proposed Sequence (item order with rationale - e.g., `#1 → #2 → #3 → #4`)
- Success criteria
- Risks and mitigations
- Open questions
- Decisions log

**Optional sections** (include when relevant):
- **Files to Modify** - table with file paths, change type, complexity
- **Testing Strategy** - unit tests, integration tests, manual validation

**Examples**: `docs/core-poc6-design.md`, `docs/cloud-auth-fix-design.md`

## Verification Checklist

- [ ] Design document created with all sections
- [ ] Risk Profile assigned in Executive Summary (Critical / Standard / Exploratory)
- [ ] Risk Justification present (one sentence explaining why this level)
- [ ] Constraints section present with relevant categories (or explicitly noted as none)
- [ ] Current and target state clearly defined
- [ ] Each item analyzed with What/Why/Approach
- [ ] Analysis items are independent (no sequencing in Analysis)
- [ ] Implementation Options section present (or explicitly noted as not applicable when no alternatives exist)
- [ ] Proposed Sequence shows item order (#1 → #2 → ...)
- [ ] Sequence rationale explains dependencies
- [ ] Task is self-contained (works independently, doesn't break existing functionality/tests)
- [ ] Risks identified with mitigations
- [ ] Design decisions documented
- [ ] No full code implementations (concepts and patterns OK)

## Common Pitfalls

- **Mixing analysis with sequencing**: Keep Analysis non-sequential; sequence goes in Proposed Sequence
- **Using "Step" terminology**: Design uses item numbers (#1, #2); "Steps" are for Planning stage
- **Writing full implementations**: Stage 1 allows patterns/structure, not complete function bodies
- **Too sparse on approach**: Include files, patterns, validation - design drives the plan
- **Breaking changes**: Use "add alongside" strategy, not "replace"
- **Vague items**: Be specific about What and Why for each item
- **Listing multiple tasks**: Design is for a single task only

## Next Stage

→ Stage 2: Planning (use `references/2-planning-guide.md`)

User should review design, run `/review-doc`, fix issues, then request Stage 2.
