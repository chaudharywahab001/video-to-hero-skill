#!/usr/bin/env bash
# Build a scroll-scrub hero from a video: frames + palette + demo page.
# usage: run.sh <video> <outdir> [fps] [headline] [subhead]
set -euo pipefail
IN="$1"; OUT="$2"; FPS="${3:-12}"
HEAD="${4:-Built from a clip that stopped the scroll.}"; SUB="${5:-Scroll forward and the film moves forward. Scroll back and it rewinds.}"
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$OUT"
STATS=$("$HERE/frames.sh" "$IN" "$OUT/frames" "$FPS")
COUNT=$(echo "$STATS" | sed -n 's/.*frames=\([0-9]*\).*/\1/p')
KB=$(echo "$STATS" | sed -n 's/.*dir_kb=\([0-9]*\).*/\1/p')
PAL=$("$HERE/palette.py" "$OUT/frames")
TEXT=$(echo "$PAL" | python3 -c "import sys,json;print(json.load(sys.stdin)['text_color'])")
ACC=$(echo "$PAL" | python3 -c "import sys,json;print(json.load(sys.stdin)['palette'][0]['hex'])")
python3 - "$HERE/../assets/demo-template.html" "$OUT/hero.html" "$COUNT" "$KB" "$TEXT" "$ACC" "$HEAD" "$SUB" <<'PY'
import sys
tpl,out,count,kb,text,acc,head,sub=sys.argv[1:9]
h=open(tpl).read()
for k,v in {"{{FRAME_COUNT}}":count,"{{FRAME_KB}}":kb,"{{TEXT_COLOR}}":text,
            "{{ACCENT}}":acc,"{{HEADLINE}}":head,"{{SUBHEAD}}":sub,
            "{{FRAME_PATTERN}}":"frames/frame_####.webp","{{SCROLL_VH}}":"300"}.items():
    h=h.replace(k,v)
open(out,"w").write(h)
print("hero.html written")
PY
echo "STATS $STATS"
echo "PALETTE $PAL"
