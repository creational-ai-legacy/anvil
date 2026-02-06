# Video Document Formatting Guide

Main instructions for the `/vp` command. Follow this process exactly to produce clean, readable video documents from YouTube transcripts.

**Template**: `assets/templates/vp-template.md`

---

## MCP Server

All tools are on the `video-professor` MCP server. Use the `mcp__video-professor__` prefix:

| Tool Call | Purpose |
|-----------|---------|
| `mcp__video-professor__get_video_data` | Fetch metadata + transcript (use `save_to_s3: true`) |
| `mcp__video-professor__get_comments` | Fetch video comments |

---

## Session Scratchpad

Use the **session scratchpad** for all temporary files (raw.json, ch-XX-raw.txt, ch-XX-clean.txt). This is a session-specific directory provided by Claude Code at a path like:

```
/private/tmp/claude-501/.../scratchpad
```

The exact path is in your system prompt under "Scratchpad Directory". Use this path for all scratchpad references in this guide — never create a `scratchpad/` folder in the user's project.

---

## Architecture Overview

The `/vp` command uses a **uniform chapter pipeline** — every video goes through the same flow:

1. **Main agent** fetches data, saves `raw.json`, runs extract script
2. If no chapters found, a **topic detector agent** analyzes the transcript and creates topic breaks
3. **Main agent** builds skeleton document with chapter placeholders
4. **Parallel chapter cleaner subagents** (one per chapter/topic) clean the raw transcript in the background
5. **Main agent** verifies the document is complete

---

## Process

### Phase 1: Extract

#### Step 0: Clear Scratchpad

Clear any leftover files from previous runs:

```bash
rm -rf [session-scratchpad]/*
```

Replace `[session-scratchpad]` with the actual path from your system prompt.

#### Step 1: Fetch Data

Call `mcp__video-professor__get_video_data` with the provided URL/ID and `save_to_s3: true`. The MCP returns a small JSON with a presigned S3 URL instead of the full transcript.

#### Step 2: Download raw.json

Download the presigned URL to the session scratchpad using `curl`:

```bash
curl -s -o [session-scratchpad]/raw.json "PRESIGNED_URL_FROM_STEP_1"
```

Replace `PRESIGNED_URL_FROM_STEP_1` with the `url` field from the MCP response. The presigned URL expires in 1 hour.

#### Step 3: Run Extract Script

Run the extraction script to extract metadata, detect chapters, and split the transcript:

```bash
~/.claude/skills/video-professor/scripts/vp-extract.sh [session-scratchpad]/raw.json [session-scratchpad]/
```

This script:
- Prints metadata (title, channel, published, duration_seconds, views, likes, comments, tags) to stdout
- Prints the full description to stdout
- Extracts chapters from the description and prints them
- Reports `CHAPTER COUNT: N`
- If 2+ chapters: splits transcript into `ch-XX-raw.txt` files (one per chapter)
- If 0-1 chapters: writes all segments to `ch-01-raw.txt` (single file)

Use the stdout output to populate the metadata table and description section. Field mapping for the skeleton:

| Field | Source |
|-------|--------|
| Title | `title` -- use as document H1 |
| Source | Full YouTube URL |
| Channel | `channel` |
| Published | `published` (date only) |
| Duration | Convert `duration_seconds` to MM:SS or HH:MM:SS |
| Views | `views` (formatted with commas) |
| Likes | `likes` (formatted with commas) |
| Comments | `comments` (formatted with commas) |
| Tags | `tags` (comma-separated) |

#### Step 4: Detect Topics (only if 0-1 chapters)

If the extract script reports `CHAPTER COUNT: 0` or `CHAPTER COUNT: 1`, launch the **vp-topic-detector** subagent:

```
Task tool:
  subagent_type: vp-topic-detector
  description: "Detect video topics"
  prompt: |
    Analyze the transcript and identify natural topic breaks.
    - raw.json path: [session-scratchpad]/raw.json
    - scratchpad path: [session-scratchpad]/
```

Wait for this agent to complete. Then read `[session-scratchpad]/detected-chapters.txt` for the topic list.

#### Step 5: Handle Description (from script output)

The video description often contains mixed content. For the Description section:

