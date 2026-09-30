/* ─────────────────────────────────────────────────────
   JOKER53 · SDDM Themes  —  Site Script
   Vanilla JS, no deps
───────────────────────────────────────────────────── */

const themes = window.THEME_CATALOG;
const assetUrl = (id, asset) => `../themes/${id}/${asset}`;
const wpUrl = id => assetUrl(id, themes.find(t => t.id === id).wallpaper);
const thumbUrl = id => assetUrl(id, themes.find(t => t.id === id).thumbnail);
document.querySelectorAll("[data-theme-count]").forEach(el => el.textContent = themes.length);

/* ── Clock helpers ──────────────────────────────────── */
const pad     = n => String(n).padStart(2,"0");
const fmtHM   = d => `${pad(d.getHours())}:${pad(d.getMinutes())}`;
const fmtHMS  = d => `${fmtHM(d)}:${pad(d.getSeconds())}`;
const fmtDate = d => d.toLocaleDateString(undefined,{weekday:"long",month:"long",day:"numeric"});
const USER = "Kadhir";

/* ── Per-theme greeter mock HTML ────────────────────── */
const layouts = {
  marvel: n => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,rgba(0,0,0,.85),rgba(0,0,0,.2) 50%,rgba(0,0,0,.4))"></div>
    <div class="gm-tag" style="left:5%;top:6%">★ MARVEL STUDIOS ★</div>
    <div class="gm-marvel-col">
      <div class="gm-marvel-enter">ENTER</div>
      <div class="gm-tag" style="margin-top:6px">${fmtHM(n)} · ${USER.toUpperCase()}</div>
      <div class="gm-dots-line">• • • • • • • • •</div>
      <div class="gm-small">PASSWORD</div>
    </div>
    <div class="gm-power" style="left:5%;bottom:4%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  "classic-jdm": n => `
    <div class="gm-overlay" style="background:linear-gradient(to top,rgba(0,0,0,.9),transparent 33%)"></div>
    <div class="gm-jdm">
      <div class="gm-jdm-row">
        <div><div class="gm-mini">SYS TIME</div><div class="gm-jdm-clock">${fmtHMS(n)}</div><div class="gm-mini">${fmtDate(n).toUpperCase()}</div></div>
        <div class="gm-jdm-mid"><div class="gm-mini">USER · ${USER.toUpperCase()}</div><div class="gm-jdm-input">▸ • • • • • • • _</div><div class="gm-mini">[ENTER] TO IGNITE</div></div>
        <div class="gm-jdm-right"><div class="gm-mini">SESSION</div><div>◂ PLASMA ▸</div><div class="gm-mini" style="margin-top:8px">PWR</div><div>⏻ ↻ ☾</div></div>
      </div>
    </div>`,

  alienx: n => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,rgba(0,0,0,.85),rgba(0,0,0,.4) 50%,transparent)"></div>
    <div class="gm-scanlines"></div>
    <div class="gm-alien">
      <div class="gm-alien-top"><span>▣ OMNITRIX · v10.0</span><span>SYS://${fmtHMS(n)}</span></div>
      <div class="gm-alien-body">
        <div>&gt; init bio_signature.dat</div><div>&gt; scanning DNA pattern...</div>
        <div>&gt; user::<span style="color:#fff">${USER}</span></div><div>&gt; awaiting passphrase_</div>
        <div class="gm-alien-input">[ █████████ ]</div>
        <div class="gm-alien-keys">[F1] SESSION &nbsp; [F2] SHUTDOWN &nbsp; [F3] REBOOT</div>
      </div>
      <div class="gm-alien-top" style="opacity:.7"><span>CONN: SECURE</span><span>NODE 10/10</span><span>${fmtDate(n)}</span></div>
    </div>`,

  "drag-racer": n => `
    <div class="gm-overlay" style="background:linear-gradient(135deg,rgba(0,0,0,.5),transparent,rgba(0,0,0,.7))"></div>
    <div class="gm-drag-clock">
      <div class="gm-drag-lap">LAP 01 · ${USER.toUpperCase()}</div>
      <div class="gm-drag-time">${fmtHM(n)}</div>
      <div class="gm-drag-sec">:${pad(n.getSeconds())}</div>
    </div>
    <div class="gm-drag-login">
      <div class="gm-drag-pill"><div class="gm-mini">PASSWORD</div><div class="gm-drag-dots">• • • • • • • •</div></div>
      <button class="gm-drag-go">GO →</button>
    </div>
    <div class="gm-power" style="left:4%;bottom:4%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  gojo: n => `
    <div class="gm-gojo-divider"></div>
    <div class="gm-gojo">
      <div class="gm-mini">INFINITY</div>
      <div class="gm-gojo-clock">${fmtHM(n)}</div>
      <div class="gm-mini">${fmtDate(n).toUpperCase()}</div>
      <div style="margin-top:32px"><div class="gm-mini">USER</div><div class="gm-gojo-user">${USER}</div></div>
      <div class="gm-gojo-input">• • • • • • • •</div>
      <div class="gm-small">PASSPHRASE ↵</div>
      <div class="gm-gojo-foot">⏻ &nbsp; ↻ &nbsp; ☾ &nbsp; — &nbsp; PLASMA</div>
    </div>`,

  kawaii: n => `
    ${[0,1,2,3].map(i=>`<div class="gm-heart" style="left:${[6,14,88,92][i]}%;top:${8+i*12}%;font-size:${16+i*5}px">♡</div>`).join("")}
    <div class="gm-kawaii">
      <div class="gm-kawaii-head">
        <div class="gm-kawaii-avatar">🎀</div>
        <div><div style="color:#ec4899;font-size:11px">welcome back ♡</div><div style="color:#831843;font-weight:700">${USER}-chan</div></div>
        <div class="gm-kawaii-clock">${fmtHM(n)}</div>
      </div>
      <div class="gm-kawaii-input">• • • • • • • • <span style="float:right">♡</span></div>
      <div class="gm-kawaii-row"><button class="gm-kawaii-btn">log in (◕‿◕✿)</button><span style="color:#f472b6;font-size:9px">⏻ ↻ ☾</span></div>
    </div>`,

  joker: n => `
    <div class="gm-overlay" style="background:radial-gradient(ellipse at 30% 50%,transparent,rgba(0,0,0,.85) 80%)"></div>
    <div class="gm-joker">
      <div><div class="gm-joker-ha">HA · HA · HA</div><div class="gm-joker-q">why so serious?</div></div>
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

  rdr2: n => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,rgba(0,0,0,.7),transparent,rgba(68,40,10,.4))"></div>
    <div class="gm-rdr2-clock"><div class="gm-mini">— TIME —</div><div style="font-family:Georgia,serif;font-size:22px">${fmtHM(n)}</div></div>
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

  bmw: n => `
    <div class="gm-overlay" style="background:linear-gradient(90deg,#000,rgba(0,0,0,.8) 30%,transparent 60%)"></div>
    <div class="gm-bmw-stripes"><i style="background:#1c69d4"></i><i style="background:#1f2e6e"></i><i style="background:#e22718"></i></div>
    <div class="gm-bmw-tag">● &nbsp; BMW · M-MOTORSPORT &nbsp; <span style="color:rgba(255,255,255,.5)">— 1986 — E28 M535i</span></div>
    <div class="gm-bmw">
      <div class="gm-mini" style="color:#1c69d4">IGNITION</div>
      <div class="gm-bmw-user">${USER}</div>
      <div class="gm-mini">Authorized operator</div>
      <div class="gm-bmw-line"></div>
      <div class="gm-bmw-input"><span class="gm-mini">ENTER KEY CODE</span><span style="font-family:monospace;letter-spacing:.5em;font-size:18px">• • • • • •</span></div>
      <div class="gm-bmw-row"><button class="gm-bmw-start">▸ START</button><button class="gm-bmw-session">PLASMA ▾</button><div class="gm-bmw-clock">${fmtHM(n)}</div></div>
    </div>
    <div class="gm-power" style="left:5%;bottom:5%">⏻ shutdown · ↻ restart · ☾ suspend</div>`,

  "neon-gif": n => `
    <div class="gm-overlay" style="background:linear-gradient(to bottom,rgba(0,0,0,.5) 0%,transparent 50%,rgba(0,0,0,.8) 100%)"></div>
    <div style="position:absolute;bottom:80px;left:50%;transform:translateX(-50%);width:700px;height:280px;background:rgba(0,0,0,.5);border:2px solid #ff2a6d;border-radius:8px;display:flex;align-items:center;padding:30px;box-sizing:border-box;z-index:3;">
      <div style="width:250px;display:flex;flex-direction:column;gap:10px;">
        <div style="color:#05d9e8;font-family:monospace;font-size:14px;letter-spacing:4px;">SYSTEM LOGIN</div>
        <div style="color:#fff;font-family:Impact;font-size:80px;letter-spacing:4px;-webkit-text-stroke:2px #ff2a6d;line-height:1;">${fmtHM(n)}</div>
        <div style="color:#05d9e8;font-family:monospace;font-size:16px;letter-spacing:2px;">${fmtDate(n)}</div>
      </div>
      <div style="width:2px;height:100%;background:#ff2a6d;opacity:.5;margin:0 40px;"></div>
      <div style="width:300px;display:flex;flex-direction:column;gap:20px;">
        <div style="width:100%;height:44px;border:1px solid #05d9e8;background:rgba(0,0,0,.2);color:#05d9e8;font-family:monospace;font-size:16px;font-weight:bold;line-height:44px;padding-left:12px;">${USER} ▾</div>
        <div style="width:100%;height:44px;border:1px solid #ff2a6d;background:rgba(0,0,0,.2);color:#fff;font-family:monospace;font-size:16px;letter-spacing:4px;line-height:44px;padding-left:12px;">••••••••</div>
        <div style="width:100%;height:44px;background:#ff2a6d;color:#000;font-family:Impact;font-size:20px;letter-spacing:2px;text-align:center;line-height:44px;font-weight:bold;">INITIALIZE //</div>
      </div>
    </div>`,

  "zoro-dragon": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#00ff44;font-family:sans-serif;font-size:84px;text-shadow:0 0 10px rgba(0,0,0,.5);z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;left:0;width:500px;height:100%;background:rgba(0,0,0,.8);border-right:2px solid #00ff44;display:flex;flex-direction:column;justify-content:center;padding-left:50px;z-index:3;">
      <div style="color:#00ff44;font-size:42px;font-weight:bold;margin-bottom:30px;">ZORO // DRAGON</div>
      <div style="width:350px;height:50px;background:rgba(0,255,68,.1);border:1px solid #00ff44;color:#00ff44;line-height:50px;padding-left:15px;font-size:18px;margin-bottom:30px;">${USER} ▾</div>
      <div style="width:350px;height:50px;background:rgba(255,255,255,.05);border:1px solid #00ff44;color:#fff;line-height:50px;padding-left:15px;font-size:18px;margin-bottom:30px;">••••••••</div>
      <div style="width:350px;height:50px;background:#00ff44;color:#000;text-align:center;line-height:50px;font-weight:bold;font-size:18px;">UNLEASH</div>
    </div>`,

  "bmw-m3": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#1c69d4;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:0;width:100%;height:150px;background:rgba(10,10,10,.9);border-top:1px solid #1c69d4;display:flex;justify-content:center;align-items:center;gap:40px;z-index:3;">
      <div style="width:250px;height:50px;border:2px solid #1c69d4;border-radius:25px;color:#fff;text-align:center;line-height:50px;font-size:18px;">${USER} ▾</div>
      <div style="width:300px;height:50px;border:2px solid #1c69d4;border-radius:25px;color:#fff;text-align:center;line-height:50px;font-size:18px;letter-spacing:4px;">••••</div>
      <div style="width:150px;height:50px;background:#1c69d4;border-radius:25px;color:#fff;text-align:center;line-height:50px;font-weight:bold;">START ENGINE</div>
    </div>`,

  nissan: n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff3b00;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:60px;right:60px;transform:rotate(-3deg);width:600px;height:100px;background:rgba(0,0,0,.8);display:flex;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="width:200px;height:40px;background:#ffb020;color:#000;text-align:center;line-height:40px;font-weight:bold;font-size:18px;">${USER} ▾</div>
      <div style="width:250px;height:40px;background:#000;border:2px solid #ffb020;color:#fff;text-align:center;line-height:40px;font-size:18px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "oni-anime-girl": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff00ff;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;right:100px;bottom:60px;width:350px;height:450px;background:rgba(0,0,0,.6);border:1px solid #ff00ff;border-radius:15px;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:25px;z-index:3;">
      <div style="color:#ff00ff;font-size:24px;font-weight:bold;letter-spacing:4px;">ONI // SYSTEM</div>
      <div style="width:280px;height:45px;border:1px solid #ff00ff;color:#ff00ff;line-height:45px;padding-left:10px;font-size:16px;">${USER} ▾</div>
      <div style="width:280px;height:45px;border:1px solid #ff00ff;color:#fff;line-height:45px;padding-left:10px;font-size:16px;letter-spacing:4px;">••••••••</div>
      <div style="width:280px;height:45px;background:#ff00ff;color:#000;text-align:center;line-height:45px;font-weight:bold;">CONNECT</div>
    </div>`,

  "mazda-mx5": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#05d9e8;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:60px;right:60px;width:350px;display:flex;flex-direction:column;align-items:flex-end;gap:15px;z-index:3;">
      <div style="color:#05d9e8;font-size:50px;font-weight:bold;font-style:italic;">NIGHT DRIVE</div>
      <div style="width:300px;height:40px;background:rgba(0,0,0,.6);border:2px solid #ff2a6d;color:#fff;font-style:italic;text-align:center;line-height:40px;font-size:18px;">${USER} ▾</div>
      <div style="width:300px;height:40px;background:rgba(0,0,0,.6);border:2px solid #05d9e8;color:#fff;text-align:center;line-height:40px;font-size:18px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "oni-robot": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff5500;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;top:0;left:0;width:100%;height:100%;border:10px solid rgba(255,85,0,.8);box-sizing:border-box;pointer-events:none;z-index:2;"></div>
    <div style="position:absolute;top:80px;left:80px;width:400px;height:300px;background:rgba(0,0,0,.8);border:2px solid #ff5500;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="color:#ff5500;font-family:'VT323',monospace;font-size:22px;">[ PILOT LOGIN ]</div>
      <div style="width:300px;height:40px;background:#000;border:1px solid #ff5500;color:#ff5500;font-size:18px;line-height:40px;padding-left:10px;">&gt; ${USER} ▾</div>
      <div style="width:300px;height:40px;background:#000;border:1px solid #ff5500;color:#ff5500;font-size:18px;line-height:40px;padding-left:10px;letter-spacing:4px;">••••••••</div>
    </div>`,

  dodge: n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#d4202c;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:0;left:0;width:100%;height:300px;background:linear-gradient(to top,rgba(0,0,0,1),transparent);z-index:2;"></div>
    <div style="position:absolute;bottom:60px;right:80px;display:flex;gap:10px;z-index:3;">
      <div style="width:220px;height:60px;background:#d4202c;color:#fff;font-size:24px;font-weight:bold;text-align:center;line-height:60px;">${USER} ▾</div>
      <div style="width:280px;height:60px;background:#000;border:3px solid #d4202c;color:#fff;font-size:24px;text-align:center;line-height:54px;letter-spacing:4px;box-sizing:border-box;">••••••</div>
    </div>`,

  spiderverse: n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff00ff;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;right:150px;top:50%;transform:translateY(-50%);width:380px;height:480px;background:#111;border:2px solid #222;border-radius:10px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:25px;z-index:3;box-shadow:-4px 2px 0 #00ffff,4px -2px 0 #ff00ff;">
      <div style="font-size:64px;color:#ff0044;line-height:1;">🕷</div>
      <div style="font-size:28px;color:#fff;letter-spacing:2px;">SYSTEM_ACCESS</div>
      <div style="width:300px;height:50px;background:#000;border:2px solid #333;color:#00ffff;font-size:20px;line-height:46px;padding-left:15px;">${USER} ▾</div>
      <div style="width:300px;height:50px;background:#000;border:2px solid #333;color:#ff00ff;font-size:20px;line-height:46px;padding-left:15px;letter-spacing:4px;">••••••••</div>
      <div style="width:300px;height:50px;background:#ff0044;color:#fff;font-size:20px;font-weight:bold;line-height:50px;text-align:center;letter-spacing:4px;">CONNECT</div>
    </div>`,

  spiderman: n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#e23636;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:60px;right:60px;width:350px;height:350px;background:rgba(0,0,0,.7);border:8px solid #e23636;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="font-size:36px;color:#e23636;">WEB SHOOTER</div>
      <div style="width:280px;height:50px;background:transparent;border:4px solid #0055ff;font-size:20px;color:#0055ff;text-align:center;line-height:42px;">${USER} ▾</div>
      <div style="width:280px;height:50px;background:#000;border:4px solid #e23636;font-size:20px;color:#fff;text-align:center;line-height:42px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "sakura-lake": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff2e63;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:60px;left:60px;width:500px;height:80px;background:rgba(255,255,255,.8);border-radius:40px;display:flex;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="width:200px;height:40px;font-size:24px;color:#ffb7c5;text-align:center;line-height:40px;">${USER} ▾</div>
      <div style="width:1px;height:30px;background:#ffb7c5;"></div>
      <div style="width:200px;height:40px;font-size:24px;color:#555;text-align:center;line-height:40px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "mountain-sunset": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff9d76;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:140px;width:100%;text-align:center;font-size:64px;color:#ff9d76;z-index:3;">SUNSET DRIVE</div>
    <div style="position:absolute;bottom:80px;left:50%;transform:translateX(-50%);width:820px;height:60px;background:rgba(10,8,17,.4);border:1px solid rgba(255,157,118,.27);border-radius:30px;display:flex;align-items:center;padding:0 10px 0 20px;gap:15px;z-index:3;">
      <div style="width:140px;color:#ff9d76;font-weight:bold;font-size:16px;text-align:center;">${USER} ▾</div>
      <div style="width:1px;height:30px;background:rgba(255,157,118,.27);"></div>
      <div style="width:220px;color:#fff;font-size:16px;letter-spacing:2px;">••••••••</div>
      <div style="width:40px;height:40px;background:#ff9d76;border-radius:20px;color:#111;font-weight:bold;font-size:20px;display:flex;justify-content:center;align-items:center;">→</div>
    </div>`,

  "mount-fuji": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#333;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;right:0;top:0;width:400px;height:100%;background:rgba(255,255,255,.9);display:flex;flex-direction:column;justify-content:center;align-items:center;gap:40px;z-index:3;">
      <div style="font-size:72px;color:#333;">ZEN</div>
      <div style="width:250px;height:40px;border:1px solid #333;font-size:22px;color:#333;line-height:38px;padding-left:15px;">${USER} ▾</div>
      <div style="width:250px;height:40px;border:1px solid #333;font-size:22px;color:#333;line-height:38px;padding-left:15px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "the-dark-river": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#c5a059;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;top:60px;right:60px;width:600px;height:250px;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="font-size:42px;color:#c5a059;">THE DARK RIVER</div>
      <div style="display:flex;gap:20px;">
        <div style="width:200px;height:45px;background:rgba(0,0,0,.6);border:1px solid #c5a059;font-size:18px;color:#c5a059;text-align:center;line-height:45px;">${USER} ▾</div>
        <div style="width:250px;height:45px;background:rgba(0,0,0,.6);border:1px solid #c5a059;font-size:18px;color:#fff;text-align:center;line-height:45px;letter-spacing:4px;">••••••••</div>
      </div>
    </div>`,

  "purrple-cat": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#a854f7;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:80px;right:80px;width:320px;height:200px;background:rgba(255,255,255,.6);border-radius:20px;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:15px;z-index:3;">
      <div style="font-size:32px;color:#a854f7;">chill out...</div>
      <div style="width:250px;height:40px;background:#fff;border-radius:10px;font-size:20px;color:#a854f7;text-align:center;line-height:40px;">${USER} ▾</div>
      <div style="width:250px;height:40px;background:#fff;border-radius:10px;font-size:20px;color:#555;text-align:center;line-height:40px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "hitagi-senjougahara": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#dc143c;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;right:50px;bottom:50px;width:350px;height:200px;background:rgba(0,0,0,.8);border:4px solid #ff0000;display:flex;flex-direction:column;justify-content:center;align-items:center;z-index:3;">
      <div style="font-size:64px;color:#ff0000;">CRAB</div>
      <div style="display:flex;gap:10px;">
        <div style="width:140px;height:40px;background:#ff0000;font-size:18px;color:#fff;text-align:center;line-height:40px;">${USER} ▾</div>
        <div style="width:140px;height:40px;background:#000;border:2px solid #ff0000;font-size:18px;color:#ff0000;text-align:center;line-height:36px;letter-spacing:4px;">••••••••</div>
      </div>
    </div>`,

  "hilda-and-tepig": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#ff8c00;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;right:60px;bottom:60px;width:350px;height:250px;background:#ff8c00;border-radius:30px;border:6px solid #fff;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:15px;z-index:3;">
      <div style="font-size:42px;color:#fff;">BATTLE!</div>
      <div style="width:250px;height:45px;background:#fff;border-radius:22px;font-size:22px;color:#ff8c00;text-align:center;line-height:45px;">${USER} ▾</div>
      <div style="width:250px;height:45px;background:#fff;border-radius:22px;font-size:22px;color:#ff8c00;text-align:center;line-height:45px;letter-spacing:4px;">••••••••</div>
    </div>`,

  hoodie: n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#39ff14;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;bottom:60px;right:60px;width:450px;height:350px;background:rgba(0,0,0,.6);border:2px solid #39ff14;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="font-size:64px;color:#39ff14;">0xACCESS</div>
      <div style="width:350px;height:50px;background:transparent;border:1px solid #39ff14;font-size:28px;color:#39ff14;text-align:center;line-height:48px;">${USER} ▾</div>
      <div style="width:350px;height:50px;background:transparent;border:1px solid #39ff14;font-size:28px;color:#fff;text-align:center;line-height:48px;letter-spacing:4px;">••••••••</div>
    </div>`,

  "neko-anime": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#00ffff;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;right:80px;top:50%;transform:translateY(-50%);width:400px;height:500px;background:rgba(255,192,203,.15);border:2px solid #00ffff;border-radius:20px;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:20px;z-index:3;">
      <div style="font-size:24px;color:#00ffff;letter-spacing:4px;">ﾈｺ SYSTEM</div>
      <div style="font-size:40px;">🐱</div>
      <div style="width:300px;height:45px;border:1px solid #00ffff;color:#00ffff;line-height:45px;padding-left:10px;font-size:16px;">${USER} ▾</div>
      <div style="width:300px;height:45px;border:1px solid #ff88cc;color:#fff;line-height:45px;padding-left:10px;font-size:16px;letter-spacing:4px;">••••••••</div>
      <div style="width:300px;height:45px;background:#00ffff;color:#000;text-align:center;line-height:45px;font-weight:bold;border-radius:5px;">ﾛｸﾞｲﾝ</div>
    </div>`,

  "zoro-blue": n => `
    <div style="position:absolute;top:40px;width:100%;text-align:center;color:#00aaff;font-family:sans-serif;font-size:84px;z-index:10;">${fmtHM(n)}</div>
    <div style="position:absolute;left:0;width:480px;height:100%;background:rgba(0,0,30,.85);border-right:2px solid #00aaff;display:flex;flex-direction:column;justify-content:center;padding-left:50px;z-index:3;">
      <div style="color:#00aaff;font-size:42px;font-weight:bold;margin-bottom:30px;">ZORO // BLUE</div>
      <div style="width:350px;height:50px;background:rgba(0,170,255,.1);border:1px solid #00aaff;color:#00aaff;line-height:50px;padding-left:15px;font-size:18px;margin-bottom:30px;">${USER} ▾</div>
      <div style="width:350px;height:50px;background:rgba(255,255,255,.05);border:1px solid #00aaff;color:#fff;line-height:50px;padding-left:15px;font-size:18px;margin-bottom:30px;">••••••••</div>
      <div style="width:350px;height:50px;background:#00aaff;color:#000;text-align:center;line-height:50px;font-weight:bold;font-size:18px;">PIERCE THROUGH</div>
    </div>`,
};

