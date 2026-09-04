#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path

def convert_mp4_to_gif(input_path, output_path, fps=24, scale=-1):
    print(f"Converting: {input_path.name} -> {output_path.name}")
    palette_path = "temp_palette.png"

    # Scale filter setup: -1 maintains original resolution
    scale_filter = f",scale={scale}:-1:flags=lanczos" if scale != -1 else ""

    # Pass 1: Generate a custom, optimal color palette for the video.
    # This is the secret to high-quality / "lossless" GIF conversions.
    palette_cmd = [
        "ffmpeg", "-y", "-i", str(input_path),
        "-vf", f"fps={fps}{scale_filter},palettegen=stats_mode=diff",
        palette_path
    ]

    # Pass 2: Use the generated palette to create the GIF with dithering.
    gif_cmd = [
        "ffmpeg", "-y", "-i", str(input_path), "-i", palette_path,
        "-filter_complex", f"fps={fps}{scale_filter}[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle",
        str(output_path)
    ]

    try:
        # Run Pass 1
        subprocess.run(palette_cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # Run Pass 2
        subprocess.run(gif_cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"  [SUCCESS] Saved {output_path.name}")
    except subprocess.CalledProcessError:
        print(f"  [ERROR] Failed to convert {input_path.name}")
    finally:
        # Cleanup temporary palette file
        if os.path.exists(palette_path):
            os.remove(palette_path)

def batch_convert(directory="."):
    # Check if ffmpeg is installed
    try:
        subprocess.run(["ffmpeg", "-version"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("Error: FFmpeg is not installed or not in PATH.")
        print("Please install it (e.g., 'sudo pacman -S ffmpeg' or 'sudo apt install ffmpeg')")
        sys.exit(1)

    p = Path(directory)
    mp4_files = list(p.glob("*.mp4"))

    if not mp4_files:
        print(f"No .mp4 files found in '{directory}'")
        return

    print(f"Found {len(mp4_files)} MP4 files. Starting high-quality conversion...")
    
    # You can change fps here (lower fps = smaller file size)
    # You can change scale here (e.g. scale=1280 to resize to 720p, or -1 to keep exact original resolution)
    for mp4_file in mp4_files:
        gif_name = mp4_file.with_suffix(".gif")
        convert_mp4_to_gif(mp4_file, gif_name, fps=24, scale=-1)

if __name__ == "__main__":
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    batch_convert(target_dir)
