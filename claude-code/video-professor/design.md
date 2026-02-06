# /vp Command - Architecture Design

## Problem

The `/vp` command processes YouTube videos into formatted markdown documents. For long videos (1-2+ hours), the transcript data exceeds what can be processed in a single context. The current approach is fragile and non-deterministic — manual jq extraction, ad-hoc file splitting, and one-shot cleanup.

## Solution: Parallel Chapter Pipeline

Split the work between a main agent (orchestrator) and parallel subagents (chapter cleaners). The main agent handles data extraction and document setup. Each subagent handles one chapter's transcript cleanup and writes directly to the final document.

## Architecture

```
User invokes /vp <url>
    |
    Main Agent (follows vp-guide.md)
    |
    |  Phase 1: Extract
    |  1. Call mcp__video-professor__get_video_data
    |  2. Save full response to scratchpad/raw.json
    |  3. Extract metadata via python (from raw.json)
    |  4. Parse chapters from description
    |  5. Split transcript segments by chapter -> scratchpad/ch-XX-raw.txt
    |
    |  Phase 2: Scaffold
    |  6. Create skeleton document at target path:
    |     - H1 title, source URL, metadata table
    |     - Description section
    |     - Chapters list
    |     - Chapter H3 headings with <!-- VP-CH-XX --> placeholders
    |
    |  Phase 3: Clean (parallel)
    |  7. Spawn N vp-chapter-cleaner subagents in parallel
    |     Each receives: raw file path, placeholder tag, target doc path
    |
    |  Phase 4: Verify
    |  8. Confirm no <!-- VP-CH-XX --> placeholders remain
    |  9. Report completion
    |
    vp-chapter-cleaner subagent (x N, parallel)
    |
    |  1. Read scratchpad/ch-XX-raw.txt
    |  2. Apply cleanup rules:
    |     - Fix auto-caption spelling errors (proper nouns, technical terms)
    |     - Insert paragraph breaks at topic transitions
    |     - Format direct quotes and enumerated points
    |     - Preserve speaker's original words
    |  3. Edit target doc: replace <!-- VP-CH-XX --> with cleaned text
    |  Done.
```

## Scratchpad Layout

```
scratchpad/
  raw.json           # Full MCP response (metadata + transcript)
  ch-01-raw.txt      # Raw transcript text for chapter 1
  ch-02-raw.txt      # Raw transcript text for chapter 2
  ...
```

These are transient working files. Only the final `vp-[slug].md` persists.

## Placeholder Convention

Each chapter heading in the skeleton doc gets a unique placeholder:

```markdown
### Intro (00:00:00)

<!-- VP-CH-01 -->

### High Level Architecture (00:05:39)

<!-- VP-CH-02 -->
```

Placeholders use the format `<!-- VP-CH-XX -->` where XX is zero-padded chapter number.

## Subagent: vp-chapter-cleaner

| Field | Value |
|-------|-------|
| **Name** | `vp-chapter-cleaner` |
| **Tools** | `Read, Edit` |
| **Model** | `sonnet` |
| **Location** | `claude-code/video-professor/agents/vp-chapter-cleaner.md` |
| **Deploys to** | `~/.claude/agents/vp-chapter-cleaner.md` |

The cleanup rules are embedded directly in the agent's system prompt so it is self-contained. No need to read external guide files at startup.

The main agent launches subagents via the Task tool:
```
Task(vp-chapter-cleaner, prompt="Clean chapter 3...")  # x N in parallel
```

## Short Video Handling

For videos with no chapters or a single chapter:
- Skip the parallel pipeline entirely
- Main agent cleans the transcript inline
- No subagents needed

Threshold: if chapter count <= 1, process inline.

## File Changes

| File | Action | Purpose |
|------|--------|---------|
| `agents/vp-chapter-cleaner.md` | CREATE | Subagent definition with cleanup rules |
| `references/vp-guide.md` | UPDATE | Replace sequential process with pipeline |
| `SKILL.md` | UPDATE | Add agents section |
| `commands/vp.md` | UPDATE | Minor — reference agent |
| `deploy.sh` | UPDATE | Deploy agent to `~/.claude/agents/` |
| `verify.sh` | UPDATE | Verify agent deployment |

## Spawning Pattern

The main agent sends a single message with multiple Task tool calls:

```
[Task: clean chapter 1] [Task: clean chapter 2] [Task: clean chapter 3] ...
```

All subagents run concurrently. Each targets a unique placeholder so Edit calls don't collide. The main agent waits for all to complete, then verifies the document.

## Race Condition Analysis

Each subagent's Edit call targets a unique string (`<!-- VP-CH-01 -->` vs `<!-- VP-CH-02 -->`). Since Edit does exact string matching and replacement, and each placeholder appears exactly once, edits are independent. In practice, subagents finish at slightly different times, naturally serializing file writes.

## Quality Verification

After all subagents complete, the main agent:
1. Reads the final document
2. Greps for any remaining `<!-- VP-CH-` placeholders
3. If any remain, reports which chapters failed
4. Otherwise, confirms completion
