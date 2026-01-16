# Diagram Guide

Generate a tight ASCII box summary from task documentation.

## Input

Slug format: `[milestone-slug]-[task-slug]`

Examples:
- `core-poc2`
- `cloud-auth-fix`
- `core-compact-response`

## Source Documents

Read all matching docs to synthesize the diagram:

```
docs/[slug]-overview.md
docs/[slug]-implementation.md
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

**Exclude:**
- Files/directories (implementation details)
- Test counts (not important)

## Generation Process

1. **Read** all `docs/[slug]-*.md` files
2. **Extract** fields using rules above
3. **Format** using template (`assets/templates/diagram.md`)
4. **Adjust** box width to fit longest line + 2 spaces padding
5. **Center** header lines within box

## Output

Wrap diagram in ` ```diagram ` code block. See template for format and example.

## Placement

Insert into `docs/[slug]-results.md`:
- After `## Summary` section (after the table)
- Before the `---` separator

## Template Reference

See `assets/templates/diagram.md` for:
- Box character set
- Placeholder definitions
- Formatting rules

---

## Quick Reference

1. **Read** - All `docs/[slug]-*.md` files (overview, implementation, results)
2. **Extract** - Task ID, short name (1 word CAPS), status, features/metrics
3. **Group** - Organize items under section headers (Data Shapes, MCP Tools, etc.)
4. **Focus** - Features and achievements, NOT files or test counts
5. **Format** - Use template, adjust box width, blank line between sections
6. **Place** - Insert after `## Summary` in results doc, before `---`
