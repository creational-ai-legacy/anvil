---
description: Get comments for a YouTube video
argument-hint: <youtube-url-or-id>
---

# /vp-comments

Get comments for a YouTube video.

## Input

**Argument (required)**: YouTube URL or video ID
Optional: `--max <number>` to limit results (default: 100)

## Process

1. Call `mcp__video-professor__get_comments` with the provided URL/ID
2. If `--max` is specified, use that as the `max_results` parameter
3. Return the comments list
