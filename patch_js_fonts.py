import re

with open("script.js", "r") as f:
    content = f.read()

font_map = {
    "zoro-dragon": "'Shojumaru', cursive",
    "bmw-m3": "'Audiowide', sans-serif",
    "nissan": "'Russo One', sans-serif",
    "oni-anime-girl": "'Rajdhani', sans-serif",
    "mazda-mx5": "'Righteous', cursive",
    "oni-robot": "'VT323', monospace",
    "dodge": "'Bebas Neue', sans-serif",
}

for theme, font_name in font_map.items():
    # Find the block for the theme
    pattern = rf'("{theme}": \(n\) => `\n.*?)(`,\n)'
    
    def repl(m):
        block = m.group(1)
        # Check if we have an outer container we can apply font-family to
        if "font-family:monospace" in block or "font-family:Impact" in block or "font-family:sans-serif" in block:
            block = re.sub(r'font-family:[^;]+;', f"font-family:{font_name};", block)
        # If it doesn't have font-family in the block, we inject it into the first style=""
        else:
            block = re.sub(r'style="', f'style="font-family:{font_name}; ', block, count=1)
        return block + m.group(2)
        
    content = re.sub(pattern, repl, content, flags=re.DOTALL)

with open("script.js", "w") as f:
    f.write(content)
