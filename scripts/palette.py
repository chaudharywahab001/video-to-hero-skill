#!/usr/bin/env python3
"""Dominant palette + brightness + focus hint from video frames. No PIL needed."""
import subprocess, sys, collections, json, glob, os

def rgb_of(path, w=32, h=18):
    raw = subprocess.run(["ffmpeg","-v","quiet","-i",path,"-vf",f"scale={w}:{h}","-f","rawvideo",
                          "-pix_fmt","rgb24","-"], capture_output=True).stdout
    px=[(raw[i],raw[i+1],raw[i+2]) for i in range(0,len(raw)-2,3)]
    return px

def hexof(c): return "#%02x%02x%02x" % c

def analyze(frames):
    buckets=collections.Counter(); lum=[]; weighted=[]
    for f in frames:
        for (r,g,b) in rgb_of(f):
            buckets[(r//32*32, g//32*32, b//32*32)]+=1
            weighted.append((0.2126*r+0.7152*g+0.0722*b))
            lum.append(0.2126*r+0.7152*g+0.0722*b)
    total=sum(buckets.values()) or 1
    top=[{"hex":hexof(c),"share":round(n/total,3)} for c,n in buckets.most_common(6)]
    avg=sum(lum)/len(lum) if lum else 0
    lo=sum(1 for x in lum if x<90)/len(lum) if lum else 0
    return {"palette":top,"avg_luma":round(avg,1),"dark_share":round(lo,3)}

if __name__=="__main__":
    d=sys.argv[1]
    frames=sorted(glob.glob(os.path.join(d,"frame_*.webp")))
    if not frames: print(json.dumps({"error":"no frames"})); sys.exit(1)
    pick=[frames[0], frames[len(frames)//2], frames[-1]]
    res=analyze(pick)
    res["frames_analyzed"]=len(pick)
    res["text_color"]="#f5f3ef" if res["dark_share"]>0.35 else "#111111"
    print(json.dumps(res,indent=1))
