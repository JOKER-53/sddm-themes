# SDDM Themes ! 

For reference visit the showcase → **[kadhiravaneg.github.io/sddm-themes](https://kadhiravaneg.github.io/sddm-themes)**

44 self-contained SDDM (Qt5/Qt6) themes, each built around one of the
reference wallpapers with a **deliberately different layout structure** —
no shared components, no copy-paste UI. Pick the one you want and install it.

## 44 Themes Gallery

| Theme | Preview | Theme | Preview | Theme | Preview |
|---|---|---|---|---|---|
| `alienx` | <img src="alienx/assets/wallpaper.png" width="250"> | `bmw` | <img src="bmw/assets/wallpaper.jpg" width="250"> | `bmw-m3` | <img src="bmw-m3/assets/thumbnail.jpg" width="250"> |
| `cat-pond` | <img src="cat-pond/assets/thumbnail.jpg" width="250"> | `classic-jdm` | <img src="classic-jdm/assets/wallpaper.jpg" width="250"> | `cosmic-gateway` | <img src="cosmic-gateway/assets/thumbnail.jpg" width="250"> |
| `deadpool` | <img src="deadpool/assets/wallpaper.jpg" width="250"> | `dodge` | <img src="dodge/assets/thumbnail.jpg" width="250"> | `drag-racer` | <img src="drag-racer/assets/wallpaper.jpg" width="250"> |
| `everest` | <img src="everest/assets/thumbnail.jpg" width="250"> | `fish-in-rock-pond` | <img src="fish-in-rock-pond/assets/thumbnail.jpg" width="250"> | `gojo` | <img src="gojo/assets/wallpaper.png" width="250"> |
| `hilda-and-tepig` | <img src="hilda-and-tepig/assets/thumbnail.jpg" width="250"> | `hitagi-senjougahara` | <img src="hitagi-senjougahara/assets/thumbnail.jpg" width="250"> | `hoodie` | <img src="hoodie/assets/thumbnail.jpg" width="250"> |
| `joker` | <img src="joker/assets/wallpaper.jpg" width="250"> | `kawaii` | <img src="kawaii/assets/wallpaper.png" width="250"> | `marvel` | <img src="marvel/assets/wallpaper.jpg" width="250"> |
| `mazda-mx5` | <img src="mazda-mx5/assets/thumbnail.jpg" width="250"> | `moonlit-rooftop-cat` | <img src="moonlit-rooftop-cat/assets/thumbnail.jpg" width="250"> | `mount-fuji` | <img src="mount-fuji/assets/thumbnail.jpg" width="250"> |
| `mountain-sunset` | <img src="mountain-sunset/assets/thumbnail.jpg" width="250"> | `neko-anime` | <img src="neko-anime/assets/thumbnail.jpg" width="250"> | `neon-gif` | <img src="neon-gif/assets/thumbnail.jpg" width="250"> |
| `neverness-to-everness` | <img src="neverness-to-everness/assets/thumbnail.jpg" width="250"> | `nissan` | <img src="nissan/assets/thumbnail.jpg" width="250"> | `nissan-skyline` | <img src="nissan-skyline/assets/thumbnail.jpg" width="250"> |
| `ocean-in-jar` | <img src="ocean-in-jar/assets/thumbnail.jpg" width="250"> | `oni-anime-girl` | <img src="oni-anime-girl/assets/thumbnail.jpg" width="250"> | `oni-robot` | <img src="oni-robot/assets/thumbnail.jpg" width="250"> |
| `pink-bloom` | <img src="pink-bloom/assets/thumbnail.jpg" width="250"> | `pirates-of-the-caribbean` | <img src="pirates-of-the-caribbean/assets/thumbnail.jpg" width="250"> | `pixel-gaming-room` | <img src="pixel-gaming-room/assets/thumbnail.jpg" width="250"> |
| `pixel-sakura-city` | <img src="pixel-sakura-city/assets/thumbnail.jpg" width="250"> | `pokeball` | <img src="pokeball/assets/thumbnail.jpg" width="250"> | `purrple-cat` | <img src="purrple-cat/assets/thumbnail.jpg" width="250"> |
| `rdr2` | <img src="rdr2/assets/wallpaper.jpg" width="250"> | `sakura-lake` | <img src="sakura-lake/assets/thumbnail.jpg" width="250"> | `spiderman` | <img src="spiderman/assets/thumbnail.jpg" width="250"> |
| `spiderverse` | <img src="spiderverse/assets/thumbnail.jpg" width="250"> | `super-mario-pixel` | <img src="super-mario-pixel/assets/thumbnail.jpg" width="250"> | `the-dark-river` | <img src="the-dark-river/assets/thumbnail.jpg" width="250"> |
| `zoro-blue` | <img src="zoro-blue/assets/thumbnail.jpg" width="250"> | `zoro-dragon` | <img src="zoro-dragon/assets/thumbnail.jpg" width="250"> | | |

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
