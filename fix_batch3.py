import os
import urllib.request
import subprocess
from pathlib import Path
from mp4_to_gif import convert_mp4_to_gif
import re

download_dir = Path("/home/joker53/Downloads/new batch")
target_dir = Path("/home/joker53/Projects/sddm-themes")

themes_data = [
    {"mp4": "cat-pond.mp4", "id": "cat-pond", "font": "Mali"},
    {"mp4": "cosmic-gateway.mp4", "id": "cosmic-gateway", "font": "Orbitron"},
    {"mp4": "Everst.mp4", "id": "everest", "font": "Cinzel"},
    {"mp4": "fish-in-rock-pond.mp4", "id": "fish-in-rock-pond", "font": "Yusei Magic"},
    {"mp4": "moonlit-rooftop-cat.mp4", "id": "moonlit-rooftop-cat", "font": "Patrick Hand"},
    {"mp4": "neverness-to-everness.mp4", "id": "neverness-to-everness", "font": "Shojumaru"},
    {"mp4": "nissan-skyline.mp4", "id": "nissan-skyline", "font": "Russo One"},
    {"mp4": "ocean-in-jar.mp4", "id": "ocean-in-jar", "font": "Comfortaa"},
    {"mp4": "pink-bloom.mp4", "id": "pink-bloom", "font": "Pacifico"},
    {"mp4": "pirates_of_the_caribbean.mp4", "id": "pirates-of-the-caribbean", "font": "Pirata One"},
    {"mp4": "pixel-gaming-room.mp4", "id": "pixel-gaming-room", "font": "VT323"},
    {"mp4": "pixel-sakura-city.mp4", "id": "pixel-sakura-city", "font": "VT323"},
    {"mp4": "pokeball.mp4", "id": "pokeball", "font": "Chewy"},
    {"mp4": "super-mario-pixel.mp4", "id": "super-mario-pixel", "font": "VT323"},
]

for t in themes_data:
    print(f"Fixing {t['id']}")
    theme_dir = target_dir / t['id']
    assets_dir = theme_dir / "assets"
    
    # 1. Download Font
    font_url = f"https://fonts.googleapis.com/css2?family={t['font'].replace(' ', '+')}&text=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*().,REBOOTSHUTDOWN"
    try:
        # Force TTF by mimicking IE11
        req = urllib.request.Request(font_url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko'})
        css = urllib.request.urlopen(req).read().decode()
        ttf_url = re.search(r'url\((https://[^)]+\.ttf)\)', css).group(1)
        urllib.request.urlretrieve(ttf_url, assets_dir / "font.ttf")
    except Exception as e:
        print(f"Failed to download font {t['font']}: {e}")
        
    # 2. Convert GIF
    mp4_file = download_dir / t['mp4']
    gif_file = assets_dir / "wallpaper.gif"
    jpg_file = assets_dir / "thumbnail.jpg"
    
    if mp4_file.exists():
        if not gif_file.exists() or gif_file.stat().st_size < 1000:
            convert_mp4_to_gif(mp4_file, gif_file, fps=24, scale=-1)
            
        subprocess.run(["ffmpeg", "-y", "-i", str(gif_file), "-vf", "scale=640:-1", "-vframes", "1", str(jpg_file)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

print("FIX COMPLETE")
