# Review Guide (Stage 3b)

## Purpose

Tests catch functional errors — "does the code work?" Review catches conceptual errors — "does the code match what we intended to build?"

AI-generated code passes tests reliably. But it introduces a different class of errors than human code: wrong assumptions baked in silently, trade-offs made without surfacing them, architectural drift from the design, and over-engineering that adds complexity without value. The review gate exists to catch these before they compound across steps.

## The 5 Checks

### 1. Intent Match

Does the implementation match the design doc's **intent**, not just its letter?

**What to look for:**
- The design says "lazy loading" but the code eagerly loads everything
- The design describes a simple pipeline but the code implements a plugin system
- The design says "use existing auth" but the code rolls its own

**How to check:** Read the design doc's approach section for the relevant item. Compare the *spirit* of the approach against the actual implementation. Code that technically satisfies requirements but goes about it in a fundamentally different way is a flag.

**Not a flag:** Minor implementation details the design didn't specify (variable names, helper methods, defensive error handling).

### 2. Assumption Audit

Did the agent introduce assumptions not present in the design?

**What to look for:**
- Implementation assumes single-tenant when the design doesn't specify tenancy model
- Code hardcodes a specific database when the design says "persistent storage"
- Implementation assumes synchronous processing when the design is silent on concurrency

**How to check:** Read through the implementation looking for decisions that go beyond what the design specified. Every assumption the code makes should either be (a) in the design doc, (b) in the Trade-offs & Decisions section, or (c) so obvious it doesn't need stating.

**Not a flag:** Reasonable defaults for things the design intentionally left open (e.g., choosing a sensible buffer size).

### 3. Silent Trade-offs

Are there decisions the agent made without surfacing them in the Trade-offs & Decisions section?

**What to look for:**
- Trade-offs section says "no significant trade-offs" but the code chose SQLite over PostgreSQL
- Code uses a polling pattern instead of webhooks with no mention of why
- Implementation skips validation that the design implied should exist

**How to check:** Cross-reference the Trade-offs & Decisions section against the actual code. Every meaningful choice in the code should have a corresponding entry. If the section is empty or says "straightforward implementation," verify that claim by reading the code.

**Not a flag:** Truly straightforward implementation choices that match the plan's code snippets exactly.

### 4. Complexity Proportionality

Does the solution's complexity match the problem's complexity?

**What to look for:**
- 3 abstract classes for 1 concrete implementation
- Plan specified 2 files, step created 5
- Configuration system for something that will never be reconfigured
- Wrapper classes that just delegate to another class
- Generalized solution for a specific problem

**How to check:** Count files created vs. files the plan specified. Look for abstractions with only one implementation. Ask: "Could this be done with fewer moving parts and still work?" If yes, flag it.

**Not a flag:** Reasonable structure that follows project conventions even if slightly more than minimal.

### 5. Architectural Drift

Does the code structure diverge from the architecture doc?

**What to look for:**
- Design specifies repository pattern, implementation uses active record
- Design shows a specific module structure, code puts things in different places
- Design says "extend existing service," code creates a new one
- Import patterns that violate the intended dependency direction

**How to check:** Compare the plan's Architecture/File Structure section against actual file locations and patterns. Look at how the new code integrates with existing code — does it follow the same patterns?

**Not a flag:** Minor structural differences that don't change the dependency graph or overall architecture.

---

## Review Depth by Risk Profile

Read the Risk Profile from the plan doc's Overview table.

| Check | Critical | Standard | Exploratory |
|-------|----------|----------|-------------|
| 1. Intent match | Mandatory | Mandatory | Skip |
| 2. Assumption audit | Mandatory | Mandatory | Skip |
| 3. Silent trade-offs | Mandatory | Skip | Skip |
| 4. Complexity proportionality | Mandatory | Skip | Skip |
| 5. Architectural drift | Mandatory | Mandatory | Mandatory |

**Critical**: All 5 checks. Every flag matters.
**Standard**: Checks 1, 2, 5. Focus on "did we build the right thing" and "does it fit."
**Exploratory**: Check 5 only. Advisory — log findings in results.md but don't trigger the fix loop.

---

## How to Read Code for Review

1. **Start with git diff** — `git diff` or `git diff HEAD~1` shows exactly what changed in this step. This is your primary input.
2. **Read modified files in full** — The diff shows changes; full files show context. Does the new code fit with what's around it?
3. **Cross-reference the design doc** — Not the plan (which is "how"), but the design (which is "what and why"). The design's Approach section for the relevant item is your anchor.
4. **Read the Trade-offs & Decisions section** — This is the executor's self-report. Check it for completeness and honesty.

---

## What Constitutes a Flag

A flag means: "This needs to be addressed before proceeding to the next step."

**Examples of valid flags:**
- Intent match: "Design says lazy loading, implementation uses eager loading with no justification in trade-offs section"
- Assumption audit: "Implementation assumes single-tenant, design doesn't specify tenancy model"
- Silent trade-offs: "Trade-offs section says 'no significant trade-offs' but implementation chose SQLite over PostgreSQL"
- Complexity: "3 abstract classes for 1 concrete implementation. Plan specified 2 files, step created 5."
- Drift: "Design specifies repository pattern, implementation uses active record"

**Examples of things that are NOT flags:**
- Variable naming differences from the plan's examples
- Minor refactors that improve readability
- Adding defensive error handling the design didn't mention
- Using a slightly different but equivalent data structure
- Import ordering or code formatting differences

The threshold: would this matter in a code review between two experienced developers? If a senior dev would flag it in a PR review, it's a flag here. If they'd approve with a "nit" comment, it's not.

---

## Output Format

Write the review section into the step block in results.md:

```markdown
**Review**: ✅ Pass / ⚠️ Flagged
- **Intent match**: ✅ / ⚠️ [details if flagged]
- **Assumption audit**: ✅ / ⚠️ [details if flagged]
- **Silent trade-offs**: ✅ / ⚠️ [details if flagged]
- **Complexity proportionality**: ✅ / ⚠️ [details if flagged]
- **Architectural drift**: ✅ / ⚠️ [details if flagged]
```

For checks that were skipped (per risk profile), omit them from the list — only show checks that were actually run.

**Hygiene rule:** If a Review section already exists (re-review after fix), **replace** it. Do not append a second one. The step block has exactly one Review section at all times.

---

## Completion Report

After writing to results.md, report back to the orchestrator:

```
## Step [N] Review

**Task**: [milestone-slug]-[task-slug]
**Step**: [N] - [Step Name]
**Risk Profile**: [Critical/Standard/Exploratory]
**Verdict**: PASS / FLAG

**Checks Applied**: [X] of 5 (per risk profile)

[If flagged]:
**Issues**:
1. [Check name]: [What was found, why it's a concern, what the design intended vs what was built]

**Recommendation**: [Fix before proceeding / Acceptable, note for future / Override with caution]
```

The orchestrator reads the verdict (PASS/FLAG) and acts accordingly. If FLAG, it will send the issues verbatim to a fresh executor for fixing.
