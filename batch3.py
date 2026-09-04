import os
import urllib.request
import subprocess
from pathlib import Path
from mp4_to_gif import convert_mp4_to_gif
import re

download_dir = Path("/home/joker53/Downloads/new batch")
target_dir = Path("/home/joker53/Projects/sddm-themes")

themes_data = [
    {"mp4": "cat-pond.mp4", "id": "cat-pond", "name": "CAT POND", "font": "Mali", "layout": "bottom-right", "accent": "#4caf50", "tag": "tranquil nature vibe"},
    {"mp4": "cosmic-gateway.mp4", "id": "cosmic-gateway", "name": "COSMIC GATEWAY", "font": "Orbitron", "layout": "top-right", "accent": "#9c27b0", "tag": "deep space portal"},
    {"mp4": "Everst.mp4", "id": "everest", "name": "MT. EVEREST", "font": "Cinzel", "layout": "bottom-left", "accent": "#00bcd4", "tag": "snowy peak minimal"},
    {"mp4": "fish-in-rock-pond.mp4", "id": "fish-in-rock-pond", "name": "KOI POND", "font": "Yusei Magic", "layout": "top-left", "accent": "#ff9800", "tag": "zen rock pool"},
    {"mp4": "moonlit-rooftop-cat.mp4", "id": "moonlit-rooftop-cat", "name": "MOONLIT ROOFTOP", "font": "Patrick Hand", "layout": "bottom-right", "accent": "#673ab7", "tag": "lo-fi starry night"},
    {"mp4": "neverness-to-everness.mp4", "id": "neverness-to-everness", "name": "NTE ANIME", "font": "Shojumaru", "layout": "bottom-left", "accent": "#e91e63", "tag": "action character frame"},
    {"mp4": "nissan-skyline.mp4", "id": "nissan-skyline", "name": "NISSAN SKYLINE", "font": "Russo One", "layout": "bottom-right", "accent": "#f44336", "tag": "r34 pure JDM"},
    {"mp4": "ocean-in-jar.mp4", "id": "ocean-in-jar", "name": "OCEAN JAR", "font": "Comfortaa", "layout": "bottom-left", "accent": "#03a9f4", "tag": "surreal desktop pet"},
    {"mp4": "pink-bloom.mp4", "id": "pink-bloom", "name": "PINK BLOOM", "font": "Pacifico", "layout": "bottom-right", "accent": "#e91e63", "tag": "soft floral pastel"},
    {"mp4": "pirates_of_the_caribbean.mp4", "id": "pirates-of-the-caribbean", "name": "BLACK PEARL", "font": "Pirata One", "layout": "bottom-right", "accent": "#795548", "tag": "cinematic stormy sea"},
    {"mp4": "pixel-gaming-room.mp4", "id": "pixel-gaming-room", "name": "PIXEL GAMING", "font": "VT323", "layout": "bottom-right", "accent": "#8bc34a", "tag": "retro 8-bit den"},
    {"mp4": "pixel-sakura-city.mp4", "id": "pixel-sakura-city", "name": "PIXEL SAKURA", "font": "VT323", "layout": "bottom-left", "accent": "#f06292", "tag": "retro tokyo dusk"},
    {"mp4": "pokeball.mp4", "id": "pokeball", "name": "POKEBALL", "font": "Chewy", "layout": "bottom-right", "accent": "#f44336", "tag": "clean catch layout"},
    {"mp4": "super-mario-pixel.mp4", "id": "super-mario-pixel", "name": "SUPER MARIO", "font": "VT323", "layout": "top-right", "accent": "#e52521", "tag": "nostalgic 8-bit"},
]

qml_anchors = {
    "bottom-right": "anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60;",
    "bottom-left": "anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 60;",
    "top-right": "anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 60;",
    "top-left": "anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 60;"
}

js_anchors = {
    "bottom-right": "bottom:60px; right:60px;",
    "bottom-left": "bottom:60px; left:60px;",
    "top-right": "top:60px; right:60px;",
    "top-left": "top:60px; left:60px;"
}

power_qml = """
        Row {
            anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 20; spacing: 15
            ComboBox {
                id: sessionCombo; width: 120; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex; font.pixelSize: 11
                background: Rectangle { color: "#99000000"; radius: 4; border.color: "#4dffffff" }
                contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            }
            Rectangle {
                width: 80; height: 30; color: "#99000000"; radius: 4; border.color: "#4dffffff"
                Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.pixelSize: 11; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
            }
            Rectangle {
                width: 90; height: 30; color: "#99000000"; radius: 4; border.color: "#ff2e63"
                Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
            }
        }
"""

