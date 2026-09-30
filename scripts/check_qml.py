#!/usr/bin/env python3
"""Compile and instantiate every theme against Qt with fake SDDM models."""
import argparse
import os
from pathlib import Path
import shlex
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--qt", choices=("5", "6"), default="6")
    args = parser.parse_args()
    flags = shlex.split(subprocess.check_output(["pkg-config", "--cflags", "--libs", f"Qt{args.qt}Quick", f"Qt{args.qt}Qml"], text=True))
    with tempfile.TemporaryDirectory(prefix="sddm-qml-check-") as directory:
        binary = Path(directory) / "qml-review"
        subprocess.run(["g++", "-std=c++17", "-fPIC", str(REPO / "tests/qml_review.cpp"), "-o", str(binary), *flags], check=True)
        env = dict(os.environ, QT_QPA_PLATFORM="offscreen", QT_QUICK_BACKEND="software", QT_QPA_PLATFORMTHEME="", QT_STYLE_OVERRIDE="Fusion", QT_QUICK_CONTROLS_STYLE="Basic" if args.qt == "6" else "Default")
        subprocess.run([str(binary), str(REPO)], env=env, check=True)


if __name__ == "__main__":
    main()
