import os
import sys
from pathlib import Path

# Add current dir to path to import mp4_to_gif
sys.path.append(os.getcwd())
from mp4_to_gif import convert_mp4_to_gif

src_dirs = ["/home/joker53/Desktop/profile", "/home/joker53/Desktop/profile/new batch"]
repo_dir = "/home/joker53/Projects/sddm-themes"

mapping = {
    "Everst.mp4": "everest",
    "pirates_of_the_caribbean.mp4": "pirates-of-the-caribbean",
    "neon-cars.mp4": "neon-gif"
}

mp4s = []
for d in src_dirs:
    mp4s.extend(list(Path(d).glob("*.mp4")))

print(f"Found {len(mp4s)} MP4s to convert. This will take some time...")

for i, mp4 in enumerate(mp4s, 1):
    theme_name = mapping.get(mp4.name, mp4.stem)
    dest_dir = Path(repo_dir) / theme_name / "assets"
    
    if not dest_dir.exists():
        print(f"[{i}/{len(mp4s)}] Skipping {mp4.name}, theme folder '{theme_name}' not found.")
        continue
    
    dest_gif = dest_dir / "wallpaper.gif"
    if dest_gif.exists():
        print(f"[{i}/{len(mp4s)}] Skipping {theme_name}, GIF already exists.")
        continue
        
    print(f"[{i}/{len(mp4s)}] Converting {mp4.name} -> {theme_name}/assets/wallpaper.gif")
    convert_mp4_to_gif(mp4, dest_gif, fps=24, scale=-1)

print("\n--- ALL CONVERSIONS COMPLETE ---")
