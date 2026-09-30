#!/usr/bin/env python3
"""Preview staged packages without writing generated media into the repository."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time

from install import catalog, detect_qt, greeter_name, prepare_theme, theme_source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("themes", nargs="*")
    parser.add_argument("--qt", type=int, choices=(5, 6))
    parser.add_argument("--log-dir", type=Path, default=Path("build/preview-logs"))
    args = parser.parse_args()
    qt = args.qt or detect_qt()
    greeter = greeter_name(qt)
    args.log_dir.mkdir(parents=True, exist_ok=True)
    names = args.themes or [t["id"] for t in catalog()]
    # Validate all requested IDs before generating any media.
    sources = [(name, theme_source(name)) for name in names]
    failures = []
    for name, source in sources:
        log = args.log_dir / f"{name}.log"
        with tempfile.TemporaryDirectory(prefix="sddm-preview-") as directory:
            stage = Path(directory) / name
            print(f"Preparing {name}…", flush=True)
            try:
                prepare_theme(source, stage, qt, fps=12, width=854, duration=5)
            except (RuntimeError, ValueError, OSError) as error:
                failures.append(name)
                log.write_text(str(error) + "\n")
                print(f"FAILED {name}: {error}", file=sys.stderr)
                continue
            with log.open("w") as stream:
                process = subprocess.Popen([greeter, "--test-mode", "--theme", str(stage)], stdout=stream, stderr=subprocess.STDOUT)
                try:
                    time.sleep(1)
                    if process.poll() is not None:
                        failures.append(name)
                        print(f"FAILED {name}: greeter exited early ({process.returncode}); see {log}", file=sys.stderr)
                        continue
                    input(f"Previewing {name}. Inspect the theme, then press Enter (Ctrl+C exits): ")
                    if process.poll() is not None and process.returncode != 0:
                        failures.append(name)
                finally:
                    if process.poll() is None:
                        process.terminate()
                        try:
                            process.wait(timeout=5)
                        except subprocess.TimeoutExpired:
                            process.kill()
                            process.wait()
    if failures:
        print("Preview failures: " + ", ".join(failures), file=sys.stderr)
        return 1
    print(f"Completed {len(names)} manual previews. Logs: {args.log_dir}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (KeyboardInterrupt, EOFError):
        print("\nPreview stopped; temporary packages and greeter cleaned up.", file=sys.stderr)
        sys.exit(130)
