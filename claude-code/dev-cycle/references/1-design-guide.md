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
- Existing `docs/[slug]-poc-design.md` (if applicable)

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

**Guidelines:**
- Each item is independent - no implied order
- Don't reference "first we do X, then Y" - that's for Proposed Sequence
- Focus on understanding before sequencing
- Include all items, even small ones
- Be detailed - this drives the implementation plan

**Example (simple):**
```markdown
### 1. Misleading Document Name

**What**: "Overview" suggests a summary, but Stage 1 is core design work.

**Why**: Users may skip or undervalue Stage 1, thinking it's optional.

**Approach**: Rename from "overview" to "design" throughout all files.
- Files: template (overview.md → design.md), guide, command, SKILL.md
- Validate: All references updated, no broken links
```

**Example (complex):**
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
- Start with the overall order: `#1 → #2 → #3 → #4 → #5`
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

**Critical requirement**: This task must be self-contained and **production-grade**

**Why self-contained matters:**
- Task is complete within its scope (works independently)
- System remains functional after this task (no breaking changes)
- Prevents cascading failures
- Safe to pause work after task completion

**Strategy: Add Alongside, Don't Replace**

When new capability could break existing code, add new functions/classes alongside existing ones rather than modifying them.

### 5. Document Decisions

**Capture key decisions:**
- What was decided
- Why that choice was made
- What alternatives were considered

Use the Decisions Log table in the template.

### 6. Update Plan (If Applicable)

**If this task relates to a PoC plan:**
- Add new tasks to `docs/[slug]-poc-design.md`
- **DO NOT renumber existing items** - just add new sequential numbers
- Update dependency graph
- Verify dependencies still make sense

## Output

**Design document**: `docs/[milestone-slug]-[task-slug]-design.md` using `assets/templates/1-design.md`

**Created timestamp**: Use ISO 8601 with timezone (e.g., `2024-01-08T22:45:00-08:00`). Run `date "+%Y-%m-%dT%H:%M:%S%z"` to get current timestamp.

**Required sections:**
- Executive summary (challenge + solution one-liners)
- Context (current state, target state - include architecture diagrams)
- Analysis (non-sequential, each item independently with detailed approach)
- Proposed Sequence (item order with rationale - e.g., #1 → #2 → #3)
- Success criteria
- Risks and mitigations
- Open questions
- Decisions log

**Optional sections** (include when relevant):
- **Implementation Options** - when multiple approaches exist for key decisions (pros/cons, recommendation)
- **Files to Modify** - table with file paths, change type, complexity
- **Testing Strategy** - unit tests, integration tests, manual validation

**Examples**: `docs/core-poc6-design.md`, `docs/cloud-auth-fix-design.md`

## Verification Checklist

- [ ] Design document created with all sections
- [ ] Current and target state clearly defined
- [ ] Each item analyzed with What/Why/Approach
- [ ] Analysis items are independent (no sequencing in Analysis)
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

User should review design, run `/verify-doc`, fix issues, then request Stage 2.
