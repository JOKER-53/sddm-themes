const themes = [
  { id: "marvel",      name: "MARVEL",        wp: "./marvel/assets/wallpaper.jpg",      tag: "cinematic title card",       accent: "#ed1d24" },
  { id: "classic-jdm", name: "CLASSIC JDM",   wp: "./classic-jdm/assets/wallpaper.jpg", tag: "instrument cluster HUD",     accent: "#ffb020" },
  { id: "alienx",      name: "ALIEN X",       wp: "./alienx/assets/wallpaper.png",      tag: "omnitrix command console",   accent: "#39ff14" },
  { id: "drag-racer",  name: "DRAG RACER",    wp: "./drag-racer/assets/wallpaper.jpg",  tag: "racing telemetry overlay",   accent: "#ff3b30" },
  { id: "gojo",        name: "GOJO",          wp: "./gojo/assets/wallpaper.png",        tag: "manga monochrome split",     accent: "#cfcfcf" },
  { id: "kawaii",      name: "KAWAII",        wp: "./kawaii/assets/wallpaper.png",      tag: "pastel rounded card",        accent: "#ff9ec7" },
  { id: "joker",       name: "JOKER",         wp: "./joker/assets/wallpaper.jpg",       tag: "off-center theatrical strip",accent: "#8bc34a" },
  { id: "rdr2",        name: "RDR2",          wp: "./rdr2/assets/wallpaper.jpg",        tag: "wanted-poster western",      accent: "#c79a4a" },
  { id: "deadpool",    name: "DEADPOOL",      wp: "./deadpool/assets/wallpaper.jpg",    tag: "snarky chat-bubble panel",   accent: "#d4202c" },
  { id: "bmw",         name: "BMW MUSEUM",    wp: "./bmw/assets/wallpaper.jpg",         tag: "M-stripe ignition HUD",      accent: "#1c69d4" },
  { id: "neon-gif",    name: "NEON (GIF)",    wp: "./neon-gif/assets/wallpaper.gif",    tag: "animated cyberpunk loop",    accent: "#00ffcc" },
  { id: "zoro-dragon", name: "ZORO DRAGON", wp: "./zoro-dragon/assets/wallpaper.gif", tag: "anime swordsman aura", accent: "#00ff44" },
  { id: "bmw-m3", name: "BMW M3", wp: "./bmw-m3/assets/wallpaper.gif", tag: "euro racing dash", accent: "#1c69d4" },
  { id: "nissan", name: "NISSAN DRIFT", wp: "./nissan/assets/wallpaper.gif", tag: "JDM street vibes", accent: "#ffb020" },
  { id: "oni-anime-girl", name: "ONI GIRL", wp: "./oni-anime-girl/assets/wallpaper.gif", tag: "neon demon aesthetics", accent: "#ff00ff" },
  { id: "mazda-mx5", name: "MAZDA MX5", wp: "./mazda-mx5/assets/wallpaper.gif", tag: "synthwave night drive", accent: "#ff2a6d" },
  { id: "oni-robot", name: "MECHA ONI", wp: "./oni-robot/assets/wallpaper.gif", tag: "glitchy mecha HUD", accent: "#ff5500" },
  { id: "dodge", name: "DODGE HELLCAT", wp: "./dodge/assets/wallpaper.gif", tag: "american muscle red", accent: "#d4202c" },
];

const $ = (s) => document.querySelector(s);
const preview = $("#preview");
const picker = $("#picker");
const grid = $("#grid");
const activeId = $("#activeId");
const cmd = $("#installCmd");

const USER = "Kadhir";
let current = themes[0];

const pad = (n) => String(n).padStart(2, "0");
const fmtHM = (d) => `${pad(d.getHours())}:${pad(d.getMinutes())}`;
const fmtHMS = (d) => `${fmtHM(d)}:${pad(d.getSeconds())}`;
const fmtDate = (d) => d.toLocaleDateString(undefined, { weekday: "long", month: "long", day: "numeric" });

