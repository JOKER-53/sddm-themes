#!/usr/bin/env python3
"""Stage only website files and catalog media for GitHub Pages."""
import json
from pathlib import Path
import shutil

REPO = Path(__file__).resolve().parents[1]


def main():
    destination = REPO / "build/site"
    if destination.exists():
        shutil.rmtree(destination)
    destination.mkdir(parents=True)
    shutil.copy2(REPO / "index.html", destination / "index.html")
    shutil.copytree(REPO / "website", destination / "website")
    for theme in json.loads((REPO / "theme-catalog.json").read_text())["themes"]:
        for asset in {theme["wallpaper"], theme["thumbnail"]}:
            target = destination / "themes" / theme["id"] / asset
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(REPO / "themes" / theme["id"] / asset, target)
    print(destination)


if __name__ == "__main__":
    main()