def generate_qml(t):
    return f"""import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {{
    width: 1920; height: 1080; color: "#000"
    AnimatedImage {{ anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }}
    FontLoader {{ id: customFont; source: "assets/font.ttf" }}
    
    Rectangle {{
        {qml_anchors[t['layout']]} width: 400; height: 260; color: "#aadddddd"; radius: 15; border.color: "{t['accent']}"; border.width: 4
        Column {{
            anchors.centerIn: parent; spacing: 15
            Text {{ text: "{t['name']}"; font.family: customFont.name; font.pixelSize: 42; color: "#000" }}
            ComboBox {{
                id: u; width: 280; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle {{ color: "#fff"; border.color: "{t['accent']}"; border.width: 2 }}
                contentItem: Text {{ text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#000"; anchors.centerIn: parent }}
            }}
            TextField {{
                id: p; width: 280; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#000"
                background: Rectangle {{ color: "#fff"; border.color: "{t['accent']}"; border.width: 2 }}
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }}
        }}
    }}
{power_qml}
}}
"""

new_fonts = set()
new_themes_js = []
new_layouts_js = []

for t in themes_data:
    print(f"--- Processing {t['id']} ---")
    theme_dir = target_dir / t['id']
    assets_dir = theme_dir / "assets"
    assets_dir.mkdir(parents=True, exist_ok=True)
    
    # Write QML files
    (theme_dir / "Main.qml").write_text(generate_qml(t))
    (theme_dir / "metadata.desktop").write_text(f"[SddmGreeterTheme]\nName={t['name']}\nDescription={t['tag']}\nAuthor=JOKER53\nTheme-Id={t['id']}\nType=sddm-theme\nVersion=1.0\nMainScript=Main.qml\nConfigFile=theme.conf\n")
    (theme_dir / "theme.conf").write_text("[General]\n")
    
    # Download Font
    font_url = f"https://fonts.googleapis.com/css2?family={t['font'].replace(' ', '+')}&text=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*().,REBOOTSHUTDOWN"
    try:
        req = urllib.request.Request(font_url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
        css = urllib.request.urlopen(req).read().decode()
        ttf_url = re.search(r'url\((https://[^)]+\.ttf)\)', css).group(1)
        urllib.request.urlretrieve(ttf_url, assets_dir / "font.ttf")
        print(f"Downloaded font: {t['font']}")
        new_fonts.add(t['font'].replace(' ', '+'))
    except Exception as e:
        print(f"Failed to download font {t['font']}: {e}")
    
    # Convert MP4 to GIF
    mp4_file = download_dir / t['mp4']
    gif_file = assets_dir / "wallpaper.gif"
    jpg_file = assets_dir / "thumbnail.jpg"
    
    if mp4_file.exists():
        print("Converting to GIF...")
        # Reduce scale to 720p or similar for reasonable file sizes for massive batch?
        # Actually user wants no loss. We'll use default scale=-1
        subprocess.run(["python3", "mp4_to_gif.py"], env={**os.environ, "INPUT": str(mp4_file), "OUTPUT": str(gif_file)}, stdout=subprocess.DEVNULL)
        
        # Extract Thumbnail
        print("Extracting Thumbnail...")
        subprocess.run(["ffmpeg", "-y", "-i", str(gif_file), "-vf", "scale=640:-1", "-vframes", "1", str(jpg_file)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    else:
        print(f"MISSING FILE: {mp4_file}")
        
    # JS snippets
    new_themes_js.append(f'  {{ id: "{t["id"]}", name: "{t["name"]}", wp: "./{t["id"]}/assets/wallpaper.gif", tag: "{t["tag"]}", accent: "{t["accent"]}" }},')
    new_layouts_js.append(f'  "{t["id"]}": (n) => `\n    <div style="font-family:\'{t["font"]}\', sans-serif; position:absolute; {js_anchors[t["layout"]]} width:400px; height:260px; background:rgba(221,221,221,0.67); border:4px solid {t["accent"]}; border-radius:15px; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:15px; z-index:3;">\n      <div style="font-size:42px; color:#000;">{t["name"]}</div>\n      <div style="width:280px; height:50px; background:#fff; border:2px solid {t["accent"]}; font-size:24px; color:#000; text-align:center; line-height:46px;">${{USER}} ▾</div>\n      <div style="width:280px; height:50px; background:#fff; border:2px solid {t["accent"]}; font-size:24px; color:#000; text-align:center; line-height:46px; letter-spacing:4px;">••••••••</div>\n    </div><div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,')

# Save fonts to index.html
with open(target_dir / "index.html", "r") as f:
    html = f.read()
new_font_link = f'<link href="https://fonts.googleapis.com/css2?family={"&family=".join(list(new_fonts))}&display=swap" rel="stylesheet">'
html = html.replace("</head>", f"  {new_font_link}\n</head>")
with open(target_dir / "index.html", "w") as f:
    f.write(html)

# Save JS snippets
with open(target_dir / "script.js", "r") as f:
    js = f.read()
    
themes_str = "\n".join(new_themes_js)
layouts_str = "\n".join(new_layouts_js)

js = re.sub(r'(];\n\nconst \$)', themes_str + r'\n\1', js, count=1)
js = re.sub(r'(};\n\nfunction render)', layouts_str + r'\n\1', js, count=1)

with open(target_dir / "script.js", "w") as f:
    f.write(js)
    
print("BATCH 3 COMPLETE!")
