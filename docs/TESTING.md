# Development and testing

## Automated checks

Python checks use the standard library. JavaScript syntax checks require Node.js. Installer tests stage files inside temporary directories and never write `/etc` or `/usr/share`.

```bash
python3 scripts/validate.py
python3 -m unittest discover -s tests -v
```

Tests cover traversal rejection, symlink destinations, concurrent installation, Qt metadata replacement, package-manager errors, successful backups, conversion failure, and configuration-write rollback.

For QML checks, install a C++ compiler, `pkg-config`, Qt Quick/QML development packages and the matching Controls, Layouts, Window and model modules:

```bash
python3 scripts/check_qml.py --qt 5
python3 scripts/check_qml.py --qt 6
```

The harness instantiates all 44 themes with fake users, sessions and SDDM signals. It verifies configuration, missing last-user/session indices, duplicate login prevention, error feedback, and password clearing. It runs offscreen and never contacts PAM or the SDDM daemon. The GitHub Actions matrix installs both Qt runtimes independently.

Render the actual QML and exercise its controls at 1920×1080, 1366×768, 1024×768, 800×600 and 3440×1440:

```bash
python3 scripts/check_qml.py --qt 6 --render build/theme-layouts
```

This checks that visible username, password, sign-in and system controls fit on screen and that login controls do not overlap the footer. It clicks each visible sign-in button, submits with Enter, checks the selected session, and verifies that authentication failure clears and refocuses the visible password. An empty last-user value exercises the first-account fallback. CI runs this on both Qt versions and uploads screenshots for seven days.

Open `build/theme-layouts/index.html` to browse the screenshot gallery and switch resolutions.

Screenshots use the shipped still thumbnails for videos. They establish layout and input behavior, not GIF playback, real PAM authentication, or every desktop's font and DPI settings. Inspect generated screenshots as well as the automated results.

Browser checks exercise animation paths, interrupted autoplay startup, stale media callbacks, search, clipboard failure, keyboard selection, mobile layout and reduced motion:

```bash
npm ci
npx playwright install chromium
npm test
```

Requests are fulfilled from local repository files; external font requests are blocked. Screenshots are written to `build/website-tests/`.

## Manual checks

```bash
./test_all.sh marvel neon-gif --qt 6
```

Inspect the actual greeter layout, session selection, username input and keyboard focus on your display. Test at your normal resolution and display scaling. The runner reports early greeter exits, retains logs, and cleans up the process and temporary assets when interrupted. A successful manual preview is not evidence of successful real authentication: SDDM test mode deliberately disables it.

## Media tools

```bash
# Import named MP4s; explicitly permit replacing existing source assets:
python3 scripts/copy_mp4s.py /path/to/videos --overwrite
# Convert videos in a supplied directory using bounded settings:
python3 scripts/mp4_to_gif.py /path/to/videos --fps 12 --width 1280 --duration 15
```

The old one-off patch and GIF recovery scripts were removed. The supported installer and preview runner now perform those operations without personal filesystem paths or modifications to unrelated source files.

## Generated files and deployment

```bash
python3 scripts/generate.py
python3 scripts/generate.py --check
python3 scripts/build_site.py
```

Review `build/site/` before deployment. This directory contains the website, redirect and catalog media, rather than the full development repository. Files in `build/`, Python bytecode and local dependencies are ignored by Git.
