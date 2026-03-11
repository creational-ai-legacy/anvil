# Review Guide (Stage 3b)

## Purpose

Tests catch functional errors — "does the code work?" Review catches conceptual errors — "does the code match what we intended to build?"

AI-generated code passes tests reliably. But it introduces a different class of errors than human code: wrong assumptions baked in silently, trade-offs made without surfacing them, architectural drift from the design, and over-engineering that adds complexity without value. The review gate exists to catch these before they compound across steps.

## The 5 Checks

### 1. Intent Match

Does the implementation match the design doc's **intent** and the plan's **acceptance criteria** for the step?

The design doc provides the higher-level intent (what to build and why). The plan's per-step acceptance criteria provide the immediate contract (what was specified for this step and how to verify it). Both must be satisfied.

**What to look for:**
- The design says "lazy loading" but the code eagerly loads everything
- The design describes a simple pipeline but the code implements a plugin system
- The design says "use existing auth" but the code rolls its own
- The step's acceptance criteria specify 3 outcomes but only 2 are met
- The step's acceptance criteria specify a particular behavior but the implementation takes a different approach without documenting the deviation

**How to check:** Read the design doc's approach section for the relevant item — this is the "why" and "what" anchor. Then read the plan's acceptance criteria for the current step — this is the "what to verify" contract. Compare the *spirit* of the design approach and the *specifics* of the acceptance criteria against the actual implementation. Code that technically satisfies the design but misses acceptance criteria (or vice versa) is a flag.

**Not a flag:** Minor implementation details neither the design nor acceptance criteria specified (variable names, helper methods, defensive error handling).

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

**Not a flag:** Truly straightforward implementation choices that match the plan's specification exactly.

### 4. Complexity Proportionality

Does the solution's complexity match the problem's complexity?

**What to look for:**
- 3 abstract classes for 1 concrete implementation
- Plan specified 2 files, step created 5
- Configuration system for something that will never be reconfigured
- Wrapper classes that just delegate to another class
- Generalized solution for a specific problem
- Step created significantly more files or lines of code than the specification implies (e.g., 2x or more files, or substantial LOC beyond what the specification scope suggests)

**How to check:** Compare the plan's specification scope (files to modify, behaviors to implement, constraints listed) against the actual output scope (files created/modified, LOC added). If the step created significantly more files or lines of code than the specification implies — roughly 2x or more — flag for review. Count files created vs. files the plan specified. Look for abstractions with only one implementation. Ask: "Could this be done with fewer moving parts and still work?" If yes, flag it.

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

Read the Risk Profile from the plan doc's Overview table. Default to **Standard** if the field is missing or unclear.

| Check | Critical | Standard | Exploratory |
|-------|----------|----------|-------------|
| 1. Intent match | Mandatory | Mandatory | Mandatory |
| 2. Assumption audit | Mandatory | Mandatory | Mandatory |
| 3. Silent trade-offs | Mandatory | Skip | Skip |
| 4. Complexity proportionality | Mandatory | Skip | Skip |
| 5. Architectural drift | Mandatory | Mandatory | Mandatory |

**Critical**: All 5 checks. Every flag matters.
**Standard**: Checks 1, 2, 5. Focus on "did we build the right thing" and "does it fit."
**Exploratory**: Checks 1, 2, 5. Advisory — always report **PASS** (never FLAG).

---

## How to Read Code for Review

1. **Start with git diff** — `git diff` or `git diff HEAD~1` shows exactly what changed in this step. This is your primary input.
2. **Read modified files in full** — The diff shows changes; full files show context. Does the new code fit with what's around it?
3. **Cross-reference the design doc** — The design provides "what and why." The design's Approach section for the relevant item is your high-level anchor.
4. **Read the plan's acceptance criteria for the step** — The plan's per-step acceptance criteria provide the immediate contract: what was specified and how to verify it. Check each criterion against the implementation.
5. **Read the Trade-offs & Decisions section** — This is the executor's self-report. Check it for completeness and honesty.

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

## How to Write Each Check

For each check, provide evidence by connecting three things: (1) what the design/plan specified, (2) what was actually implemented, and (3) your assessment of whether they align.

**Intent match**: List the plan's acceptance criteria for the step. Verify each criterion against the actual files on disk. Reference specific file paths, directory contents, or code patterns that confirm or contradict each criterion.

**Assumption audit**: Identify decisions in the implementation that go beyond what the design specified. For each, note whether it's documented in the Trade-offs & Decisions section or is a reasonable obvious default.

**Architectural drift**: Compare the plan's Architecture/File Structure section against actual file locations. Note any structural additions or deviations and whether they preserve the intended organization.

**Silent trade-offs** (Critical only): Cross-reference every meaningful implementation choice against the Trade-offs section.

**Complexity proportionality** (Critical only): Count files created vs files planned. Flag if scope exceeds specification by 2x or more.

---

## Output Format

Return the review block as your final output. Use the format from `assets/templates/review.md`.

Each check line should include evidence: what the design/plan specified, what was implemented, and why it matches or diverges. Reference specific files, line numbers, or acceptance criteria to support the verdict.

Include only the checks applicable to the risk profile (see depth table above).

**Default mode**: Write the review block into the step in results.md, then return it.
**`--report-only` mode**: Return the review block only. The caller handles writing to results.md.

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
