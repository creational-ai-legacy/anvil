#!/usr/bin/env bash
#
# vp-assemble.sh — Replace one chapter placeholder with cleaned text
#
# Usage: vp-assemble.sh <clean_file> <target_doc>
#
# Example: vp-assemble.sh /tmp/scratchpad/ch-03-clean.txt ~/docs/vp/vp-video.md
#
# Reads ch-XX-clean.txt, replaces <!-- VP-CH-XX --> in the target document.

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <clean_file> <target_doc>" >&2
    exit 1
fi

CLEAN_FILE="$1"
TARGET="$2"

if [[ ! -f "$CLEAN_FILE" ]]; then
    echo "Error: clean file not found: $CLEAN_FILE" >&2
    exit 1
fi

if [[ ! -f "$TARGET" ]]; then
    echo "Error: target document not found: $TARGET" >&2
    exit 1
fi

python3 - "$CLEAN_FILE" "$TARGET" << 'PYEOF'
import os, re, sys

clean_path = sys.argv[1]
target = sys.argv[2]

fname = os.path.basename(clean_path)
match = re.match(r"ch-(\d+)-clean\.txt", fname)
if not match:
    print(f"Error: filename must match ch-XX-clean.txt, got: {fname}")
    sys.exit(1)

ch_num = match.group(1)
placeholder = f"<!-- VP-CH-{ch_num} -->"

with open(clean_path) as f:
    clean_text = f.read().strip()

with open(target) as f:
    doc = f.read()

if placeholder not in doc:
    print(f"{placeholder} not found (already replaced?)")
    sys.exit(0)

doc = doc.replace(placeholder, clean_text)

with open(target, "w") as f:
    f.write(doc)

remaining = len(re.findall(r"<!-- VP-CH-\d+ -->", doc))
print(f"{placeholder} replaced ({len(clean_text):,} chars) | {remaining} remaining")
PYEOF