/* generic fallback for themes without a specific layout */
function genericLayout(t, n) {
  return `
    <div style="position:absolute;inset:0;background:linear-gradient(to top,rgba(0,0,0,.8) 0%,transparent 60%);z-index:1;"></div>
    <div style="position:absolute;bottom:60px;left:50%;transform:translateX(-50%);width:600px;z-index:3;text-align:center;">
      <div style="color:${t.accent};font-size:56px;font-weight:900;letter-spacing:.05em;text-shadow:0 0 40px ${t.accent}88;">${t.name}</div>
      <div style="margin-top:24px;display:flex;justify-content:center;gap:16px;">
        <div style="width:220px;height:48px;background:rgba(0,0,0,.6);border:1px solid ${t.accent};color:${t.accent};font-size:18px;line-height:48px;padding-left:12px;">${USER} ▾</div>
        <div style="width:220px;height:48px;background:rgba(0,0,0,.6);border:1px solid rgba(255,255,255,.3);color:#fff;font-size:18px;line-height:48px;padding-left:12px;letter-spacing:4px;">••••••••</div>
      </div>
      <div style="margin-top:16px;font-size:11px;letter-spacing:.3em;color:rgba(255,255,255,.4);">${fmtHM(n)} &nbsp;·&nbsp; ${fmtDate(n).toUpperCase()}</div>
    </div>`;
}

