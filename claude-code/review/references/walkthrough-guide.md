# Walkthrough Guide

Pedagogical, operator-facing comprehension pass: `/walkthrough` paces an operator through a document **unit-by-unit**, elaborating each unit from five angles (plain English, motivation, diagram, before/after state delta, usage) and pausing between units for natural-language confirmation before advancing.

> **Source of truth.** This guide defines every aspect of walkthrough behavior — argument parsing, doc-type recognition, unit detection, unit extraction, the five-angle elaboration rules, review-context enrichment, and per-unit advance semantics. The thin command wrapper at `~/.claude/commands/walkthrough.md` is an entry point; all logic lives here.

> **Reading convention.** Below, "unit" is the generic label for whatever the doc calls its segment (Step, Item, Task, Milestone, Goal, Phase, Component, Requirement, Section, …). `{Term}` is the placeholder the walkthrough substitutes at render time with the doc's detected term (see Adaptive Vocabulary).

---

## Input / Argument Parsing

- **Argument 1 (required)**: `<doc-path>` — path to the document to walk through.
- **Argument 2+ (optional)**: free-form `[notes]` — focus areas the operator wants emphasized (e.g., "pay extra attention to the migration path").
- **No flags.** No `--auto`. No `--first`. No `--follow`. No mutually-exclusive flag pairs. The walkthrough's invocation surface is deliberately minimal and conversational.

### Path Normalization

Apply these rules to `<doc-path>` **before** the existence check:

