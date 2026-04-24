---
description: Operator-facing walkthrough; paces you through a doc unit-by-unit with five-angle elaboration and conversational per-unit advance.
argument-hint: <doc-path> [notes]
disable-model-invocation: true
---

# /walkthrough

Operator-facing, pedagogical walkthrough of a document — paces the operator unit-by-unit, elaborating each unit from five angles (plain English, motivation, diagram, before/after state delta, usage) and advancing on natural-language confirmation.

**Guide**: `~/.claude/skills/review/references/walkthrough-guide.md`

## Usage

```bash
/walkthrough docs/core-settings-redesign-plan.md
/walkthrough docs/core-poc6-design.md focus on the migration path
/walkthrough docs/mc-vision.md
```

## Input

- **Argument (required)**: Single document path (`<doc-path>`)
- **Notes (optional)**: Free-form focus areas the operator wants emphasized

No flags. Walkthrough is strictly read + elaborate; it never writes to the target doc.

## Process

1. Read the guide
2. Parse arguments (doc path + optional notes)
3. Detect doc type from filename pattern
4. Detect unit term via 3-tier adaptive vocabulary (heading-pattern scan → doc-type default → generic "Section")
5. Extract units at the detected dominant heading depth (or H2 boundaries when Tier 1 is inconclusive)
6. Load review context if `docs/[slug]-review.md` exists alongside the target doc
7. For each unit in order: render the five angles, pause on a minimal `Ready for {Term} {N+1}?` prompt, interpret the operator's natural-language response
8. On exit signal or final unit: render summary (`Walked through K of Total {term}s`), end

Read the guide. Follow it exactly.