/* ── DOM refs ─────────────────────────────── */
const $bg    = document.getElementById("spotlightBg");
const $vid   = document.getElementById("spotlightVideo");
const $name  = document.getElementById("spotlightName");
const $desc  = document.getElementById("spotlightDesc");
const $line  = document.getElementById("spotlightLine");
const $cmd   = document.getElementById("spotlightCmd");
const $grid  = document.getElementById("grid");
const $noRes = document.getElementById("noResults");
const $toast = document.getElementById("toast");
const $dots  = document.getElementById("slideDots");
const $play  = document.getElementById("playBtn");
const $prev  = document.getElementById("prevBtn");
const $next  = document.getElementById("nextBtn");
const $screen = document.querySelector(".spotlight-screen");

/* greeter mock container */
const $mock = document.createElement("div");
$mock.className = "greeter-mock";
const $miniUi = document.createElement("div");
$miniUi.className = "mini-ui";
$mock.appendChild($miniUi);
$screen.appendChild($mock);

/* progress bar */
const $prog = document.createElement("div");
$prog.className = "slide-progress";
$screen.appendChild($prog);

/* ── Scale the mini-ui to fit the preview box ── */
function updateMockScale() {
  const rect = $screen.getBoundingClientRect();
  const scale = rect.width / 1920;
  $miniUi.style.setProperty("--mock-scale", scale);
  $miniUi.style.transform = `translate(-50%,-50%) scale(${scale})`;
}
updateMockScale();
window.addEventListener("resize", updateMockScale);

