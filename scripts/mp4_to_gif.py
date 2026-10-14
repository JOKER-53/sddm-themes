#!/usr/bin/env python3
"""Bounded MP4 conversion with isolated temporary files and explicit failures."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def convert_mp4_to_gif(input_path, output_path, fps=12, scale=1280, duration=15):
    input_path, output_path = Path(input_path), Path(output_path)
    if not input_path.is_file():
        raise ValueError(f"Input does not exist: {input_path}")
    if not (1 <= fps <= 30 and 320 <= scale <= 1920 and 0 < duration <= 60):
        raise ValueError("Conversion bounds: fps 1–30, width 320–1920, duration 0–60 seconds.")
    if not shutil.which("ffmpeg"):
        raise RuntimeError("FFmpeg is required for animated themes. Install ffmpeg and retry.")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".sddm-gif-", dir=output_path.parent) as directory:
        palette = Path(directory) / "palette.png"
        rendered = Path(directory) / "wallpaper.gif"
        filters = f"fps={fps},scale=w='min({scale},iw)':h=-1:flags=lanczos"
        commands = [
            ["ffmpeg", "-nostdin", "-y", "-v", "error", "-threads", "2", "-t", str(duration), "-i", str(input_path), "-filter_threads", "1", "-vf", filters + ",palettegen=stats_mode=diff", "-frames:v", "1", str(palette)],
            ["ffmpeg", "-nostdin", "-y", "-v", "error", "-threads", "2", "-t", str(duration), "-i", str(input_path), "-i", str(palette), "-filter_complex_threads", "1", "-filter_complex", filters + "[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle", "-loop", "0", str(rendered)],
        ]
        for command in commands:
            result = subprocess.run(command, capture_output=True, text=True)
            if result.returncode:
                raise RuntimeError(f"FFmpeg failed for {input_path.name}: {result.stderr.strip()}")
        if not rendered.is_file() or rendered.stat().st_size == 0:
            raise RuntimeError("FFmpeg produced an empty animation.")
        os.replace(rendered, output_path)
    return output_path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path, nargs="?", default=Path("."))
    parser.add_argument("--fps", type=int, default=12)
    parser.add_argument("--width", type=int, default=1280)
    parser.add_argument("--duration", type=float, default=15)
    args = parser.parse_args()
    files = sorted(args.directory.glob("*.mp4"))
    if not files:
        parser.error("No MP4 files found in the supplied directory.")
    for video in files:
        print(convert_mp4_to_gif(video, video.with_suffix(".gif"), args.fps, args.width, args.duration))


if __name__ == "__main__":
    main()