/* ── per-theme greeter chrome (mirrors React GreeterMock) ───── */
const layouts = {
  marvel: (n) => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,rgba(0,0,0,.85),rgba(0,0,0,.2) 50%,rgba(0,0,0,.4))"></div>
    <div class="gm-tag" style="left:5%;top:6%">★ MARVEL STUDIOS ★</div>
    <div class="gm-marvel-col">
      <div class="gm-marvel-enter">ENTER</div>
      <div class="gm-tag" style="margin-top:6px">${fmtHM(n)} · ${USER.toUpperCase()}</div>
      <div class="gm-dots-line">• • • • • • • • •</div>
      <div class="gm-small">PASSWORD</div>
    </div>
    <div class="gm-power" style="left:5%;bottom:4%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  "classic-jdm": (n) => `
    <div class="gm-overlay" style="background:linear-gradient(to top,rgba(0,0,0,.9),transparent 33%)"></div>
    <div class="gm-jdm">
      <div class="gm-jdm-row">
        <div>
          <div class="gm-mini">SYS TIME</div>
          <div class="gm-jdm-clock">${fmtHMS(n)}</div>
          <div class="gm-mini">${fmtDate(n).toUpperCase()}</div>
        </div>
        <div class="gm-jdm-mid">
          <div class="gm-mini">USER · ${USER.toUpperCase()}</div>
          <div class="gm-jdm-input">▸ • • • • • • • _</div>
          <div class="gm-mini">[ENTER] TO IGNITE</div>
        </div>
        <div class="gm-jdm-right">
          <div class="gm-mini">SESSION</div><div>◂ PLASMA ▸</div>
          <div class="gm-mini" style="margin-top:8px">PWR</div><div>⏻ ↻ ☾</div>
        </div>
      </div>
    </div>`,

  alienx: (n) => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,rgba(0,0,0,.85),rgba(0,0,0,.4) 50%,transparent)"></div>
    <div class="gm-scanlines"></div>
    <div class="gm-alien">
      <div class="gm-alien-top">
        <span>▣ OMNITRIX · v10.0</span><span>SYS://${fmtHMS(n)}</span>
      </div>
      <div class="gm-alien-body">
        <div>&gt; init bio_signature.dat</div>
        <div>&gt; scanning DNA pattern...</div>
        <div>&gt; user::<span style="color:#fff">${USER}</span></div>
        <div>&gt; awaiting passphrase_</div>
        <div class="gm-alien-input">[ █████████ ]</div>
        <div class="gm-alien-keys">[F1] SESSION &nbsp; [F2] SHUTDOWN &nbsp; [F3] REBOOT</div>
      </div>
      <div class="gm-alien-top" style="opacity:.7">
        <span>CONN: SECURE</span><span>NODE 10/10</span><span>${fmtDate(n)}</span>
      </div>
    </div>`,

  "drag-racer": (n) => `
    <div class="gm-overlay" style="background:linear-gradient(135deg,rgba(0,0,0,.5),transparent,rgba(0,0,0,.7))"></div>
    <div class="gm-drag-clock">
      <div class="gm-drag-lap">LAP 01 · ${USER.toUpperCase()}</div>
      <div class="gm-drag-time">${fmtHM(n)}</div>
      <div class="gm-drag-sec">:${pad(n.getSeconds())}</div>
    </div>
    <div class="gm-drag-login">
      <div class="gm-drag-pill">
        <div class="gm-mini">PASSWORD</div>
        <div class="gm-drag-dots">• • • • • • • •</div>
      </div>
      <button class="gm-drag-go">GO →</button>
    </div>
    <div class="gm-power" style="left:4%;bottom:4%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  gojo: (n) => `
    <div class="gm-gojo-divider"></div>
    <div class="gm-gojo">
      <div class="gm-mini">INFINITY</div>
      <div class="gm-gojo-clock">${fmtHM(n)}</div>
      <div class="gm-mini">${fmtDate(n).toUpperCase()}</div>
      <div style="margin-top:32px"><div class="gm-mini">USER</div>
        <div class="gm-gojo-user">${USER}</div></div>
      <div class="gm-gojo-input">• • • • • • • •</div>
      <div class="gm-small">PASSPHRASE ↵</div>
      <div class="gm-gojo-foot">⏻ &nbsp; ↻ &nbsp; ☾ &nbsp; — &nbsp; PLASMA</div>
    </div>`,

  kawaii: (n) => `
    ${[0,1,2,3].map(i=>`<div class="gm-heart" style="left:${[6,14,88,92][i]}%;top:${8+i*12}%;font-size:${16+i*5}px">♡</div>`).join("")}
    <div class="gm-kawaii">
      <div class="gm-kawaii-head">
        <div class="gm-kawaii-avatar">🎀</div>
        <div>
          <div style="color:#ec4899;font-size:11px">welcome back ♡</div>
          <div style="color:#831843;font-weight:700">${USER}-chan</div>
        </div>
        <div class="gm-kawaii-clock">${fmtHM(n)}</div>
      </div>
      <div class="gm-kawaii-input">• • • • • • • • <span style="float:right">♡</span></div>
      <div class="gm-kawaii-row">
        <button class="gm-kawaii-btn">log in (◕‿◕✿)</button>
        <span style="color:#f472b6;font-size:9px">⏻ ↻ ☾</span>
      </div>
    </div>`,

  joker: (n) => `
    <div class="gm-overlay" style="background:radial-gradient(ellipse at 30% 50%,transparent,rgba(0,0,0,.85) 80%)"></div>
    <div class="gm-joker">
      <div>
        <div class="gm-joker-ha">HA · HA · HA</div>
        <div class="gm-joker-q">why so serious?</div>
      </div>
      <div>
        <div class="gm-joker-clock">${fmtHM(n)}</div>
        <div class="gm-mini">${fmtDate(n)}</div>
        <div class="gm-mini" style="margin-top:24px">USER</div>
        <div class="gm-joker-user">${USER}</div>
        <div class="gm-joker-input">• • • • • • •</div>
        <div class="gm-small">▸ enter the joke</div>
      </div>
      <div class="gm-joker-foot">⏻ &nbsp; ↻ &nbsp; ☾ &nbsp;&nbsp; <span style="color:#7cff5f">PLASMA ▾</span></div>
    </div>`,

  rdr2: (n) => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,rgba(0,0,0,.7),transparent,rgba(68,40,10,.4))"></div>
    <div class="gm-rdr2-clock">
      <div class="gm-mini">— TIME —</div>
      <div style="font-family:Georgia,serif;font-size:22px">${fmtHM(n)}</div>
    </div>
    <div class="gm-rdr2-card">
      <div style="text-align:center;letter-spacing:.6em;font-size:10px">— REWARD —</div>
      <div class="gm-rdr2-title">WANTED</div>
      <div style="text-align:center;letter-spacing:.4em;font-size:10px;opacity:.7">DEAD OR ALIVE</div>
      <div style="text-align:center;font-style:italic;margin-top:8px">${USER}</div>
      <div class="gm-rdr2-input">▸ &nbsp; • • • • • • •</div>
      <div class="gm-rdr2-foot">⏻ HANG UP &nbsp; ↻ RIDE &nbsp; ☾ CAMP</div>
    </div>`,

  deadpool: () => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,#000,rgba(0,0,0,.7) 50%,transparent)"></div>
    <div class="gm-dp">
      <div style="color:#e22718;letter-spacing:.4em;font-size:10px">★ DEADPOOL OS</div>
      <div class="gm-dp-title">Oh hey, you're back.</div>
      <div class="gm-dp-sub">I was just monologuing to a coat rack.<br/>Password. You know the drill, chimichanga.</div>
      <div class="gm-dp-user">● ${USER}</div>
      <div class="gm-dp-input"><span style="letter-spacing:.4em">• • • • • • • •</span><span>↵</span></div>
      <div style="margin-top:8px;font-size:16px">🌮 ⚔️ 🔫 ❤️‍🩹</div>
    </div>
    <div class="gm-power" style="left:4%;bottom:4%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  bmw: (n) => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,#000,rgba(0,0,0,.8) 30%,transparent 60%)"></div>
    <div class="gm-bmw-stripes"><i style="background:#1c69d4"></i><i style="background:#1f2e6e"></i><i style="background:#e22718"></i></div>
    <div class="gm-bmw-tag">● &nbsp; BMW · M-MOTORSPORT &nbsp; <span style="color:rgba(255,255,255,.5)">— 1986 — E28 M535i</span></div>
    <div class="gm-bmw">
      <div class="gm-mini" style="color:#1c69d4">IGNITION</div>
      <div class="gm-bmw-user">${USER}</div>
      <div class="gm-mini">Authorized operator</div>
      <div class="gm-bmw-line"></div>
      <div class="gm-bmw-input">
        <span class="gm-mini">ENTER KEY CODE</span>
        <span style="font-family:monospace;letter-spacing:.5em;font-size:18px">• • • • • •</span>
      </div>
      <div class="gm-bmw-row">
        <button class="gm-bmw-start">▸ START</button>
        <button class="gm-bmw-session">PLASMA ▾</button>
        <div class="gm-bmw-clock">${fmtHM(n)}</div>
      </div>
    </div>
    <div class="gm-power" style="left:5%;bottom:5%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  "neon-gif": (n) => `
    <div class="gm-overlay" style="background:linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, transparent 50%, rgba(0,0,0,0.8) 100%)"></div>
    <div style="position:absolute; bottom:80px; left:50%; transform:translateX(-50%); width:700px; height:280px; background:rgba(0,0,0,0.5); border:2px solid #ff2a6d; border-radius:8px; display:flex; align-items:center; padding:30px; box-sizing:border-box; z-index:3;">
      <div style="width:250px; display:flex; flex-direction:column; gap:10px;">
        <div style="color:#05d9e8; font-family:monospace; font-size:14px; letter-spacing:4px;">SYSTEM LOGIN</div>
        <div style="color:#fff; font-family:Impact; font-size:80px; letter-spacing:4px; -webkit-text-stroke:2px #ff2a6d; line-height:1;">${fmtHM(n)}</div>
        <div style="color:#05d9e8; font-family:monospace; font-size:16px; letter-spacing:2px;">${fmtDate(n)}</div>
      </div>
      <div style="width:2px; height:100%; background:#ff2a6d; opacity:0.5; margin:0 40px;"></div>
      <div style="width:300px; display:flex; flex-direction:column; gap:20px;">
        <div style="width:100%; height:44px; border:1px solid #05d9e8; background:rgba(0,0,0,0.2); color:#05d9e8; font-family:monospace; font-size:16px; font-weight:bold; line-height:44px; padding-left:12px; box-sizing:border-box;">${USER} ▾</div>
        <div style="width:100%; height:44px; border:1px solid #ff2a6d; background:rgba(0,0,0,0.2); color:#fff; font-family:monospace; font-size:16px; letter-spacing:4px; line-height:44px; padding-left:12px; box-sizing:border-box;">••••••••</div>
        <div style="width:100%; height:44px; background:#ff2a6d; color:#000; font-family:Impact; font-size:20px; letter-spacing:2px; text-align:center; line-height:44px; font-weight:bold;">INITIALIZE //</div>
      </div>
    </div>
    <div style="position:absolute; top:30px; right:30px; color:#05d9e8; font-family:monospace; font-size:12px; letter-spacing:2px; z-index:3;">SYS.SHUTDOWN &nbsp;&nbsp; SYS.REBOOT</div>`,

  "zoro-dragon": (n) => `
    <div style="position:absolute; left:0; width:500px; height:100%; background:rgba(0,0,0,0.8); border-right:2px solid #00ff44; display:flex; flex-direction:column; justify-content:center; padding-left:50px; z-index:3;">
      <div style="color:#00ff44; font-family:'Shojumaru', cursive; font-size:42px; font-weight:bold; margin-bottom:30px;">ZORO // DRAGON</div>
      <div style="width:350px; height:50px; background:rgba(0,255,68,0.1); border:1px solid #00ff44; color:#00ff44; line-height:50px; padding-left:15px; font-size:18px; margin-bottom:30px;">${USER} ▾</div>
      <div style="width:350px; height:50px; background:rgba(255,255,255,0.05); border:1px solid #00ff44; color:#fff; line-height:50px; padding-left:15px; font-size:18px; margin-bottom:30px;">••••••••</div>
      <div style="width:350px; height:50px; background:#00ff44; color:#000; text-align:center; line-height:50px; font-weight:bold; font-size:18px;">UNLEASH</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
  "bmw-m3": (n) => `
    <div style="font-family:'Audiowide', sans-serif; position:absolute; bottom:0; width:100%; height:150px; background:rgba(10,10,10,0.9); border-top:1px solid #1c69d4; display:flex; justify-content:center; align-items:center; gap:40px; z-index:3;">
      <div style="width:250px; height:50px; border:2px solid #1c69d4; border-radius:25px; color:#fff; text-align:center; line-height:50px; font-size:18px;">${USER} ▾</div>
      <div style="width:300px; height:50px; border:2px solid #1c69d4; border-radius:25px; color:#fff; text-align:center; line-height:50px; font-size:18px; letter-spacing:4px;">••••</div>
      <div style="width:150px; height:50px; background:#1c69d4; border-radius:25px; color:#fff; text-align:center; line-height:50px; font-weight:bold;">START ENGINE</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
  "nissan": (n) => `
    <div style="font-family:'Russo One', sans-serif; position:absolute; top:50%; left:50%; transform:translate(-50%, -50%) rotate(-3deg); width:600px; height:100px; background:rgba(0,0,0,0.8); display:flex; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="width:200px; height:40px; background:#ffb020; color:#000; text-align:center; line-height:40px; font-weight:bold; font-size:18px;">${USER} ▾</div>
      <div style="width:250px; height:40px; background:#000; border:2px solid #ffb020; color:#fff; text-align:center; line-height:40px; font-size:18px; letter-spacing:4px;">••••••••</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
  "oni-anime-girl": (n) => `
    <div style="font-family:'Rajdhani', sans-serif; position:absolute; right:100px; top:50%; transform:translateY(-50%); width:350px; height:450px; background:rgba(0,0,0,0.6); border:1px solid #ff00ff; border-radius:15px; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:25px; z-index:3;">
      <div style="color:#ff00ff; font-size:24px; font-weight:bold; letter-spacing:4px;">ONI // SYSTEM</div>
      <div style="width:280px; height:45px; border:1px solid #ff00ff; color:#ff00ff; line-height:45px; padding-left:10px; font-size:16px;">${USER} ▾</div>
      <div style="width:280px; height:45px; border:1px solid #ff00ff; color:#fff; line-height:45px; padding-left:10px; font-size:16px; letter-spacing:4px;">••••••••</div>
      <div style="width:280px; height:45px; background:#ff00ff; color:#000; text-align:center; line-height:45px; font-weight:bold;">CONNECT</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
  "mazda-mx5": (n) => `
    <div style="font-family:'Righteous', cursive; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.2); display:flex; flex-direction:column; justify-content:center; align-items:center; gap:15px; z-index:3;">
      <div style="color:#05d9e8; font-size:50px; font-weight:bold; font-style:italic;">NIGHT DRIVE</div>
      <div style="width:300px; height:40px; background:rgba(0,0,0,0.6); border:2px solid #ff2a6d; color:#fff; font-style:italic; text-align:center; line-height:40px; font-size:18px;">${USER} ▾</div>
      <div style="width:300px; height:40px; background:rgba(0,0,0,0.6); border:2px solid #05d9e8; color:#fff; font-style:italic; text-align:center; line-height:40px; font-size:18px; letter-spacing:4px;">••••••••</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
  "oni-robot": (n) => `
    <div style="position:absolute; top:0; left:0; width:100%; height:100%; border:10px solid rgba(255,85,0,0.8); box-sizing:border-box; pointer-events:none; z-index:2;"></div>
    <div style="position:absolute; top:80px; left:80px; width:400px; height:300px; background:rgba(0,0,0,0.8); border:2px solid #ff5500; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="color:#ff5500; font-family:'VT323', monospace; font-size:22px;">[ PILOT LOGIN ]</div>
      <div style="width:300px; height:40px; background:#000; border:1px solid #ff5500; color:#ff5500; font-family:'VT323', monospace; font-size:18px; line-height:40px; padding-left:10px;">> ${USER} ▾</div>
      <div style="width:300px; height:40px; background:#000; border:1px solid #ff5500; color:#ff5500; font-family:'VT323', monospace; font-size:18px; line-height:40px; padding-left:10px; letter-spacing:4px;">••••••••</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
  "dodge": (n) => `
    <div style="font-family:'Bebas Neue', sans-serif; position:absolute; bottom:0; left:0; width:100%; height:300px; background:linear-gradient(to top, rgba(0,0,0,1), transparent); z-index:2;"></div>
    <div style="position:absolute; bottom:60px; right:80px; display:flex; gap:10px; z-index:3;">
      <div style="width:220px; height:60px; background:#d4202c; color:#fff; font-size:24px; font-weight:bold; text-align:center; line-height:60px;">${USER} ▾</div>
      <div style="width:280px; height:60px; background:#000; border:3px solid #d4202c; color:#fff; font-size:24px; text-align:center; line-height:54px; letter-spacing:4px; box-sizing:border-box;">••••••</div>
    </div>\n    <div class="gm-power" style="top:20px; left:20px; font-family:sans-serif; text-transform:none; font-size:11px; font-weight:bold; color:#fff; display:flex; gap:15px; z-index:100;"><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">PLASMA ▾</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.3); border-radius:4px;">REBOOT</div><div style="padding:6px 12px; background:rgba(0,0,0,0.6); border:1px solid #ff2e63; border-radius:4px; color:#ff2e63;">SHUTDOWN</div></div>`,
};

function render() {
  const now = new Date();
  preview.style.backgroundImage = `url("${current.wp}")`;
  preview.innerHTML = `
    ${layouts[current.id](now)}
    <div class="chrome">
      <div class="meta">
        <strong>${current.name}</strong>
        ${current.tag} · accent <span style="color:${current.accent}">${current.accent}</span>
      </div>
    </div>`;
  activeId.textContent = current.id;
  document.documentElement.style.setProperty("--accent", current.accent);
  [...picker.children].forEach((b) =>
    b.classList.toggle("active", b.dataset.id === current.id)
  );
}

themes.forEach((t) => {
  const b = document.createElement("button");
  b.dataset.id = t.id;
  b.innerHTML = `${t.name} <span class="pid">${t.id}</span>`;
    b.onclick = () => { 
    currentIndex = themes.findIndex(th => th.id === t.id);
    current = t; 
    render(); 
    pauseAutoplay();
  };
  picker.appendChild(b);

  const c = document.createElement("div");
  c.className = "card";
  c.dataset.name = t.name;
  c.style.backgroundImage = `url("${t.wp}")`;
    c.onclick = () => { 
    currentIndex = themes.findIndex(th => th.id === t.id);
    current = t; 
    render(); 
    window.scrollTo({ top: 0, behavior: "smooth" }); 
    pauseAutoplay();
  };
  grid.appendChild(c);
});

cmd.onclick = async () => {
  try {
    await navigator.clipboard.writeText(`sudo ./install.sh ${current.id}`);
    const c = cmd.querySelector(".copy");
    const old = c.textContent; c.textContent = "copied!";
    setTimeout(() => (c.textContent = old), 1200);
  } catch {}
};

render();
setInterval(render, 1000);

let currentIndex = 0;
let autoplayInterval = null;
let autoplayTimeout = null;

function startAutoplay() {
  if (autoplayInterval) clearInterval(autoplayInterval);
  autoplayInterval = setInterval(() => {
    currentIndex = (currentIndex + 1) % themes.length;
    current = themes[currentIndex];
    render();
  }, 4000); // Change theme every 4 seconds
}

function pauseAutoplay() {
  if (autoplayInterval) clearInterval(autoplayInterval);
  if (autoplayTimeout) clearTimeout(autoplayTimeout);
  
  autoplayTimeout = setTimeout(() => {
    startAutoplay();
  }, 60000); // Pause for 1 minute
}

// Start autoplay initially
startAutoplay();
