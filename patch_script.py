import re

with open("script.js", "r") as f:
    content = f.read()

# Replace wpUrl logic
new_wp_url = """
const PNG_IDS = new Set(["alienx", "gojo", "kawaii"]);
const JPG_IDS = new Set(["marvel", "classic-jdm", "drag-racer", "joker", "rdr2", "deadpool", "bmw"]);

function wpUrl(id) {
  if (PNG_IDS.has(id)) return `${id}/assets/wallpaper.png`;
  if (JPG_IDS.has(id)) return `${id}/assets/wallpaper.jpg`;
  return `${id}/assets/wallpaper.mp4`;
}
"""

content = re.sub(
    r'const PNG_IDS = new Set\(\["alienx", "gojo", "kawaii"\]\);.*?return `\$\{id\}/assets/wallpaper\.gif`;\n}',
    new_wp_url.strip(),
    content,
    flags=re.DOTALL
)

# Update DOM elements
content = content.replace('const $bg = document.getElementById("spotlightBg");', 
                          'const $bg = document.getElementById("spotlightBg");\nconst $vid = document.getElementById("spotlightVideo");')

# Update goTo function
new_goto = """
function goTo(idx) {
  activeIndex = ((idx % themes.length) + themes.length) % themes.length;
  const t = themes[activeIndex];

  $bg.style.opacity = "0";
  $vid.style.opacity = "0";

  const targetUrl = wpUrl(t.id);
  const fallbackUrl = thumbUrl(t.id);
  
  if (targetUrl.endsWith('.mp4')) {
    $vid.src = targetUrl;
    $vid.onloadeddata = () => { $vid.style.opacity = "1"; };
    $vid.onerror = () => {
      $bg.style.backgroundImage = `url(${fallbackUrl})`;
      $bg.style.opacity = "1";
    };
  } else {
    const img = new Image();
    img.onload = () => {
      $bg.style.backgroundImage = `url(${targetUrl})`;
      $bg.style.opacity = "1";
    };
    img.onerror = () => {
      $bg.style.backgroundImage = `url(${fallbackUrl})`;
      $bg.style.opacity = "1";
    };
    img.src = targetUrl;
  }

  $name.textContent = t.name;
"""

content = re.sub(
    r'function goTo\(idx\) \{.*?\$name\.textContent = t\.name;',
    new_goto.strip(),
    content,
    flags=re.DOTALL
)

with open("script.js", "w") as f:
    f.write(content)
