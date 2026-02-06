# video-professor

Extract YouTube video content and produce well-structured, readable markdown documents.

## Invocation

```bash
/vp <youtube-url-or-id>            # Full formatted document (metadata + transcript)
/vp-comments <youtube-url-or-id>   # Comments
```

## When to Use

- Capturing video content as a readable reference document
- Archiving talks, tutorials, or interviews as markdown
- Extracting structured information from YouTube videos

---

## MCP Tools

This skill uses the `video-professor` MCP server:

| Tool | Purpose |
|------|---------|
| `mcp__video-professor__get_video_data` | Fetch both metadata and transcript in one call (used by `/vp`) |
| `mcp__video-professor__get_comments` | Fetch video comments (used by `/vp-comments`) |

---

## Agents

| Agent | Purpose |
|-------|---------|
| `vp-chapter-cleaner` | Clean raw transcript for one chapter and write it into the target document. Spawned in parallel by `/vp`. |
| `vp-topic-detector` | Analyze a transcript without chapters and identify natural topic breaks with timestamps. Spawned by `/vp` when no creator-provided chapters exist. |

---

## Commands Overview

| Command | What It Does | Output |
|---------|-------------|--------|
| `/vp` | Full formatted document -- metadata table, chapters, cleaned transcript | Saves markdown file |
| `/vp-comments` | Video comments | Displays in conversation |

---

## Reference Guide

| When to Read | Reference File |
|--------------|----------------|
| `/vp` formatting process and rules | `references/vp-guide.md` |
| `/vp` output structure | `assets/templates/vp-template.md` |