/* ── Slideshow state ──────────────────────── */
let activeIndex = 0;
let activeFilter = "all";
let searchQ = "";
let autoplay = false;
let autoTimer = null;
const INTERVAL = 4500;

/* live clock tick */
let clockTimer = null;
function startClock(t) {
  clearInterval(clockTimer);
  const render = () => {
    const fn = layouts[t.id];
    $miniUi.innerHTML = fn ? fn(new Date()) : genericLayout(t, new Date());
  };
  render();
  clockTimer = setInterval(render, 1000);
}

/* ── Dots ─────────────────────────────────── */
function buildDots() {
  $dots.innerHTML = "";
  const start = Math.floor(activeIndex / 10) * 10;
  for (let i = start; i < Math.min(start + 10, themes.length); i++) {
    const d = document.createElement("button");
    d.type = "button";
    d.className = "sdot";
    d.dataset.index = i;
    d.setAttribute("aria-label", `Preview ${themes[i].name}`);
    d.addEventListener("click", () => { stopAuto(); goTo(i); });
    $dots.appendChild(d);
  }
}
function updateDots(idx) {
  if (!$dots.querySelector(`[data-index="${idx}"]`)) buildDots();
  $dots.querySelectorAll(".sdot").forEach(d => {
    const selected = Number(d.dataset.index) === idx;
    d.classList.toggle("active", selected);
    d.setAttribute("aria-current", selected ? "true" : "false");
  });
}

