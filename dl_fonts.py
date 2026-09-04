import urllib.request
import re
from pathlib import Path

target_dir = Path("/home/joker53/Projects/sddm-themes")

themes_data = [
    {"id": "cat-pond", "font": "Mali"},
    {"id": "cosmic-gateway", "font": "Orbitron"},
    {"id": "everest", "font": "Cinzel"},
    {"id": "fish-in-rock-pond", "font": "Yusei Magic"},
    {"id": "moonlit-rooftop-cat", "font": "Patrick Hand"},
    {"id": "neverness-to-everness", "font": "Shojumaru"},
    {"id": "nissan-skyline", "font": "Russo One"},
    {"id": "ocean-in-jar", "font": "Comfortaa"},
    {"id": "pink-bloom", "font": "Pacifico"},
    {"id": "pirates-of-the-caribbean", "font": "Pirata One"},
    {"id": "pixel-gaming-room", "font": "VT323"},
    {"id": "pixel-sakura-city", "font": "VT323"},
    {"id": "pokeball", "font": "Chewy"},
    {"id": "super-mario-pixel", "font": "VT323"},
]

for t in themes_data:
    print(f"Downloading font for {t['id']}")
    assets_dir = target_dir / t['id'] / "assets"
    font_url = f"https://fonts.googleapis.com/css2?family={t['font'].replace(' ', '+')}&text=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*().,REBOOTSHUTDOWN"
    try:
        req = urllib.request.Request(font_url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko'})
        css = urllib.request.urlopen(req).read().decode()
        url = re.search(r'url\((https://[^)]+)\)', css).group(1)
        # Safely save it as font.ttf (FreeType can read woff)
        urllib.request.urlretrieve(url, assets_dir / "font.ttf")
    except Exception as e:
        print(f"Failed to download font {t['font']}: {e}")
        
print("DONE")
