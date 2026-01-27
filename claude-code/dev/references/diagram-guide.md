# Diagram Guide

Generate a tight ASCII box summary from task documentation.

**Template**: `assets/templates/diagram.md`

## Input

Slug format: `[milestone-slug]-[task-slug]`

Examples:
- `core-poc2`
- `cloud-auth-fix`
- `core-compact-response`

## Source Documents

Read all matching docs to synthesize the diagram:

```
docs/[slug]-design.md
docs/[slug]-plan.md
docs/[slug]-results.md
```

## Extraction Rules

| Field | Source | Example |
|-------|--------|---------|
| Task ID | Filename slug | `core-poc2` → "PoC 2" |
| Short Name | Doc title or "Proves" field | "EXTRACTORS" (1 word, CAPS) |
| Status | Summary table in results | ✅ Complete / 🔄 In Progress |
| Features/Metrics | Deliverables, success criteria, achievements | Metadata, 12x faster, 14K tokens |

### Task ID Extraction

Parse from slug:
- `poc[N]` → "PoC [N]"
- `feature-*` → "Feature"
- Other → Title case the slug

### Short Name Extraction

1. Check "Proves" field in results summary
2. Fall back to doc title
3. Extract 1 word that captures essence
4. Convert to CAPS

### Features/Metrics Extraction

**Look for:**
1. Deliverables section - what capabilities were added
2. Success criteria - what was proven
3. Key metrics - performance gains, limits discovered
4. "What This Unlocks" - downstream value

**Group into sections** (examples):
- Data Shapes, Schema Design
- Capabilities, MCP Tools
- Performance, Architecture

**Include:**
- Features/capabilities (Metadata, Comments, TTL logic)
- Metrics/achievements (12x faster, 14K tokens, max 1108 segments)
- Tools/APIs added (get_transcript, get_metadata)

**Exclude (NEVER include):**
- Files/directories (implementation details)
- Test counts, test results, tests passed (not important)

## Generation Process

1. **Read** all `docs/[slug]-*.md` files
2. **Extract** fields using rules above
3. **Format** using template (`assets/templates/diagram.md`)
4. **Adjust** box width to fit longest line + 2 spaces padding
5. **Center** header lines within box

## Output

Insert `## Diagram` section into `docs/[slug]-results.md`:
- **Location**: After `## Summary` section (after the table), before the first `---`

Then add the diagram in a code block (no language tag):

```
## Diagram

[diagram code block here]
```

See template for diagram format and examples.

---

## Quick Reference

1. **Read** - All `docs/[slug]-*.md` files (design, plan, results)
2. **Extract** - Task ID, short name (1 word CAPS), status, features/metrics
3. **Group** - Organize items under section headers (Data Shapes, MCP Tools, etc.)
4. **Focus** - Features and achievements only. NEVER files, test counts, or test results
5. **Format** - Use template, adjust box width, blank line between sections
6. **Output** - Insert `## Diagram` section after Summary table (before first `---`), diagram in code block (no language tag)
