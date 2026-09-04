# SDDM Themes ! 

For reference visit the showcase → **[kadhiravaneg.github.io/sddm-themes](https://kadhiravaneg.github.io/sddm-themes)**

44 self-contained SDDM (Qt5/Qt6) themes, each built around one of the
reference wallpapers with a **deliberately different layout structure** —
no shared components, no copy-paste UI. Pick the one you want and install it.

## 44 Themes Gallery

| Theme | Preview | Theme | Preview | Theme | Preview |
|---|---|---|---|---|---|
| `alienx` | ![Preview](alienx/assets/wallpaper.png) | `bmw` | ![Preview](bmw/assets/wallpaper.jpg) | `bmw-m3` | ![Preview](bmw-m3/assets/thumbnail.jpg) |
| `cat-pond` | ![Preview](cat-pond/assets/thumbnail.jpg) | `classic-jdm` | ![Preview](classic-jdm/assets/wallpaper.jpg) | `cosmic-gateway` | ![Preview](cosmic-gateway/assets/thumbnail.jpg) |
| `deadpool` | ![Preview](deadpool/assets/wallpaper.jpg) | `dodge` | ![Preview](dodge/assets/thumbnail.jpg) | `drag-racer` | ![Preview](drag-racer/assets/wallpaper.jpg) |
| `everest` | ![Preview](everest/assets/thumbnail.jpg) | `fish-in-rock-pond` | ![Preview](fish-in-rock-pond/assets/thumbnail.jpg) | `gojo` | ![Preview](gojo/assets/wallpaper.png) |
| `hilda-and-tepig` | ![Preview](hilda-and-tepig/assets/thumbnail.jpg) | `hitagi-senjougahara` | ![Preview](hitagi-senjougahara/assets/thumbnail.jpg) | `hoodie` | ![Preview](hoodie/assets/thumbnail.jpg) |
| `joker` | ![Preview](joker/assets/wallpaper.jpg) | `kawaii` | ![Preview](kawaii/assets/wallpaper.png) | `marvel` | ![Preview](marvel/assets/wallpaper.jpg) |
| `mazda-mx5` | ![Preview](mazda-mx5/assets/thumbnail.jpg) | `moonlit-rooftop-cat` | ![Preview](moonlit-rooftop-cat/assets/thumbnail.jpg) | `mount-fuji` | ![Preview](mount-fuji/assets/thumbnail.jpg) |
| `mountain-sunset` | ![Preview](mountain-sunset/assets/thumbnail.jpg) | `neko-anime` | ![Preview](neko-anime/assets/thumbnail.jpg) | `neon-gif` | ![Preview](neon-gif/assets/thumbnail.jpg) |
| `neverness-to-everness` | ![Preview](neverness-to-everness/assets/thumbnail.jpg) | `nissan` | ![Preview](nissan/assets/thumbnail.jpg) | `nissan-skyline` | ![Preview](nissan-skyline/assets/thumbnail.jpg) |
| `ocean-in-jar` | ![Preview](ocean-in-jar/assets/thumbnail.jpg) | `oni-anime-girl` | ![Preview](oni-anime-girl/assets/thumbnail.jpg) | `oni-robot` | ![Preview](oni-robot/assets/thumbnail.jpg) |
| `pink-bloom` | ![Preview](pink-bloom/assets/thumbnail.jpg) | `pirates-of-the-caribbean` | ![Preview](pirates-of-the-caribbean/assets/thumbnail.jpg) | `pixel-gaming-room` | ![Preview](pixel-gaming-room/assets/thumbnail.jpg) |
| `pixel-sakura-city` | ![Preview](pixel-sakura-city/assets/thumbnail.jpg) | `pokeball` | ![Preview](pokeball/assets/thumbnail.jpg) | `purrple-cat` | ![Preview](purrple-cat/assets/thumbnail.jpg) |
| `rdr2` | ![Preview](rdr2/assets/wallpaper.jpg) | `sakura-lake` | ![Preview](sakura-lake/assets/thumbnail.jpg) | `spiderman` | ![Preview](spiderman/assets/thumbnail.jpg) |
| `spiderverse` | ![Preview](spiderverse/assets/thumbnail.jpg) | `super-mario-pixel` | ![Preview](super-mario-pixel/assets/thumbnail.jpg) | `the-dark-river` | ![Preview](the-dark-river/assets/thumbnail.jpg) |
| `zoro-blue` | ![Preview](zoro-blue/assets/thumbnail.jpg) | `zoro-dragon` | ![Preview](zoro-dragon/assets/thumbnail.jpg) | | |

---

## Requirements

Install these before running the install script.

| Distro       | Command                                                                 |
| ------------ | ----------------------------------------------------------------------- |
| **Arch**     | `pacman -S sddm qt5-quickcontrols2 qt5-graphicaleffects qt5-declarative` |
| **Fedora**   | `dnf install sddm qt5-qtdeclarative qt5-qtgraphicaleffects`             |
| **Debian/Ubuntu** | `apt install sddm qml-module-qtquick2 qml-module-qtgraphicaleffects qml-module-qtquick-controls2` |
| **openSUSE** | `zypper install sddm libqt5-qtdeclarative qt5-graphicaleffects`         |

> The install script auto-detects your Qt version (Qt5 or Qt6) and patches
> import lines automatically — no manual editing needed.

---

## Install

```bash
git clone https://github.com/KADHIRAVANEG/sddm-themes
cd sddm-themes
sudo ./install.sh marvel        # replace marvel with any theme id above
systemctl restart sddm          # or reboot
```

The script:
- Detects Qt5 / Qt6 and patches QML imports automatically
- Copies the theme to `/usr/share/sddm/themes/<id>`
- Sets `Current=<id>` in `/etc/sddm.conf`
- Backs up any existing theme before overwriting

---

## Preview without rebooting

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/marvel
# Qt6 systems:
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/marvel
```

---

## Customize

Each theme has its own `theme.conf` with a `brand` accent colour and
`background` path. Drop in a different wallpaper at
`<theme>/assets/wallpaper.*` and reinstall.

```ini
[General]
background=assets/wallpaper.jpg
brand=#ed1d24
```

---

## Showcase website

A static showcase is included at the repo root — plain HTML / CSS / JS,
zero build step.

```bash
# open directly
xdg-open index.html

# or serve locally
python3 -m http.server 8000
```

---

## Structure

```
sddm-themes/
├── README.md
├── install.sh
├── index.html              ← showcase website
├── styles.css
├── script.js
├── marvel/
├── classic-jdm/
├── alienx/
├── drag-racer/
├── gojo/
├── kawaii/
├── joker/
├── rdr2/
├── deadpool/
├── bmw/
└── <each theme>/
    ├── Main.qml
    ├── metadata.desktop
    ├── theme.conf
    └── assets/wallpaper.{jpg,png}
```

## Flow chart

```mermaid
flowchart LR
    %% Styling Definitions
    classDef root fill:#2c3e50,stroke:#34495e,stroke-width:2px,color:#fff;
    classDef script fill:#f1c40f,stroke:#f39c12,stroke-width:2px,color:#000;
    classDef web fill:#3498db,stroke:#2980b9,stroke-width:2px,color:#fff;
    classDef theme fill:#8e44ad,stroke:#7d3c98,stroke-width:2px,color:#fff;
    classDef asset fill:#ecf0f1,stroke:#bdc3c7,stroke-width:1px,color:#2c3e50;

    Root[sddm-themes]:::root
    
    %% Repository Root Files
    Root --> Readme[README.md]:::asset
    Root --> Install[install.sh]:::script
    Root --> Web[Showcase Website]:::web
    
    %% Website components
    Web --> Index[index.html]:::web
    Web --> CSS[styles.css]:::web
    Web --> JS[script.js]:::web

    %% Theme Collections
    Root --> Themes[Theme Directories]:::theme
    
    Themes --> Marvel[marvel/]:::theme
    Themes --> JDM[classic-jdm/]:::theme
    Themes --> Alien[alienx/]:::theme
    Themes --> More[...]
    Themes --> Joker[joker/]:::theme
    
    %% Theme Anatomy (Example)
    Marvel --> QML[Main.qml]:::asset
    Marvel --> Meta[metadata.desktop]:::asset
    Marvel --> Conf[theme.conf]:::asset
    Marvel --> Assets[assets/]:::asset
    Assets --> Wallpaper[wallpaper.jpg/png]:::asset
```

---

## Notes

- SDDM ≥ 0.19 required
- These themes only render on a real Linux machine with SDDM/Qt installed —
  the web showcase displays wallpapers and metadata only
- Tested on Arch Linux with Hyprland and KDE Plasma

---

## License

MIT — see [LICENSE](LICENSE)