/* Discard callbacks from media belonging to an earlier slide. */
let mediaGeneration = 0;
function goTo(idx) {
  activeIndex = ((idx % themes.length) + themes.length) % themes.length;
  const t = themes[activeIndex];
  const generation = ++mediaGeneration;
  const targetUrl = wpUrl(t.id);
  const fallbackUrl = thumbUrl(t.id);
  const current = () => generation === mediaGeneration;
  $vid.oncanplay = $vid.onerror = null;
  $vid.pause();
  $vid.removeAttribute("src");
  $vid.load();
  $vid.style.opacity = "0";
  $bg.style.backgroundImage = `url("${fallbackUrl}")`;
  $bg.style.opacity = "1";

  if (t.animated && !window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    $vid.oncanplay = () => { if (current()) $vid.style.opacity = "1"; };
    $vid.onerror = () => { if (current()) $vid.style.opacity = "0"; };
    $vid.src = targetUrl;
    $vid.load();
    const promise = $vid.play();
    if (promise) promise.catch(() => { /* Thumbnail remains visible if playback fails. */ });
  } else if (!t.animated) {
    const img = new Image();
    img.onload = () => { if (current()) $bg.style.backgroundImage = `url("${targetUrl}")`; };
    img.src = targetUrl;
  }
  $name.textContent = t.name;
  $desc.textContent = t.tag;
  $line.style.background = t.accent;
  $cmd.textContent = `sudo ./install.sh ${t.id}`;
  document.querySelectorAll(".card").forEach(c => {
    const selected = c.dataset.id === t.id;
    c.classList.toggle("active-card", selected);
    c.setAttribute("aria-pressed", String(selected));
  });
  updateDots(activeIndex);
  startClock(t);
  resetProgress();
}

