# Planning-Design Integration Proposal

## The Core Principle

**Each stage reads the previous stage's output.**

```
Stage 1: Design
  Input:  Bug report / feature spec / user notes
  Output: *-design.md
            ↓
Stage 2: Plan
  Input:  *-design.md ← READS PREVIOUS OUTPUT
  Output: *-plan.md
            ↓
Stage 3: Execute
  Input:  *-plan.md ← READS PREVIOUS OUTPUT
  Output: *-results.md + implementation files
```

---

## What Design Provides vs What Planning Does

| Design (Stage 1) | Planning (Stage 2) |
|------------------|-------------------|
| **WHAT** needs to be done | **HOW** to do it |
| Order and dependencies | Bite-sized steps (small, completable, testable) |
| High-level approach | Actual code snippets |
| Analysis per item | Steps with code + tests together |
| NO CODE | YES CODE |

**Key insight**: One Design item (#1, #2, etc.) typically becomes MULTIPLE Plan steps.

---

## Design Doc Structure (Stage 1 Output)

```
## Analysis (non-sequential)
### 1. [Item Name]
**What**: Description
**Why**: Impact
**Approach**: Technical approach (files, patterns, validation)

## Proposed Sequence
**Order**: #1 → #2 → #3 → #4 → #5

### #1: [Item Name]
**Depends On**: None
**Rationale**: Why first
**Notes**: Optional considerations
```

---

## How Planning Uses Design

### Step 1: Read the Proposed Sequence

Planning reads the Design's Proposed Sequence to understand:
- **Order**: Which items come first
- **Dependencies**: What must be done before what
- **Rationale**: Why this order was chosen

This is the **starting point**, not the final plan.

### Step 2: Verify by Researching the Codebase

Planning MUST research the actual codebase:
- Read the files mentioned in Design's "Files to Modify"
- Understand current implementation
- Verify Design's approach is still valid
- Identify any gaps or additional work needed

**Planning may discover:**
- Design item needs to be split differently
- Additional prerequisites not in Design
- Order needs adjustment based on code dependencies

### Step 3: Break Each Item into Bite-Sized Steps

For each Design item, create multiple Plan steps:

```
Design #1: Async Conversion
  Approach: Add async methods alongside sync versions
  Files: cache_service.py, api/routes.py

       ↓ Planning breaks this into steps ↓

Plan Steps:
  Step 1: Add get_transcript_async() to cache_service.py
          - Code: async def get_transcript_async(...)
          - Tests: test_transcript_async()
          - Verify: pytest tests/test_cache_service.py -v

  Step 2: Add get_metadata_async() to cache_service.py
          - Code: async def get_metadata_async(...)
          - Tests: test_metadata_async()
          - Verify: pytest tests/test_cache_service.py -v

  Step 3: Add get_video_data_async() with parallel fetch
          - Code: asyncio.gather(transcript, metadata)
          - Tests: test_video_data_parallel()
          - Verify: pytest + timing comparison

  Step 4: Update routes.py to await async methods
          - Code: await get_video_data_async(...)
          - Tests: test_routes_async()
          - Verify: pytest tests/test_routes.py -v
```

### Step 4: Each Step Must Be

From the Planning Guide:
- **Bite-sized** - small enough to complete comfortably given previous steps
- **Independently verifiable** (prove it works)
- **Self-contained** (doesn't require other steps to test)
- **Code + tests together** (never separate)

### Step 5: Use Analysis "Approach" for Code Details

Each Design Analysis item has technical details:
- Files to modify
- Patterns to use
- Validation strategy

Planning uses these as the basis for actual code.

### Step 6: Inherit and Expand

| Design Section | How Plan Uses It |
|----------------|------------------|
| **Proposed Sequence** | Guides order, but Planning creates actual steps |
| **Analysis Approach** | Technical details → actual code |
| **Files to Modify** | Starting point, verify against codebase |
| **Success Criteria** | Copy to Plan, add verification commands |
| **Testing Strategy** | Expand into specific test cases per step |
| **Decisions Log** | Respect - don't re-decide |
| **Risks** | Address in implementation |

---

## Example: Design to Plan

**Design (cloud-mcp-ux-design.md):**
```
Proposed Sequence: #1 → #2 → #3 → #4 → #5 → #6

#1: Async Conversion (depends on: none)
#2: MCP Prompts (depends on: #1)
#3: Feedback Tool (depends on: #1)
#4: OpenAPI Schema Sync (depends on: #1)
#5: Desktop Extension (depends on: #2, #3, #4)
#6: Documentation (depends on: all)
```

**Planning Process:**

1. Read Proposed Sequence → understand #1 must come first
2. Research codebase → read cache_service.py, understand current sync methods
3. Break #1 into steps:
   - Step 1: get_transcript_async + tests
   - Step 2: get_metadata_async + tests
   - Step 3: get_video_data_async with parallel fetch + tests
   - Step 4: Update routes.py to await + tests
4. Continue with #2, #3, #4 (can note they're parallelizable after #1)
5. Each step has code + tests + verification command

**Result:**
- Design has 6 items
- Plan might have 15-20 bite-sized steps
- Each step is small, completable, and tested

---

## What This Proposal Does NOT Change

**All existing Planning Guide content is PRESERVED:**

- ✅ Process (prerequisites, steps, verification, code snippets)
- ✅ Code Quality Principles (OOP, Pydantic, Strong Typing)
- ✅ Step Size Guidelines (bite-sized, verifiable, self-contained)
- ✅ Tests Must Be In The Same Step (CRITICAL)
- ✅ Self-Contained Task Requirement
- ✅ Production-Grade Checklist
- ✅ Verification & Testing (pytest preferred, test scope)
- ✅ Common Pitfalls

**This proposal ONLY adds the "From Design to Plan" integration.**

---

## Changes Needed

### 1. SKILL.md - Add Input/Output to Stage 2

```markdown
## Stage 2: Planning

**Input**: `docs/[milestone-slug]-[task-slug]-design.md` from Stage 1
**Output**: `docs/[milestone-slug]-[task-slug]-plan.md`
```

### 2. 2-planning-guide.md - Add "From Design to Plan" Section

```markdown
## From Design to Plan

**Design provides order and approach. Planning provides bite-sized steps.**

### Process

1. **Read Design's Proposed Sequence**
   - Understand order and dependencies
   - Note the rationale for each item's placement

2. **Verify by Researching Codebase**
   - Read files mentioned in Design
   - Verify approach is still valid
   - Identify gaps or additional work

3. **Break Each Item into Steps**
   - Each Design item → multiple Plan steps
   - Each step bite-sized, independently verifiable
   - Code + tests together in each step

4. **Use Analysis Approach for Code**
   - Design's Approach has technical details
   - Planning adds actual code snippets

5. **Respect Decisions Log**
   - Design made choices - don't re-decide
```

### 3. dev-plan.md Command - Design Doc as Input

```markdown
## Input

**First argument (recommended):**
- Design doc path: `docs/[slug]-design.md`
- If provided → read and use as blueprint
- If omitted → plan from scratch (for simple tasks)

**The command will:**
1. Read design doc if provided
2. Verify Proposed Sequence against codebase
3. Break each item into bite-sized steps
4. Add code + tests + verification for each step
```

**Note**: Design doc is recommended but not required. Simple bug fixes or small tasks may skip Stage 1 entirely.

### 4. 2-plan.md Template - Add Design Reference

```markdown
> **Design**: See `docs/[milestone-slug]-[task-slug]-design.md` for analysis and approach.
```

---

## Summary

| Aspect | Design (Stage 1) | Planning (Stage 2) |
|--------|------------------|-------------------|
| Focus | WHAT and WHY | HOW |
| Code | NO | YES |
| Granularity | Items (#1, #2, #3) | Bite-sized steps |
| Sequence | Order with rationale | Verified against codebase |
| Tests | Strategy (high-level) | Specific tests per step |

**The relationship is NOT 1:1 mapping.**

Design item #1 → Plan steps 1, 2, 3, 4
Design item #2 → Plan steps 5, 6, 7
...

---

## Decisions

### Q1: Should we update the Quick Reference table in SKILL.md to show Input→Output flow?

**Answer: Yes** - Add Input column to make the piggyback explicit:

| Stage | Input | Output |
|-------|-------|--------|
| 1. Design | Bug/feature spec | `*-design.md` |
| 2. Planning | `*-design.md` | `*-plan.md` |
| 3. Execution | `*-plan.md` | `*-results.md` + code |

### Q2: Should Plan template have fewer sections (avoid duplication from Design)?

**Answer: Keep sections, add "From Design" note**

Plan template keeps all sections but can note inheritance:
- **Success Criteria**: "From Design, refined with verification commands"
- **Risks & Mitigations**: "From Design, addressed in implementation"
- **Files to Create/Modify**: "From Design, expanded with status"

This allows:
- Plan to work standalone (for simple tasks without Design)
- Plan to build on Design (for complex tasks)

### Q3: Should `/dev-plan` require design doc path as first argument?

**Answer: Recommended, not required**

- If provided → read Design, use as blueprint
- If omitted → plan from scratch (simple tasks, quick fixes)

This preserves flexibility while encouraging the Design→Plan flow.
