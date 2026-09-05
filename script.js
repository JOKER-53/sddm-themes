/* ─────────────────────────────────────────────────────
   JOKER53 · SDDM Themes  —  Site Script
   Stack: Vanilla JS, no deps
───────────────────────────────────────────────────── */

const themes = [
  { id: "marvel",                  name: "MARVEL",              tag: "cinematic title card",       accent: "#ed1d24", cats: ["marvel","dark"] },
  { id: "classic-jdm",             name: "CLASSIC JDM",         tag: "instrument cluster HUD",     accent: "#ffb020", cats: ["cars"] },
  { id: "alienx",                  name: "ALIEN X",             tag: "omnitrix command console",   accent: "#39ff14", cats: ["cyber","dark"] },
  { id: "drag-racer",              name: "DRAG RACER",          tag: "racing telemetry overlay",   accent: "#ff3b30", cats: ["cars"] },
  { id: "gojo",                    name: "GOJO",                tag: "manga monochrome split",     accent: "#cfcfcf", cats: ["anime"] },
  { id: "kawaii",                  name: "KAWAII",              tag: "pastel rounded card",        accent: "#ff9ec7", cats: ["anime"] },
  { id: "joker",                   name: "JOKER",               tag: "off-center theatrical strip",accent: "#8bc34a", cats: ["dark","marvel"] },
  { id: "rdr2",                    name: "RDR2",                tag: "wanted-poster western",      accent: "#c79a4a", cats: ["dark"] },
  { id: "deadpool",                name: "DEADPOOL",            tag: "snarky chat-bubble panel",   accent: "#d4202c", cats: ["marvel"] },
  { id: "bmw",                     name: "BMW MUSEUM",          tag: "M-stripe ignition HUD",      accent: "#1c69d4", cats: ["cars"] },
  { id: "neon-gif",                name: "NEON",                tag: "animated cyberpunk loop",    accent: "#00ffcc", cats: ["cyber"] },
  { id: "zoro-dragon",             name: "ZORO DRAGON",         tag: "anime swordsman aura",       accent: "#00ff44", cats: ["anime","dark"] },
  { id: "bmw-m3",                  name: "BMW M3",              tag: "euro racing dash",           accent: "#1c69d4", cats: ["cars"] },
  { id: "nissan",                  name: "NISSAN DRIFT",        tag: "JDM street vibes",           accent: "#ffb020", cats: ["cars"] },
  { id: "oni-anime-girl",          name: "ONI GIRL",            tag: "neon demon aesthetics",      accent: "#ff00ff", cats: ["anime","cyber"] },
  { id: "mazda-mx5",               name: "MAZDA MX5",           tag: "synthwave night drive",      accent: "#ff2a6d", cats: ["cars","cyber"] },
  { id: "oni-robot",               name: "MECHA ONI",           tag: "glitchy mecha HUD",          accent: "#ff5500", cats: ["cyber","dark"] },
  { id: "dodge",                   name: "DODGE HELLCAT",       tag: "american muscle red",        accent: "#d4202c", cats: ["cars"] },
  { id: "spiderverse",             name: "SPIDER-VERSE",        tag: "comic book halftone",        accent: "#00ffff", cats: ["marvel"] },
  { id: "spiderman",               name: "SPIDERMAN",           tag: "classic red blue hero",      accent: "#e23636", cats: ["marvel"] },
  { id: "sakura-lake",             name: "SAKURA LAKE",         tag: "calm pink petals",           accent: "#ffb7c5", cats: ["nature","anime"] },
  { id: "mountain-sunset",         name: "MOUNTAIN SUNSET",     tag: "retro 80s outrun",           accent: "#ff007f", cats: ["nature","cyber"] },
  { id: "mount-fuji",              name: "MOUNT FUJI",          tag: "minimal zen white",          accent: "#d4f1f9", cats: ["nature"] },
  { id: "the-dark-river",          name: "THE DARK RIVER",      tag: "moody gold gothic",          accent: "#c5a059", cats: ["dark","nature"] },
  { id: "purrple-cat",             name: "PURRPLE CAT",         tag: "lo-fi hip hop chill",        accent: "#a854f7", cats: ["anime","nature"] },
  { id: "hitagi-senjougahara",     name: "SENJOUGAHARA",        tag: "monogatari geometric red",   accent: "#ff0000", cats: ["anime"] },
  { id: "hilda-and-tepig",         name: "HILDA & TEPIG",       tag: "playful rounded orange",     accent: "#ff8c00", cats: ["anime"] },
  { id: "hoodie",                  name: "HOODIE HACKER",       tag: "urban glitch green",         accent: "#39ff14", cats: ["cyber","dark"] },
  { id: "neko-anime",              name: "NEKO KAWAII",         tag: "pastel pink cyan box",       accent: "#00ffff", cats: ["anime"] },
  { id: "zoro-blue",               name: "ZORO BLUE",           tag: "intense sword aura",         accent: "#00aaff", cats: ["anime"] },
  { id: "cat-pond",                name: "CAT POND",            tag: "tranquil nature vibe",       accent: "#4caf50", cats: ["nature"] },
  { id: "cosmic-gateway",          name: "COSMIC GATEWAY",      tag: "deep space portal",          accent: "#9c27b0", cats: ["dark","cyber"] },
  { id: "everest",                 name: "MT. EVEREST",         tag: "snowy peak minimal",         accent: "#00bcd4", cats: ["nature"] },
  { id: "fish-in-rock-pond",       name: "KOI POND",            tag: "zen rock pool",              accent: "#ff9800", cats: ["nature"] },
  { id: "moonlit-rooftop-cat",     name: "MOONLIT ROOFTOP",     tag: "lo-fi starry night",         accent: "#673ab7", cats: ["anime","nature"] },
  { id: "neverness-to-everness",   name: "NTE ANIME",           tag: "action character frame",     accent: "#e91e63", cats: ["anime"] },
  { id: "nissan-skyline",          name: "NISSAN SKYLINE",      tag: "r34 pure JDM",               accent: "#f44336", cats: ["cars"] },
  { id: "ocean-in-jar",            name: "OCEAN JAR",           tag: "surreal desktop pet",        accent: "#03a9f4", cats: ["nature"] },
  { id: "pink-bloom",              name: "PINK BLOOM",          tag: "soft floral pastel",         accent: "#e91e63", cats: ["nature"] },
  { id: "pirates-of-the-caribbean",name: "BLACK PEARL",         tag: "cinematic stormy sea",       accent: "#795548", cats: ["dark"] },
  { id: "pixel-gaming-room",       name: "PIXEL GAMING",        tag: "retro 8-bit den",            accent: "#8bc34a", cats: ["pixel"] },
  { id: "pixel-sakura-city",       name: "PIXEL SAKURA",        tag: "retro tokyo dusk",           accent: "#f06292", cats: ["pixel","anime"] },
  { id: "pokeball",                name: "POKEBALL",            tag: "clean catch layout",         accent: "#f44336", cats: ["anime","pixel"] },
  { id: "super-mario-pixel",       name: "SUPER MARIO",         tag: "nostalgic 8-bit",            accent: "#e52521", cats: ["pixel"] },
];

