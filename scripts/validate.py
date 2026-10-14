#!/usr/bin/env python3
"""Check catalog paths, theme contracts, generated files, and executable syntax."""
import configparser
import json
from pathlib import Path
import re
import subprocess
import sys

REPO = Path(__file__).resolve().parents[1]


def validate():
    themes = json.loads((REPO / "theme-catalog.json").read_text())["themes"]
    ids = [theme["id"] for theme in themes]
    assert len(ids) == len(set(ids)), "Duplicate theme IDs"
    actual = {p.name for p in (REPO / "themes").iterdir() if p.is_dir()}
    assert actual == set(ids), "Catalog does not match theme directories"
    for theme in themes:
        id = theme["id"]
        assert re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", id), f"Unsafe theme ID: {id}"
        directory = REPO / "themes" / id
        for key in ("wallpaper", "thumbnail"):
            asset = Path(theme[key])
            assert not asset.is_absolute() and ".." not in asset.parts, f"Unsafe {id} asset"
            assert (directory / asset).is_file(), f"Missing {id}/{asset}"
        for name in ("Main.qml", "theme.conf", "metadata.desktop"):
            assert (directory / name).is_file(), f"Missing {id}/{name}"
        conf = configparser.ConfigParser(interpolation=None)
        conf.read(directory / "theme.conf")
        assert conf.get("General", "background") == theme["wallpaper"], f"Background drift: {id}"
        assert conf.get("General", "accent"), f"Missing accent: {id}"
        qml = (directory / "Main.qml").read_text()
        assert "config.background" in qml and "config.accent" in qml, f"Unused configuration: {id}"
        assert "Common.AuthController" in qml and "Common.LoginStatus" in qml, f"Missing authentication feedback: {id}"
        assert "sddm.login(" not in qml, f"Authentication bypasses controller: {id}"
        for asset in re.findall(r'(?:source|fallbackSource):\s*(?:Qt.resolvedUrl\()?"(assets/[^"]+)"', qml):
            assert (directory / asset).is_file(), f"Missing QML asset: {id}/{asset}"
        metadata = configparser.ConfigParser(interpolation=None)
        metadata.read(directory / "metadata.desktop")
        assert metadata.get("SddmGreeterTheme", "QtVersion") in ("5", "6"), f"Missing Qt runtime: {id}"
    subprocess.run([sys.executable, str(REPO / "scripts/generate.py"), "--check"], check=True)
    for file in REPO.glob("*.sh"):
        subprocess.run(["bash", "-n", str(file)], check=True)
    for file in (REPO / "website").glob("*.js"):
        subprocess.run(["node", "--check", str(file)], check=True)
    # Compile Python source without creating bytecode in the repository.
    for file in (REPO / "scripts").glob("*.py"):
        compile(file.read_text(), str(file), "exec")
    print(f"Validated {len(themes)} themes, generated files, and script syntax.")


if __name__ == "__main__":
    validate()
