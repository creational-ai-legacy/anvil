---
description: Extract YouTube video and save as a formatted markdown document
argument-hint: <youtube-url-or-id>
disable-model-invocation: true
---

# /vp

Extract a YouTube video's metadata and transcript, then produce a polished, readable markdown document using a parallel chapter pipeline.

## Resources

**Read these before starting**:
- Guide (main instructions): `~/.claude/skills/video-professor/references/vp-guide.md`
- Template (output structure): `~/.claude/skills/video-professor/assets/templates/vp-template.md`

## Input

**Argument (required)**: YouTube URL or video ID

```bash
/vp https://www.youtube.com/watch?v=dZxyeYBxPBA
/vp dZxyeYBxPBA
```

## Output

Creates a `vp-[title-slug].md` file with:
- H1 title from video title
- Metadata table (channel, date, duration, views, likes, comments, tags)
- Description summary with key links
- Chapters list with timestamps
- Full transcript organized by chapter headings, cleaned and paragraphed

## Pipeline

Every video goes through the same uniform pipeline:
0. **Clear scratchpad first** — run `rm -rf scratchpad/*` before anything else
1. Fetch data, save `raw.json`, run extract script
2. If no chapters found, the `vp-topic-detector` agent identifies natural topic breaks
3. Build skeleton document with chapter/topic placeholders
4. `vp-chapter-cleaner` subagents process all chapters in the background

Read the guide. Follow it exactly. Use the template.
