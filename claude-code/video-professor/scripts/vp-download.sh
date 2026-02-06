#!/usr/bin/env bash
#
# vp-download.sh — Download raw.json from a presigned S3 URL
#
# Usage: vp-download.sh <presigned_url> <scratchpad_dir>
#
# Example: vp-download.sh "https://s3.amazonaws.com/..." /tmp/scratchpad/

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <presigned_url> <scratchpad_dir>" >&2
    exit 1
fi

URL="$1"
SCRATCHPAD="$2"
OUTPUT="$SCRATCHPAD/raw.json"

rm -rf "$SCRATCHPAD"/*
mkdir -p "$SCRATCHPAD"

curl -s -o "$OUTPUT" "$URL"

BYTES=$(wc -c < "$OUTPUT")
echo "OK: $BYTES bytes -> $OUTPUT"
