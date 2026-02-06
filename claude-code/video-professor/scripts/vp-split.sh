#!/usr/bin/env bash
#
# vp-split.sh — Split transcript into chapter files using detected topics
#
# Usage: vp-split.sh <detected-chapters.txt> <raw.json> <scratchpad_dir>
#
# Reads detected chapter timestamps, splits raw.json segments into ch-XX-raw.txt files.
# Overwrites any existing ch-XX-raw.txt from the extract script.

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <detected-chapters.txt> <raw.json> <scratchpad_dir>" >&2
    exit 1
fi

CHAPTERS="$1"
RAW_JSON="$2"
SCRATCHPAD="$3"

if [[ ! -f "$CHAPTERS" ]]; then
    echo "Error: chapters file not found: $CHAPTERS" >&2
    exit 1
fi

if [[ ! -f "$RAW_JSON" ]]; then
    echo "Error: raw.json not found: $RAW_JSON" >&2
    exit 1
fi

python3 - "$CHAPTERS" "$RAW_JSON" "$SCRATCHPAD" << 'PYEOF'
import json, os, re, sys

chapters_path = sys.argv[1]
raw_json_path = sys.argv[2]
scratchpad = sys.argv[3]

# Parse detected chapters (MM:SS or HH:MM:SS format)
def ts_to_seconds(ts):
    parts = ts.split(":")
    if len(parts) == 3:
        return int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2])
    return int(parts[0]) * 60 + int(parts[1])

chapters = []
with open(chapters_path) as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        match = re.match(r'^(\d{1,2}:\d{2}(?::\d{2})?)\s+(.+)$', line)
        if match:
            chapters.append((ts_to_seconds(match.group(1)), match.group(2)))

if not chapters:
    print("Error: no chapters found in file")
    sys.exit(1)

# Parse raw.json segments
with open(raw_json_path) as f:
    raw = json.load(f)

if "result" in raw and isinstance(raw["result"], str):
    data = json.loads(raw["result"])
else:
    data = raw
segments = data["transcript"]["segments"]

# Remove old ch-XX-raw.txt files
for fname in os.listdir(scratchpad):
    if re.match(r'ch-\d+-raw\.txt$', fname):
        os.remove(os.path.join(scratchpad, fname))

# Split and write
for i, (start, title) in enumerate(chapters):
    end = chapters[i + 1][0] if i + 1 < len(chapters) else 999999
    ch_segments = [text for ts, text in segments if ts >= start and ts < end]
    raw_text = " ".join(ch_segments)

    fname = f"ch-{i + 1:02d}-raw.txt"
    path = os.path.join(scratchpad, fname)
    with open(path, "w") as f:
        f.write(raw_text)

    print(f"{fname}: {len(ch_segments)} segments, {len(raw_text)} chars")

print(f"\n{len(chapters)} chapters split")
PYEOF