/* Wallpaper helper — try gif first, fall back to jpg/png */
function wpUrl(id) {
  // themes with known GIF wallpapers
  const gifs = new Set([
    "neon-gif","zoro-dragon","bmw-m3","nissan","oni-anime-girl","mazda-mx5",
    "oni-robot","dodge","spiderverse","spiderman","sakura-lake","mountain-sunset",
    "mount-fuji","the-dark-river","purrple-cat","hitagi-senjougahara",
    "hilda-and-tepig","hoodie","neko-anime","zoro-blue","cat-pond",
    "cosmic-gateway","everest","fish-in-rock-pond","moonlit-rooftop-cat",
    "neverness-to-everness","nissan-skyline","ocean-in-jar","pink-bloom",
    "pirates-of-the-caribbean","pixel-gaming-room","pixel-sakura-city",
    "pokeball","super-mario-pixel",
  ]);
  if (gifs.has(id)) return `./${id}/assets/wallpaper.gif`;
  const pngs = new Set(["alienx","gojo","kawaii"]);
  if (pngs.has(id)) return `./${id}/assets/wallpaper.png`;
  return `./${id}/assets/wallpaper.jpg`;
}

/* ── State ──────────────────────────────────────────── */
let activeTheme = themes[0];
let activeFilter = "all";
let searchQ = "";

