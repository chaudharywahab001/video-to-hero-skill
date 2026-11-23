---
name: video-to-hero
description: Turn a short video into a scroll-scrubbed cinematic hero section - extract a WebP image sequence, read its palette and focus point, and ship a canvas that scrubs frames on scroll. Use when a landing page needs a hero that feels like film, or when the user points at a video and says "build this".
---

# video-to-hero

Technique learned from @designwithalok (Instagram, 23 Nov 2026): most people save an
inspiration clip, he builds a website from it. The method is a scroll-driven image
sequence: the video becomes a stack of WebP frames, and scroll position selects the
frame. Scroll forward and the film plays forward; scroll back and it rewinds.

## The four steps

1. **Spark** - find a clip that stops the scroll. Judge motion, not subject: slow
   drift, a single focus point, a clear depth change reads well scrubbed. A fast cut
   or camera whip reads as stutter.
2. **Plan** - read the clip like a designer. Composition (where the subject sits, how
   much negative space is left for text), focus point (what the eye lands on, so the
   headline never covers it), palette (what the type and accent colours must be to
   stay legible over every frame, not just the first).
3. **Build** - keep the best 5 to 8 seconds. Extract frames as WebP at quality ~72:
   roughly half the bytes of JPG at matched quality. Budget 150 to 250 frames total.
   Fewer frames means visible steps; more means a download nobody waits for.
4. **Ship** - load in a smart order: every Nth frame first so the scrub works almost
   immediately, then fill the gaps in the background. Draw to a canvas, never swap
   `img.src`, and only redraw when the frame index actually changes.

## Run it

```bash
bash /app/.agents/skills/video-to-hero/scripts/run.sh <video> <outdir> [fps] [headline] [subhead]
```

Outputs `<outdir>/frames/frame_0001.webp...` plus `<outdir>/hero.html`, a
self-contained page that references those frames. The script prints the frame count,
total kilobytes and the extracted palette.

Read the palette before choosing colours. `palette.py` reports the six dominant
colours, average luma and the share of dark pixels, and picks a text colour that
survives both bright and dark frames.

## Rules that keep it from looking cheap

- **Licensing first.** Learn from any clip; never ship someone else's footage. Use
  your own capture or licensed stock. The reel that taught this method credits
  @loxxtuz for the footage and that is not a licence to reuse it.
- Cap width at 1280px. A hero is a backdrop, not a photograph; 4K frames are bytes
  spent on nothing.
- `prefers-reduced-motion` gets a static first frame and no scrub. Do not animate
  someone who asked you not to.
- Never hijack the scrollbar with scroll-jacking. The section should be tall (250 to
  300vh) and sticky, so the page scrolls normally while the frame index follows it.
- Text contrast must hold against the worst frame, not the average. If the clip goes
  bright, add a gradient scrim instead of picking a bolder font.
- Mobile: cap `devicePixelRatio` at 2 and consider dropping fps to 8. Test on a real
  phone, because a desktop canvas at 60fps hides jank that a mid-range Android shows.

## What this skill does not do

It cannot choose a good clip or decide the layout. Those are taste calls made in step
2, and the palette output only informs them.