1. **Strip a leading `@`** if present (Claude Code-style path reference — e.g., `@docs/foo.md` becomes `docs/foo.md`).
2. **Expand a leading `~/`** to `$HOME` (e.g., `~/Development/anvil/docs/foo.md` resolves against the user's home directory).
3. **If the remaining path is relative**, resolve it against the current working directory.
4. **If the remaining path is absolute**, accept as-is.

### Rejection Rules

Surface these as operator-visible errors (not silent failures):

- **Missing doc path** → `doc path required`
- **Normalized path does not exist on disk** → `doc not found: <normalized-path>`
- **Doc has no headings Unit Extraction can consume** (neither a Tier 1 match nor any H2 under default extraction) → `No unit structure detected. Walkthrough requires at least H2 sections (or a consistent indexed heading pattern at any depth) to segment the doc.`

---

## Doc-Type Recognition

Identify the document type from its filename pattern. Use the shared tables defined in `exam-guide.md § Document Type Recognition` (Design Docs + Dev Docs). **Reference them by name — do not duplicate the tables here.** This keeps filename→doc-type mapping a single source of truth: if `exam-guide.md` adds a new doc type later, walkthrough inherits it for free.

- The doc type drives two things: the **Tier 2 unit-term default** (see Adaptive Vocabulary below) and the **before/after interpretation** for Angle 4 (see Five-Angle Elaboration Rules).
- **Unknown doc type** (filename matches no pattern) → walkthrough continues; the unit term falls through to Tier 3 generic "Section".

---

## Adaptive Vocabulary — Unit Detection (3-Tier Priority)

The walkthrough detects what the doc calls its own units and uses that exact term everywhere in output (gate prompts, counters, summary lines). Three-tier priority — **first match wins**.

### Tier 1 (primary) — Heading-Pattern Scan

Scan the doc for repeated unit headers at **any heading depth** (H2, H3, H4, …). Accept two patterns:

1. **Termed-index pattern**: `#+ <Term> <N>[:.]? <title>` or `#+ <Term> <N.M>[:.]? <title>`. The word immediately before the numeric index supplies the unit term. Examples:
   - `## Step 1: Setup`, `## Step 2: Migrate` → unit term = **Step**
   - `## Milestone 1: MVP` → unit term = **Milestone**
   - `### Item 1: Authentication`, `### Item 2: Authorization` → unit term = **Item**
   - `## Phase 1: Planning` → unit term = **Phase**
   - `## Task 3.2: ...` → unit term = **Task**
   - `## Requirement 5.1: ...` → unit term = **Requirement**
   - `## Goal 2: ...` → unit term = **Goal**
   - `## Component 4: ...` → unit term = **Component**

2. **Bare-numeric pattern**: `#+ <N>[.:]? <title>` — no term word, just a numeric index. Tier 1 **still matches** on this form; the term word falls back to the Tier 2 doc-type default. Example: `### 1. Command Spec`, `### 2. Adaptive Vocabulary`, … (the dev-design Analysis items pattern).

**Tier 1 is inconclusive when**:
- Fewer than **2** matching headings are found, **OR**
- Matching headings disagree on the unit term (mixed vocabulary — e.g., `## Step 1` and `## Item 2` both present), **OR**
- Matching headings span multiple heading depths with no single dominant depth.

When any of these conditions holds, fall through to Tier 2.

**Detected heading depth**: Tier 1 also records the **dominant heading depth** of its matches (e.g., H3 when the doc's items are all `### <N>. <title>`). That depth drives Unit Extraction — this is what makes the walkthrough work correctly on, say, dev-design Analysis items at H3 even when the term comes from Tier 2.

### Tier 2 (fallback) — Doc-Type Default Lookup

If Tier 1 is inconclusive, fall back to the per-doc-type default term:

| Doc type | Default unit term |
|----------|-------------------|
| Vision | Goal |
| Architecture | Component |
| Roadmap | Milestone |
| Milestone Spec | Task |
| Task Spec | Item |
| Task Design | Item |
| Plan | Step |
| Results | Step |

### Tier 3 (last resort) — Generic "Section"

If the doc type is unknown AND Tier 1 was inconclusive, fall through to generic **Section**: treat each `## H2` heading as a unit, label it "Section".

### Term Substitution

The detected term replaces `{Term}` placeholder in all operator-facing output:

- Gate prompt: *"Ready for **{Term} {N+1}**?"*
- Counter (if shown): *"**{Term} {N}** of {Total}"*
- Summary on exit: *"Walked through {K} of {Total} {term}s"* (plural lowercased — e.g., "items", "steps", "milestones")

---

## Unit Extraction

- **When Tier 1 matched**: iterate headings at the **detected dominant depth** in document order. Each matching heading starts a new unit; content until the next heading at the same depth (or an ancestor depth) belongs to that unit. Headings at **deeper depths** are part of the current unit's body. This is the branch that surfaces dev-design Analysis Items (H3 under `## Analysis`) correctly — the walkthrough never collapses them into one H2 block.
- **When Tier 1 was inconclusive** (Tier 2 or Tier 3 branch): iterate `##` H2 headings in document order (default extraction). Each H2 starts a new unit; nested `###` and deeper headings are part of the parent unit.
- Units carry: **(index, title, body text, any code blocks / tables / lists in body)**.

---

## Five-Angle Elaboration Rules

For every unit, in **this fixed order, no angle skipped**:

### Angle 1 — Plain English (What)

One paragraph, jargon-free. Describe what this unit accomplishes and its outcome. Length: 1-3 sentences.

### Angle 2 — Motivation (Why)

One paragraph. Explain why this unit exists, what would break or remain unsolved without it, what constraint or goal it satisfies. Length: 1-3 sentences.

### Angle 3 — Diagram (How)

An **ASCII diagram** illustrating the unit's mechanism, structure, flow, or state. Diagram kind is selected from the unit's body content:

- **flow diagram** — for process / sequence units (e.g., "read input → validate → write output").
- **box-and-arrow** — for structural / component units (e.g., architecture components, module interactions).
- **state transition** — for before→after value changes (e.g., config key flipped, data-model migration).
- **dependency graph** — for coordination units (e.g., milestone ordering, which task blocks which).

ASCII only — always renders in any environment, no flag required.

**Non-visual units** (renames, config-value edits, prose changes) still get a diagram — a **simple two-box before→after** showing the value change is sufficient. **Never skip Angle 3.** The discipline of producing a diagram forces the unit to be concrete.

If unsure which kind to use, default to **box-and-arrow**.

### Angle 4 — Before / After (State Delta)

A concrete state delta, anchored in **artifacts**. The interpretation of "state" depends on the doc type:

- **Plan / Results** → **code state**: file list, key function signatures, test count — before vs. after.
- **Task Design / Task Spec** → **design state** (decisions, constraints) and **behavior state** (what the system does) — before vs. after.
- **Milestone Spec** → **deliverable state**: what exists, what's in scope, what's shippable — before vs. after.
- **Roadmap** → **capability state**: what's shippable — before vs. after.
- **Architecture** → **structural state**: what components exist and how they relate — before vs. after.
- **Vision** → **strategic state**: what the organization understood — before vs. after.
- **Unknown / generic** → describe the delta in whatever terms the unit itself uses.

Length guidance: 1-3 sentences or equivalent structured content (a short before/after list is fine).

### Angle 5 — Usage (Consumer)

Who consumes this unit's output? Another unit? A downstream doc? End user? QA? What should the operator expect to see in the repo, tests, or UI once this unit is done? Length: 1-3 sentences.

### Common Pitfalls (avoid all of these)

- **common pitfall: verbose boilerplate** that repeats the unit's own body text instead of elaborating. Each angle must add information — not restate.
- **common pitfall: diagrams that describe rather than render**. A prose sentence that says "this is a flow from A to B" is not a diagram. Render actual ASCII.
- **common pitfall: before/after type mismatch** — phrasing state delta as "code changes" when the unit is strategic, or as "strategic change" when the unit edits code. Match the per-doc-type interpretation in Angle 4.

---

## Review Context Enrichment (Optional Overlay)

If a `docs/[slug]-review.md` file exists alongside the target doc, load it.

- Surface review context in the **Motivation angle** when pedagogically useful. Example: *"This {term} was rewritten in R2 because the original approach conflicted with the existing loop defaults."*
- Review context **enriches** elaboration; it does **not** drive unit extraction or override the detected term.
- If no `-review.md` exists, proceed without it.

---

## Per-Unit Advance Semantics

After the five angles render for a unit, pause on a minimal prompt and interpret the operator's next utterance in natural language.

### Prompt Shape

- At the final line of the unit's elaboration, render exactly: *"Ready for {Term} {N+1}?"*
- Nothing else is rendered per unit. **No** explicit QA checklist. **No** "common traps" list (pitfalls are guidance for the walkthrough's own elaboration, not an operator-facing checklist). **No** formal response-protocol labels.

### Readiness Is Internal

**Readiness is an internal judgment by the walkthrough, not an operator-facing artifact.** The walkthrough reads the operator's engagement from their response: a substantive question prompts elaboration before advancing; a quick acceptance advances. Readiness is never rendered as a checklist.

### Operator Signals (Natural Language)

Interpret operator responses conversationally — **no formal tokens required**:

- **Affirmative** (*"yes"*, *"ok"*, *"next"*, *"continue"*, *"got it"*, *"sure"*) → advance to the next unit.
- **Question or concern** → answer directly, then re-prompt *"Ready for {Term} {N+1}?"*.
- **Exit signal** (*"stop"*, *"enough"*, *"I've got it"*, *"done"*, *"that's enough"*) → end the walkthrough.

### Exit Conditions

- Any exit signal from the operator, **or**
- Reaching the final unit (the walkthrough wraps with a brief acknowledgement and stops automatically).

### Summary on Exit

Render exactly: *"Walked through {K} of {Total} {term}s"* (plural lowercased, e.g., "items" / "steps" / "milestones" / "sections").

---

## Invariants (Non-Negotiable)

These are **non-negotiable** — hard invariants enforced by this guide:

1. The walkthrough **never writes** to the target doc or any other file. It is strictly read + elaborate. No `--auto`, no fix mode, no persisted state. Re-running starts fresh.
2. The five-angle format is **non-negotiable**. Even non-visual units get a weak two-box state diagram for Angle 3. No angle is skipped. No angle is silently merged with another.
3. **No formal response-protocol vocabulary** (`yes` / `questions` / `stop` as labeled tokens) surfaces in the walkthrough's output. Operator signals are interpreted from natural language only — the prompt shape is *"Ready for {Term} {N+1}?"*, not a menu.

---

## Process Outline

The thin command wrapper's short Process list mirrors this outline. The authoritative process is:

1. Read this guide.
2. Parse arguments (doc path + optional free-form notes).
3. Detect doc type from filename pattern (via `exam-guide.md § Document Type Recognition`).
4. Detect the unit term using the 3-tier adaptive vocabulary (Tier 1 heading scan → Tier 2 doc-type default → Tier 3 generic "Section").
5. Extract units — iterate at the detected dominant heading depth from Tier 1; default to H2 boundaries when Tier 1 is inconclusive.
6. Load review context if a `-review.md` file exists alongside the target doc.
7. For each unit in document order: render the five angles → pause on the minimal *"Ready for {Term} {N+1}?"* prompt → interpret the operator's response in natural language → advance, elaborate, or exit.
8. On exit signal or final unit: render the summary line *"Walked through {K} of {Total} {term}s"* and end.
