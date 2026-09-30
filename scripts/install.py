#!/usr/bin/env python3
"""Prepare an SDDM theme completely before replacing the installed package."""
import argparse
import configparser
import fcntl
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone

from mp4_to_gif import convert_mp4_to_gif

REPO = Path(__file__).resolve().parents[1]
ID_PATTERN = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*\Z")


def catalog():
    return json.loads((REPO / "theme-catalog.json").read_text())["themes"]


def theme_source(theme):
    if not ID_PATTERN.fullmatch(theme) or theme not in {t["id"] for t in catalog()}:
        raise ValueError(f"Unknown theme ID: {theme!r}. Use --list to see available themes.")
    source = REPO / "themes" / theme
    if source.is_symlink() or source.resolve().parent != (REPO / "themes").resolve():
        raise ValueError("Theme must be a direct directory inside themes/.")
    for file in source.rglob("*"):
        if file.is_symlink():
            raise ValueError(f"Theme contains a symlink: {file}")
    for name in ("Main.qml", "metadata.desktop", "theme.conf"):
        if not (source / name).is_file():
            raise ValueError(f"Theme is missing {name}.")
    return source


def detect_qt():
    if shutil.which("sddm-greeter-qt6"):
        return 6
    greeter = shutil.which("sddm-greeter")
    if greeter:
        result = subprocess.run(["ldd", greeter], capture_output=True, text=True, check=True)
        return 6 if "libQt6" in result.stdout else 5
    raise RuntimeError("No SDDM greeter found. Install SDDM first, or use --qt with --root for staging.")


def greeter_name(qt):
    if qt == 6 and shutil.which("sddm-greeter-qt6"):
        return "sddm-greeter-qt6"
    executable = shutil.which("sddm-greeter")
    if executable:
        result = subprocess.run(["ldd", executable], capture_output=True, text=True, check=True)
        actual = 6 if "libQt6" in result.stdout else 5
        if actual == qt:
            return "sddm-greeter"
    raise RuntimeError(f"No Qt{qt} SDDM greeter is installed.")


def dependency_packages(manager, qt):
    packages = {
        "pacman": {5: ["qt5-declarative", "qt5-quickcontrols2"], 6: ["qt6-declarative"]},
        "apt": {
            5: ["qml-module-qtquick2", "qml-module-qtquick-controls2", "qml-module-qtquick-layouts", "qml-module-qtquick-window2", "qml-module-qtqml-models2"],
            6: ["qml6-module-qtquick", "qml6-module-qtquick-controls", "qml6-module-qtquick-layouts", "qml6-module-qtquick-window", "qml6-module-qtquick-templates", "qml6-module-qtqml-workerscript"],
        },
        "dnf": {5: ["qt5-qtdeclarative", "qt5-qtquickcontrols2"], 6: ["qt6-qtdeclarative"]},
        "zypper": {5: ["libqt5-qtdeclarative", "libqt5-qtquickcontrols2"], 6: ["qt6-declarative"]},
    }
    return packages[manager][qt]