/* ── Progress bar ─────────────────────────── */
function resetProgress() {
  $prog.style.transition = "none";
  $prog.style.width = "0%";
  if (autoplay && !hovering && !document.hidden) {
    requestAnimationFrame(() => requestAnimationFrame(() => {
      $prog.style.transition = `width ${INTERVAL}ms linear`;
      $prog.style.width = "100%";
    }));
  }
}

/* ── Autoplay ─────────────────────────────── */
let startupTimer = null;
let hovering = false;
function scheduleAuto() {
  clearInterval(autoTimer);
  autoTimer = null;
  if (autoplay && !hovering && !document.hidden) {
    resetProgress();
    autoTimer = setInterval(() => goTo(activeIndex + 1), INTERVAL);
  } else {
    $prog.style.transition = "none";
    $prog.style.width = "0%";
  }
}
function startAuto() {
  clearTimeout(startupTimer);
  autoplay = true;
  $play.textContent = "⏸";
  $play.setAttribute("aria-label", "Pause slideshow");
  $play.setAttribute("aria-pressed", "true");
  scheduleAuto();
}
function stopAuto() {
  clearTimeout(startupTimer);
  autoplay = false;
  $play.textContent = "▶";
  $play.setAttribute("aria-label", "Start slideshow");
  $play.setAttribute("aria-pressed", "false");
  scheduleAuto();
}
$play.addEventListener("click", () => autoplay ? stopAuto() : startAuto());
$prev.addEventListener("click", () => { stopAuto(); goTo(activeIndex - 1); });
$next.addEventListener("click", () => { stopAuto(); goTo(activeIndex + 1); });
$screen.addEventListener("mouseenter", () => { hovering = true; scheduleAuto(); });
$screen.addEventListener("mouseleave", () => { hovering = false; scheduleAuto(); });
document.addEventListener("visibilitychange", scheduleAuto);

