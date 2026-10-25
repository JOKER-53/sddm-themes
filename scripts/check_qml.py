#!/usr/bin/env python3
"""Compile and instantiate every theme against Qt with fake SDDM models."""
import argparse
import html
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--qt", choices=("5", "6"), default="6")
    parser.add_argument("--render", type=Path, help="Render five screen sizes and check visible control bounds; write screenshots here")
    args = parser.parse_args()
    flags = shlex.split(subprocess.check_output(["pkg-config", "--cflags", "--libs", f"Qt{args.qt}Quick", f"Qt{args.qt}Qml", f"Qt{args.qt}Test"], text=True))
    with tempfile.TemporaryDirectory(prefix="sddm-qml-check-") as directory:
        binary = Path(directory) / "qml-review"
        subprocess.run(["g++", "-std=c++17", "-fPIC", str(REPO / "tests/qml_review.cpp"), "-o", str(binary), *flags], check=True)
        env = dict(os.environ, QT_QPA_PLATFORM="offscreen", QT_QUICK_BACKEND="software", QT_QPA_PLATFORMTHEME="", QT_STYLE_OVERRIDE="Fusion", QT_QUICK_CONTROLS_STYLE="Basic" if args.qt == "6" else "Default")
        command = [str(binary), str(REPO)]
        if args.render:
            command.append(str(args.render.resolve()))
        subprocess.run(command, env=env, check=True)
        if args.render:
            render_gallery(args.render)


def render_gallery(destination):
    themes = json.loads((REPO / "theme-catalog.json").read_text())["themes"]
    cards = "".join(
        f'<article><h2>{html.escape(theme["name"])}</h2><a data-theme="{theme["id"]}" href="{theme["id"]}-1920x1080.png"><img loading="lazy" src="{theme["id"]}-1920x1080.png" alt="{html.escape(theme["name"])} greeter"></a></article>'
        for theme in themes
    )
    (destination / "index.html").write_text('''<!doctype html>
<html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Theme layout review</title>
<style>body{margin:24px;background:#17191e;color:#fff;font:16px sans-serif}h1{font-size:28px}p{color:#d4dbe2}select{padding:10px;font:inherit}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:24px;margin-top:24px}h2{font-size:18px}img{display:block;width:100%;border:1px solid #56616b}a:focus-visible{outline:3px solid #fff}</style>
<h1>Theme layout review</h1><p>44 native QML themes. Select a screen size; click an image to inspect it at full resolution. Videos use their shipped thumbnails.</p>
<label for="resolution">Screen size </label><select id="resolution"><option>1920x1080</option><option>1366x768</option><option>1024x768</option><option>800x600</option><option>3440x1440</option></select>
<label><input type="checkbox" id="failure"> Show login failure</label>
<main>''' + cards + '''</main><script>function update(){for(const link of document.querySelectorAll('[data-theme]')){link.href=link.dataset.theme+'-'+document.querySelector('select').value+(document.querySelector('#failure').checked?'-failure':'')+'.png';link.firstElementChild.src=link.href;}}document.querySelector('select').addEventListener('change',update);document.querySelector('#failure').addEventListener('change',update);</script></html>''')



if __name__ == "__main__":
    main()
