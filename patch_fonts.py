import os
import subprocess
import re

fonts = {
    "zoro-dragon": ("Shojumaru", "https://raw.githubusercontent.com/google/fonts/main/ofl/shojumaru/Shojumaru-Regular.ttf"),
    "bmw-m3": ("Audiowide", "https://raw.githubusercontent.com/google/fonts/main/ofl/audiowide/Audiowide-Regular.ttf"),
    "nissan": ("Russo One", "https://raw.githubusercontent.com/google/fonts/main/ofl/russoone/RussoOne-Regular.ttf"),
    "oni-anime-girl": ("Rajdhani", "https://raw.githubusercontent.com/google/fonts/main/ofl/rajdhani/Rajdhani-Bold.ttf"),
    "mazda-mx5": ("Righteous", "https://raw.githubusercontent.com/google/fonts/main/ofl/righteous/Righteous-Regular.ttf"),
    "oni-robot": ("VT323", "https://raw.githubusercontent.com/google/fonts/main/ofl/vt323/VT323-Regular.ttf"),
    "dodge": ("Bebas Neue", "https://raw.githubusercontent.com/google/fonts/main/ofl/bebasneue/BebasNeue-Regular.ttf"),
}

for theme, (font_name, url) in fonts.items():
    print(f"Patching {theme} with {font_name}...")
    font_path = f"{theme}/assets/font.ttf"
    subprocess.run(["curl", "-sL", url, "-o", font_path])
    
    qml_file = f"{theme}/Main.qml"
    with open(qml_file, "r") as f:
        content = f.read()
    
    if "FontLoader" not in content:
        # insert FontLoader after Rectangle {
        content = re.sub(r'Rectangle \{\n', 'Rectangle {\n    FontLoader { id: customFont; source: "assets/font.ttf" }\n', content, count=1)
        
    # replace font.family: "Monospace" (or Impact) with customFont.name
    content = re.sub(r'font\.family:\s*"[^"]+"', 'font.family: customFont.name', content)
    
    with open(qml_file, "w") as f:
        f.write(content)