let toastTimer;
function showToast(msg) {
  clearTimeout(toastTimer);
  $toast.textContent = msg;
  $toast.classList.add("show");
  toastTimer = setTimeout(() => $toast.classList.remove("show"), 2000);
}
async function copyCommand(command) {
  try {
    if (navigator.clipboard && window.isSecureContext) {
      await navigator.clipboard.writeText(command);
    } else {
      const field = document.createElement("textarea");
      field.value = command;
      field.style.cssText = "position:fixed;opacity:0";
      document.body.appendChild(field);
      field.select();
      let copied;
      try { copied = document.execCommand("copy"); }
      finally { field.remove(); }
      if (!copied) throw new Error("Clipboard unavailable");
    }
    showToast("Copied!");
  } catch (_) {
    showToast("Could not copy. Select and copy the command manually.");
  }
}
document.getElementById("spotlightCopy").addEventListener("click", () => copyCommand($cmd.textContent));
document.getElementById("copyBtn").addEventListener("click", () => copyCommand("sudo ./install.sh"));

/* ── Grid ──────────────────────────────────── */
function buildGrid() {
  const q = searchQ.trim().toLowerCase();
  const filtered = themes.filter(t => {
    const matchCat = activeFilter === "all" || t.cats.includes(activeFilter);
    const matchQ = !q || t.name.toLowerCase().includes(q) || t.id.includes(q) || t.tag.includes(q);
    return matchCat && matchQ;
  });
  $noRes.hidden = filtered.length > 0;
  $grid.innerHTML = "";
  filtered.forEach(t => {
    const card = document.createElement("button");
    card.type = "button";
    card.setAttribute("aria-label", `Preview ${t.name}`);
    card.setAttribute("aria-pressed", String(t.id === themes[activeIndex].id));
    card.className = "card" + (t.id === themes[activeIndex].id ? " active-card" : "");
    card.dataset.id = t.id;
    card.style.backgroundImage = `url(${thumbUrl(t.id)})`;
    card.style.backgroundSize = "cover";
    card.style.backgroundPosition = "center";
    card.innerHTML = `
      <div class="card-overlay"></div>
      <div class="card-info">
        <div class="card-name">${t.name}</div>
        <div class="card-tag">${t.tag}</div>
      </div>
      <div class="card-accent-bar" style="background:${t.accent}"></div>`;
    card.addEventListener("click", () => {
      stopAuto();
      activeIndex = themes.indexOf(t);
      goTo(activeIndex);
      document.getElementById("themes").scrollIntoView({behavior:"smooth",block:"start"});
    });
    $grid.appendChild(card);
  });
}

/* ── Filters + Search ──────────────────────── */
document.getElementById("filters").addEventListener("click", e => {
  const btn = e.target.closest(".filter");
  if (!btn) return;
  document.querySelectorAll(".filter").forEach(b => { b.classList.remove("active"); b.setAttribute("aria-pressed", "false"); });
  btn.classList.add("active");
  btn.setAttribute("aria-pressed", "true");
  activeFilter = btn.dataset.tag;
  buildGrid();
});
document.getElementById("search").addEventListener("input", e => {
  searchQ = e.target.value;
  buildGrid();
});
window.clearSearch = () => {
  document.getElementById("search").value = "";
  searchQ = "";
  buildGrid();
};

/* ── Init ──────────────────────────────────── */
buildDots();
goTo(0);
buildGrid();
if (!window.matchMedia("(prefers-reduced-motion: reduce)").matches) startupTimer = setTimeout(startAuto, 2000);