- Include the content summary if present
- Include key links the creator shared (articles, tools mentioned)
- Skip sponsor/ad segments
- Skip the chapter list (it's already in its own section)
- Skip social media follow links

### Phase 2: Scaffold

#### Step 6: Create Skeleton Document

Write the target document using the template at `assets/templates/vp-template.md`.

Chapter source:
- **Creator-provided chapters**: use the chapter list from the extract script output (Step 3)
- **Detected topics**: use the topic list from `[session-scratchpad]/detected-chapters.txt` (Step 4)

Fill in:
- H1 title, source URL
- Metadata table (from Step 3 script output)
- Description section (from Step 5)
- Chapters list with timestamps
- Chapter H3 headings with **placeholders**:

```markdown
### Intro (00:00:00)

<!-- VP-CH-01 -->

### High Level Architecture (00:05:39)

<!-- VP-CH-02 -->
```

Placeholder format: `<!-- VP-CH-XX -->` where XX is zero-padded chapter number (01, 02, ...).

### Phase 3: Clean (parallel)

#### Step 7: Spawn Chapter Cleaners

Launch parallel `vp-chapter-cleaner` subagents using the Task tool with `run_in_background: true`. Send all Task calls in a single message for parallel execution.

Each subagent receives a prompt with:
- The raw chapter file path (e.g., `[session-scratchpad]/ch-03-raw.txt`)
- The output file path (e.g., `[session-scratchpad]/ch-03-clean.txt`)

Example prompt for each subagent:
```
Clean this YouTube transcript chapter and write it to the output file.

- Raw file: [session-scratchpad]/ch-03-raw.txt
- Output file: [session-scratchpad]/ch-03-clean.txt
```

### Phase 4: Assemble Incrementally

#### Step 8: Replace Placeholders as Cleaners Complete

As each background cleaner finishes (you'll receive a task notification), immediately:
1. Read the corresponding `ch-XX-clean.txt` from the scratchpad
2. Replace the `<!-- VP-CH-XX -->` placeholder in the target document using the Edit tool

Do this one at a time as notifications arrive — the main agent is the only editor, so there are no conflicts. If multiple notifications arrive in the same message, process them sequentially in a single response (read all clean files in parallel, then edit the target document once with all replacements).

After the last cleaner completes:
1. Verify no remaining `<!-- VP-CH-XX -->` placeholders exist
2. Confirm completion with the file path

---

## Cleanup Rules Reference

These rules are embedded in the `vp-chapter-cleaner` subagent. Listed here for reference.

### Spelling Corrections

Fix obvious auto-caption errors. Only fix clear errors -- do not rewrite or paraphrase.

**Proper nouns** (most common errors):
- Company names: "Enthropic" -> "Anthropic", "Open AAI" -> "OpenAI"
- People: "Alman" -> "Altman", "Carpathy" -> "Karpathy", "Amade" -> "Amodei"
- Products: "Codeex" -> "Codex", "clawed code" -> "Claude Code", "clawed" -> "Claude", "claw" -> "Claude" (when referring to Anthropic's AI), "superbase" -> "Supabase"

**Technical terms**:
- "aent" / "aents" -> "agent" / "agents"
- "multi- aent" -> "multi-agent"
- "rag" -> "RAG" (when referring to Retrieval Augmented Generation)
- "evals" stays as "evals" (correct jargon)
- "env" stays as "env" (correct jargon)

**Rule**: If you're unsure whether something is a mistake or the speaker's actual phrasing, leave it.

### Paragraph Breaks

Break the wall of text into logical paragraphs (3-8 sentences typically).

**When to break**:
- Topic transition within a chapter
- Speaker shifts from one argument to another
- After a question the speaker poses (rhetorical or otherwise)
- Before a list or enumeration
- After completing an anecdote or example

**When NOT to break**:
- Mid-sentence
- In the middle of an argument that flows continuously
- Just to make paragraphs shorter

### Light Formatting

**Direct quotes** -- When the speaker quotes someone else:
```markdown
He said, "I don't write code anymore. I let the model write the code."
```

**Enumerated points** -- When the speaker lists items:
```markdown
**Number one**, power users are assigning tasks, not asking questions.

**Number two**, accept imperfections and iterate.

**Third**, invest in specification and reviews.
```

**Emphasis** -- Do NOT add bold/italic for emphasis beyond what the structure requires. The transcript should read as natural speech. Preserve the speaker's voice -- do not editorialize or summarize.

### Chapter Edge Cases

- **Nested chapters**: Some creators indent sub-chapters. Treat all as flat H3 headings.
- **Chapters with special characters**: Preserve the chapter title as-is (colons, dashes, ampersands are fine in headings).

---

## File Naming

**Filename convention**: `vp-[title-slug].md`
- Always prefix with `vp-`
- Derive slug from the video title: lowercase, hyphens for spaces, strip special characters
- Keep the slug short but descriptive (3-6 words)

**Default location**: Save to `~/Development/docs/vp/`. If the user specifies a different directory, use that instead.

**Good examples**:
- `vp-capability-overhang-nate-b-jones.md`
- `vp-karpathy-software-2-keynote.md`
- `vp-ai-agents-parallel-work-2026.md`

**Bad examples**:
- `vp-video.md` (too generic)
- `vp-openai-is-slowing-hiring-anthropics-engineers-stopped-writing-code.md` (too long)
- `vp-dZxyeYBxPBA.md` (video ID, meaningless)
- `capability-overhang.md` (missing `vp-` prefix)

---

## Quality Checklist

- [ ] Metadata table is complete (no missing fields)
- [ ] Duration correctly converted from seconds
- [ ] Numbers formatted with commas (views, likes, comments)
- [ ] Chapters from description or detected topics
- [ ] Transcript split by chapter/topic headings
- [ ] Auto-caption spelling errors fixed
- [ ] Paragraph breaks added at logical points
- [ ] Speaker's words preserved (not rewritten or summarized)
- [ ] Direct quotes properly formatted
- [ ] No remaining `<!-- VP-CH-XX -->` placeholders in final document
- [ ] File saved as `vp-[slug].md`
