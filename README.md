# video-to-hero

An agent skill that turns a short video into a scroll-scrubbed cinematic hero section:
it extracts a WebP image sequence, reads the clip's palette and picks a legible text
colour, then generates a page where scrolling moves the film forward and scrolling back
rewinds it.

Works with any agent that can run bash and ffmpeg: Claude Code, Codex, Base44 Superagent,
or a plain shell.

## Install

Copy the `video-to-hero` folder into your agent's skills directory:

```bash
# Base44 Superagent
cp -r video-to-hero /app/.agents/skills/
# Claude Code / Codex
cp -r video-to-hero ~/.claude/skills/
```

Requires `ffmpeg` with libwebp. No Python packages needed.

## Use

```bash
bash video-to-hero/scripts/run.sh <video> <outdir> [fps] [headline] [subhead]
```

Outputs `<outdir>/frames/frame_0001.webp...` and `<outdir>/hero.html`, a self-contained
page that references them. It prints frame count, total kilobytes and the palette.

## The method

1. **Spark** - pick a clip with slow motion and one focus point. Fast cuts scrub badly.
2. **Plan** - read composition, focus point and palette, so the headline never covers
   the subject and the type stays legible over every frame.
3. **Build** - keep 5 to 8 seconds, extract 150 to 250 WebP frames at quality ~72,
   roughly half the bytes of JPG at matched quality.
4. **Ship** - sticky 250 to 300vh section, canvas draw, every Nth frame preloaded first
   so the scrub works immediately, and a static frame for `prefers-reduced-motion`.

## Licence

MIT. The technique was learned from @designwithalok's Instagram reel, which credits
@loxxtuz for the footage. Learn from any clip; ship only footage you own or licence.
