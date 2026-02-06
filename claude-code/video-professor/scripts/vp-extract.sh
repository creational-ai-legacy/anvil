#!/usr/bin/env bash
#
# vp-extract.sh — Extract metadata and split transcript by chapters
#
# Usage: vp-extract.sh <raw.json> <scratchpad_dir>
#
# Input:  raw.json — Either direct JSON or MCP wrapper format
#         Direct: {video_id, metadata, transcript, errors}
#         Wrapper: {"result": "{...serialized JSON...}"}
# Output: Prints metadata + chapters to stdout, writes ch-XX-raw.txt files to scratchpad_dir
#         If 0-1 chapters, also writes transcript.txt (timestamp\ttext per line) for topic detection

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <raw.json> <scratchpad_dir>" >&2
    exit 1
fi

RAW_JSON="$1"
SCRATCHPAD="$2"

if [[ ! -f "$RAW_JSON" ]]; then
    echo "Error: $RAW_JSON not found" >&2
    exit 1
fi

mkdir -p "$SCRATCHPAD"

python3 - "$RAW_JSON" "$SCRATCHPAD" << 'PYEOF'
import json, re, sys, os

raw_json = sys.argv[1]
scratchpad = sys.argv[2]

with open(raw_json) as f:
    raw = json.load(f)

# Support both direct JSON and MCP wrapper format
if "result" in raw and isinstance(raw["result"], str):
    data = json.loads(raw["result"])
else:
    data = raw
meta = data["metadata"]
segments = data["transcript"]["segments"]

# --- Metadata ---
print("=== METADATA ===")
print(f"title: {meta['title']}")
print(f"channel: {meta['channel_title']}")
print(f"published: {meta['published_at']}")
print(f"duration_seconds: {meta['duration_seconds']}")
print(f"views: {meta['view_count']}")
print(f"likes: {meta['like_count']}")
print(f"comments: {meta['comment_count']}")
print(f"tags: {meta.get('tags', [])}")

# --- Description ---
print("\n=== DESCRIPTION ===")
print(meta.get("description", ""))

# --- Extract chapters from description ---
desc = meta.get("description", "")
chapter_pattern = re.compile(r'^(\d{1,2}:\d{2}(?::\d{2})?)\s+(.+)$', re.MULTILINE)
chapters = chapter_pattern.findall(desc)

print("\n=== CHAPTERS ===")
for ts, title in chapters:
    print(f"{ts} {title}")
print(f"\n=== CHAPTER COUNT: {len(chapters)} ===")

# --- Split transcript by chapters ---
if len(chapters) < 2:
    # Single or no chapters: write all segments to ch-01-raw.txt
    raw_text = " ".join(seg[1] for seg in segments)
    path = os.path.join(scratchpad, "ch-01-raw.txt")
    with open(path, "w") as f:
        f.write(raw_text)
    print(f"\nch-01-raw.txt: {len(segments)} segments, {len(raw_text)} chars")

    # Write transcript.txt for topic detection (merged into ~30s blocks)
    tx_path = os.path.join(scratchpad, "transcript.txt")
    block_size = 30  # seconds per block
    lines = 0
    with open(tx_path, "w") as f:
        block_start = 0
        block_texts = []
        for ts, text in segments:
            if ts >= block_start + block_size and block_texts:
                # Convert seconds to MM:SS
                m, s = divmod(int(block_start), 60)
                f.write(f"{m:02d}:{s:02d}\t{' '.join(block_texts)}\n")
                lines += 1
                block_start = ts
                block_texts = [text]
            else:
                block_texts.append(text)
        if block_texts:
            m, s = divmod(int(block_start), 60)
            f.write(f"{m:02d}:{s:02d}\t{' '.join(block_texts)}\n")
            lines += 1
    print(f"transcript.txt: {lines} lines ({block_size}s blocks)")
else:
    # Convert chapter timestamps to seconds
    def ts_to_seconds(ts):
        parts = ts.split(":")
        if len(parts) == 3:
            return int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2])
        return int(parts[0]) * 60 + int(parts[1])

    ch_starts = [(ts_to_seconds(ts), title) for ts, title in chapters]

    print("\n=== SPLITTING TRANSCRIPT ===")
    for i, (start, title) in enumerate(ch_starts):
        end = ch_starts[i + 1][0] if i + 1 < len(ch_starts) else 999999
        ch_segments = [seg[1] for seg in segments if seg[0] >= start and seg[0] < end]
        raw_text = " ".join(ch_segments)

        fname = f"ch-{i + 1:02d}-raw.txt"
        path = os.path.join(scratchpad, fname)
        with open(path, "w") as f:
            f.write(raw_text)

        print(f"{fname}: {len(ch_segments)} segments, {len(raw_text)} chars")

print("\nDone!")
PYEOF
