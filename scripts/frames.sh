#!/usr/bin/env bash
# Extract a scroll-scrub image sequence from a video.
# usage: frames.sh <video> <outdir> [fps] [width] [quality]
set -euo pipefail
IN="$1"; OUT="$2"; FPS="${3:-12}"; W="${4:-1280}"; Q="${5:-72}"
mkdir -p "$OUT"
rm -f "$OUT"/frame_*.webp
ffmpeg -hide_banner -loglevel error -i "$IN" \
  -vf "fps=$FPS,scale=$W:-2:flags=lanczos" \
  -c:v libwebp -quality "$Q" -compression_level 6 -preset picture \
  "$OUT/frame_%04d.webp"
COUNT=$(ls "$OUT"/frame_*.webp | wc -l)
BYTES=$(du -sk "$OUT" | cut -f1)
echo "frames=$COUNT dir_kb=$BYTES avg_kb=$((BYTES / (COUNT>0?COUNT:1)))"
