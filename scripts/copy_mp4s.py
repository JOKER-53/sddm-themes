#!/usr/bin/env python3
"""Import named MP4 files into catalog themes from user-supplied directories."""
import argparse
import json
from pathlib import Path
import shutil

REPO = Path(__file__).resolve().parents[1]
ALIASES = {"everst": "everest", "neon-cars": "neon-gif"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directories", type=Path, nargs="+")
    parser.add_argument("--overwrite", action="store_true", help="Replace existing wallpapers intentionally")
    args = parser.parse_args()
    themes = {t["id"]: t for t in json.loads((REPO / "theme-catalog.json").read_text())["themes"]}
    planned = {}
    for directory in args.directories:
        if not directory.is_dir():
            parser.error(f"Directory not found: {directory}")
        for video in sorted(directory.glob("*.mp4")):
            stem = video.stem.lower().replace("_", "-")
            theme = ALIASES.get(stem, stem)
            if theme not in themes or not themes[theme]["animated"]:
                print(f"Skipping {video.name}: no animated catalog theme")
                continue
            if theme in planned:
                parser.error(f"Multiple source videos map to {theme}")
            destination = REPO / "themes" / theme / themes[theme]["wallpaper"]
            if destination.exists() and not args.overwrite:
                parser.error(f"{destination} already exists; use --overwrite to replace it")
            planned[theme] = (video, destination)
    for theme, (source, destination) in planned.items():
        shutil.copy2(source, destination)
        print(f"Imported {theme}: {source}")


if __name__ == "__main__":
    main()