/* ── DOM refs ───────────────────────────────────────── */
const $wp   = document.getElementById("spotlightWp");
const $name = document.getElementById("spotlightName");
const $desc = document.getElementById("spotlightDesc");
const $line = document.getElementById("spotlightLine");
const $cmd  = document.getElementById("spotlightCmd");
const $grid = document.getElementById("grid");
const $noResults = document.getElementById("noResults");
const $toast = document.getElementById("toast");

/* ── Spotlight ──────────────────────────────────────── */
function setSpotlight(t) {
  activeTheme = t;

  $wp.style.opacity = "0";
  setTimeout(() => {
    $wp.src = wpUrl(t.id);
    $wp.onload = () => { $wp.style.opacity = "1"; };
    $name.textContent = t.name;
    $desc.textContent = t.tag;
    $line.style.background = t.accent;
    $cmd.textContent  = `sudo ./install.sh ${t.id}`;
    // update active card
    document.querySelectorAll(".card").forEach(c =>
      c.classList.toggle("active-card", c.dataset.id === t.id)
    );
  }, 150);
}

/* ── Copy helper ────────────────────────────────────── */
function showToast(msg = "Copied!") {
  $toast.textContent = msg;
  $toast.classList.add("show");
  setTimeout(() => $toast.classList.remove("show"), 2200);
}

document.getElementById("spotlightCopy").onclick = () => {
  navigator.clipboard.writeText(`sudo ./install.sh ${activeTheme.id}`);
  showToast("Command copied!");
};

document.getElementById("copyBtn").onclick = () => {
  navigator.clipboard.writeText("sudo ./install.sh");
  showToast("Copied!");
};

/* ── Grid ───────────────────────────────────────────── */
function buildGrid() {
  const q = searchQ.trim().toLowerCase();
  const filtered = themes.filter(t => {
    const matchCat = activeFilter === "all" || t.cats.includes(activeFilter);
    const matchQ   = !q || t.name.toLowerCase().includes(q) || t.id.includes(q) || t.tag.includes(q);
    return matchCat && matchQ;
  });

  $noResults.hidden = filtered.length > 0;
  $grid.innerHTML = "";

  filtered.forEach(t => {
    const card = document.createElement("div");
    card.className = "card" + (t.id === activeTheme.id ? " active-card" : "");
    card.dataset.id = t.id;
    card.style.backgroundImage = `url(${t.id}/assets/thumbnail.jpg)`;

    card.innerHTML = `
      <div class="card-overlay"></div>
      <div class="card-info">
        <div class="card-name">${t.name}</div>
        <div class="card-tag">${t.tag}</div>
      </div>
      <div class="card-accent-bar" style="background:${t.accent}"></div>
    `;

    card.addEventListener("click", () => {
      setSpotlight(t);
      document.querySelector(".spotlight").scrollIntoView({ behavior: "smooth", block: "start" });
    });

    $grid.appendChild(card);
  });
}

/* ── Filters ────────────────────────────────────────── */
document.getElementById("filters").addEventListener("click", e => {
  const btn = e.target.closest(".filter");
  if (!btn) return;
  document.querySelectorAll(".filter").forEach(b => b.classList.remove("active"));
  btn.classList.add("active");
  activeFilter = btn.dataset.tag;
  buildGrid();
});

/* ── Search ─────────────────────────────────────────── */
document.getElementById("search").addEventListener("input", e => {
  searchQ = e.target.value;
  buildGrid();
});

window.clearSearch = () => {
  document.getElementById("search").value = "";
  searchQ = "";
  buildGrid();
};

/* ── Init ───────────────────────────────────────────── */
setSpotlight(themes[0]);
buildGrid();
