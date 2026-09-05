import os
import shutil
from pathlib import Path

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

for mp4 in mp4s:
    theme_name = mapping.get(mp4.name, mp4.stem)
    dest_dir = Path(repo_dir) / theme_name / "assets"
    
    if not dest_dir.exists():
        continue
    
    dest_mp4 = dest_dir / "wallpaper.mp4"
    print(f"Copying {mp4.name} -> {theme_name}/assets/wallpaper.mp4")
    shutil.copy2(mp4, dest_mp4)