def check_dependencies(qt):
    manager = next((m for m in ("pacman", "apt", "dnf", "zypper") if shutil.which(m)), None)
    if manager is None:
        raise RuntimeError("Unsupported package manager. Install the QML modules manually and use --skip-deps.")
    missing = []
    for package in dependency_packages(manager, qt):
        if manager == "apt":
            result = subprocess.run(["dpkg-query", "-W", "-f=${Status}", package], capture_output=True, text=True)
            installed = result.returncode == 0 and result.stdout.strip() == "install ok installed"
        else:
            check = ["pacman", "-Q", package] if manager == "pacman" else ["rpm", "-q", package]
            installed = subprocess.run(check, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
        if not installed:
            missing.append(package)
    if missing:
        commands = {
            "pacman": ["pacman", "-S", "--needed", "--noconfirm"],
            "apt": ["apt-get", "install", "-y"],
            "dnf": ["dnf", "install", "-y"],
            "zypper": ["zypper", "--non-interactive", "install"],
        }
        if manager == "apt":
            subprocess.run(["apt-get", "update"], check=True)
        subprocess.run(commands[manager] + missing, check=True)


def set_ini_value(text, section, key, value):
    """Change only this section/key, preserving comments and unrelated settings."""
    lines = text.splitlines(keepends=True)
    start = next((i for i, line in enumerate(lines) if line.strip() == f"[{section}]"), None)
    if start is None:
        return text.rstrip() + f"\n\n[{section}]\n{key}={value}\n"
    end = next((i for i in range(start + 1, len(lines)) if lines[i].lstrip().startswith("[")), len(lines))
    output = lines[:start + 1]
    replaced = False
    for line in lines[start + 1:end]:
        if re.match(rf"\s*{re.escape(key)}\s*=", line):
            if not replaced:
                output.append(f"{key}={value}\n")
                replaced = True
        else:
            output.append(line)
    if not replaced:
        if output and not output[-1].endswith("\n"):
            output[-1] += "\n"
        output.append(f"{key}={value}\n")
    return "".join(output + lines[end:])


def safe_directory(path, root):
    """Reject symlink parents before creating or replacing system files."""
    root = root.absolute()
    path = path.absolute()
    path.relative_to(root)
    for part in [path, *path.parents]:
        if part.is_symlink():
            raise ValueError(f"Refusing symlink path: {part}")
        if part == root:
            break


def prepare_theme(source, stage, qt, fps=12, width=1280, duration=15):
    shutil.copytree(source, stage, dirs_exist_ok=True)
    shutil.copytree(REPO / "common", stage / "components", dirs_exist_ok=True)
    metadata = stage / "metadata.desktop"
    metadata.write_text(set_ini_value(metadata.read_text(), "SddmGreeterTheme", "QtVersion", str(qt)))
    settings = configparser.ConfigParser(interpolation=None)
    settings.read(stage / "theme.conf")
    background = settings.get("General", "background")
    asset = stage / background
    if Path(background).is_absolute() or ".." in Path(background).parts or not asset.is_file():
        raise ValueError(f"Invalid or missing configured background: {background}")
    if asset.suffix.lower() == ".mp4":
        gif = asset.with_suffix(".gif")
        convert_mp4_to_gif(asset, gif, fps=fps, scale=width, duration=duration)
        conf = stage / "theme.conf"
        conf.write_text(set_ini_value(conf.read_text(), "General", "background", gif.relative_to(stage).as_posix()))
        asset.unlink()  # Remove only the unused staged copy; preserve repository media.
    for file in stage.rglob("*"):
        file.chmod(0o755 if file.is_dir() else 0o644)
    stage.chmod(0o755)


def install_theme(source, theme, qt, root, *, fps=12, width=1280, duration=15):
    root = Path(root).absolute()
    base = root / "usr/share/sddm/themes"
    safe_directory(base / theme, root)
    safe_directory(base / ".install.lock", root)
    # Validate before creating any destination directories.
    if source.resolve() != theme_source(theme).resolve():
        raise ValueError("Source does not match the catalog theme.")
    base.mkdir(parents=True, exist_ok=True)
    descriptor = os.open(base / ".install.lock", os.O_CREAT | os.O_RDWR | os.O_NOFOLLOW, 0o600)
    with os.fdopen(descriptor, "r+") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise RuntimeError("Another theme installation is running. Retry after it finishes.") from error
        return _install_theme(source, theme, qt, root, fps=fps, width=width, duration=duration)


def _install_theme(source, theme, qt, root, *, fps=12, width=1280, duration=15):
    # Revalidate even when called directly by a preview tool.
    if source.resolve() != theme_source(theme).resolve():
        raise ValueError("Source does not match the catalog theme.")
    root = Path(root).absolute()
    base = root / "usr/share/sddm/themes"
    conf = root / "etc/sddm.conf"
    destination = base / theme
    safe_directory(destination, root)
    safe_directory(conf, root)
    base.mkdir(parents=True, exist_ok=True)
    conf.parent.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S_%f")
    backup = base / f"{theme}.bak.{stamp}"
    original_conf = conf.read_bytes() if conf.exists() else None
    config_temp = None
    moved_old = published = False
    with tempfile.TemporaryDirectory(prefix=f".{theme}-", dir=base) as work:
        stage = Path(work) / "theme"
        prepare_theme(source, stage, qt, fps, width, duration)
        updated = set_ini_value((original_conf or b"").decode(), "Theme", "Current", theme)
        descriptor, name = tempfile.mkstemp(prefix=".sddm-conf-", dir=conf.parent)
        config_temp = Path(name)
        try:
            with os.fdopen(descriptor, "w") as stream:
                stream.write(updated)
                stream.flush()
                os.fsync(stream.fileno())
            config_temp.chmod(conf.stat().st_mode & 0o777 if conf.exists() else 0o644)
            if original_conf is not None:
                shutil.copy2(conf, conf.with_name(f"sddm.conf.bak.{stamp}"))
            if destination.exists():
                destination.rename(backup)
                moved_old = True
            stage.rename(destination)
            published = True
            os.replace(config_temp, conf)
            config_temp = None
        except BaseException:
            if published:
                shutil.rmtree(destination)
            if moved_old:
                backup.rename(destination)
            raise
        finally:
            if config_temp is not None:
                config_temp.unlink(missing_ok=True)
    return destination, backup if moved_old else None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("theme", nargs="?")
    parser.add_argument("--list", action="store_true", help="List theme IDs without requiring root")
    parser.add_argument("--qt", type=int, choices=(5, 6))
    parser.add_argument("--dry-run", action="store_true", help="Show the plan without writing or installing dependencies")
    parser.add_argument("--root", type=Path, default=Path("/"), help="Stage into an alternate root; skips host dependency installation")
    parser.add_argument("--skip-deps", action="store_true")
    parser.add_argument("--fps", type=int, default=12)
    parser.add_argument("--width", type=int, default=1280)
    parser.add_argument("--duration", type=float, default=15)
    args = parser.parse_args()
    if args.list:
        print("\n".join(t["id"] for t in catalog()))
        return
    if args.theme is None:
        rows = catalog()
        for i, theme in enumerate(rows, 1):
            print(f"{i:2}. {theme['id']}")
        try:
            choice = int(input("Theme number: "))
            if not 1 <= choice <= len(rows):
                raise ValueError("Theme number is out of range.")
            args.theme = rows[choice - 1]["id"]
        except (ValueError, EOFError) as error:
            parser.error(str(error))
    source = theme_source(args.theme)
    if not (1 <= args.fps <= 30 and 320 <= args.width <= 1920 and 0 < args.duration <= 60):
        parser.error("Use fps 1–30, width 320–1920, and duration greater than 0 and at most 60 seconds.")
    qt = args.qt or detect_qt()
    real_system = args.root.resolve() == Path("/")
    greeter = greeter_name(qt) if real_system else ("sddm-greeter-qt6" if qt == 6 else "sddm-greeter")
    print(f"Theme: {args.theme}; Qt: {qt}; destination: {args.root / 'usr/share/sddm/themes' / args.theme}")
    if args.dry_run:
        return
    if real_system and os.geteuid() != 0:
        parser.error("Installing to the system requires sudo.")
    settings = configparser.ConfigParser(interpolation=None)
    settings.read(source / "theme.conf")
    if Path(settings.get("General", "background")).suffix.lower() == ".mp4" and not shutil.which("ffmpeg"):
        raise RuntimeError("FFmpeg is required for animated themes. Install ffmpeg and retry.")
    if real_system and not args.skip_deps:
        check_dependencies(qt)
    destination, backup = install_theme(source, args.theme, qt, args.root, fps=args.fps, width=args.width, duration=args.duration)
    print(f"Installed: {destination}")
    if backup:
        print(f"Previous theme: {backup}")
    print(f"Preview: {greeter} --test-mode --theme {destination}")
    print("SDDM will use the theme on the next login. Save your work before restarting SDDM from a TTY.")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, RuntimeError, OSError, subprocess.CalledProcessError) as error:
        print(f"Installation failed: {error}", file=sys.stderr)
        sys.exit(1)
