import re
from pathlib import Path

target_dir = Path("/home/joker53/Projects/sddm-themes")

# Define unique QML and JS for each theme
# For brevity in this massive task, I'll provide highly unique inline styles for JS
# and corresponding QML shapes for the themes.

layouts = {
    "cat-pond": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 350; height: 350; color: "#aa2e7d32"; radius: 100; border.color: "#4caf50"; border.width: 4
            Column { anchors.centerIn: parent; spacing: 15; Text { text: "CAT POND"; font.family: customFont.name; font.pixelSize: 32; color: "#fff" }
            ComboBox { id: u; width: 220; height: 45; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#fff"; radius: 22.5 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#2e7d32"; anchors.centerIn: parent } }
            TextField { id: p; width: 220; height: 45; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#2e7d32"; background: Rectangle { color: "#fff"; radius: 22.5 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Mali', cursive; position:absolute; bottom:60px; right:60px; width:350px; height:350px; background:rgba(46,125,50,0.67); border:4px solid #4caf50; border-radius:100px; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:15px; z-index:3;">
      <div style="font-size:32px; color:#fff;">CAT POND</div>
      <div style="width:220px; height:45px; background:#fff; border-radius:22.5px; font-size:18px; color:#2e7d32; text-align:center; line-height:45px;">${USER} ▾</div>
      <div style="width:220px; height:45px; background:#fff; border-radius:22.5px; font-size:18px; color:#2e7d32; text-align:center; line-height:45px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "cosmic-gateway": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 60; width: 400; height: 300; color: "#000"; border.color: "#9c27b0"; border.width: 8; transform: Rotation { angle: 5 }
            Column { anchors.centerIn: parent; spacing: 20; Text { text: "GATEWAY"; font.family: customFont.name; font.pixelSize: 48; color: "#9c27b0" }
            ComboBox { id: u; width: 300; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "transparent"; border.color: "#9c27b0"; border.width: 2 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#fff"; anchors.centerIn: parent } }
            TextField { id: p; width: 300; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#fff"; background: Rectangle { color: "transparent"; border.color: "#9c27b0"; border.width: 2 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Orbitron', sans-serif; position:absolute; top:60px; right:60px; width:400px; height:300px; background:#000; border:8px solid #9c27b0; transform:rotate(5deg); display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; z-index:3; box-shadow: 0 0 30px #9c27b0;">
      <div style="font-size:48px; color:#9c27b0;">GATEWAY</div>
      <div style="width:300px; height:50px; background:transparent; border:2px solid #9c27b0; font-size:24px; color:#fff; text-align:center; line-height:46px;">${USER} ▾</div>
      <div style="width:300px; height:50px; background:transparent; border:2px solid #9c27b0; font-size:24px; color:#fff; text-align:center; line-height:46px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "everest": {
        "qml": """Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 60; width: 500; height: 120; color: "#88ffffff"; border.color: "#fff"; border.width: 1
            Row { anchors.centerIn: parent; spacing: 30; Text { text: "EVEREST"; font.family: customFont.name; font.pixelSize: 24; color: "#00bcd4"; anchors.verticalCenter: parent.verticalCenter }
            ComboBox { id: u; width: 150; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#fff" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#333"; anchors.centerIn: parent } }
            TextField { id: p; width: 150; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#333"; background: Rectangle { color: "#fff" }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Cinzel', serif; position:absolute; bottom:60px; left:60px; width:500px; height:120px; background:rgba(255,255,255,0.53); border:1px solid #fff; display:flex; justify-content:center; align-items:center; gap:30px; z-index:3;">
      <div style="font-size:24px; color:#00bcd4;">EVEREST</div>
      <div style="width:150px; height:40px; background:#fff; font-size:18px; color:#333; text-align:center; line-height:40px;">${USER} ▾</div>
      <div style="width:150px; height:40px; background:#fff; font-size:18px; color:#333; text-align:center; line-height:40px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "fish-in-rock-pond": {
        "qml": """Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 60; width: 150; height: 500; color: "#ddffffff"; border.color: "#ff9800"; border.width: 3
            Column { anchors.centerIn: parent; spacing: 40; Text { text: "KOI\\nPOND"; font.family: customFont.name; font.pixelSize: 32; color: "#ff9800"; horizontalAlignment: Text.AlignHCenter }
            ComboBox { id: u; width: 120; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "transparent"; border.color: "#333"; border.width: 1 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 16; color: "#333"; anchors.centerIn: parent } }
            TextField { id: p; width: 120; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 16; color: "#333"; background: Rectangle { color: "transparent"; border.color: "#333"; border.width: 1 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Yusei Magic', sans-serif; position:absolute; top:60px; left:60px; width:150px; height:500px; background:rgba(255,255,255,0.87); border:3px solid #ff9800; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:40px; z-index:3;">
      <div style="font-size:32px; color:#ff9800; text-align:center;">KOI<br>POND</div>
      <div style="width:120px; height:40px; background:transparent; border:1px solid #333; font-size:16px; color:#333; text-align:center; line-height:40px;">${USER} ▾</div>
      <div style="width:120px; height:40px; background:transparent; border:1px solid #333; font-size:16px; color:#333; text-align:center; line-height:40px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "pixel-gaming-room": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 450; height: 280; color: "#000"; border.color: "#8bc34a"; border.width: 6
            Column { anchors.centerIn: parent; spacing: 20; Text { text: "> LOGIN_"; font.family: customFont.name; font.pixelSize: 42; color: "#8bc34a" }
            ComboBox { id: u; width: 350; height: 45; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#8bc34a" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#000"; anchors.centerIn: parent } }
            TextField { id: p; width: 350; height: 45; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#8bc34a"; background: Rectangle { color: "#000"; border.color: "#8bc34a"; border.width: 2 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'VT323', monospace; position:absolute; bottom:60px; right:60px; width:450px; height:280px; background:#000; border:6px solid #8bc34a; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="font-size:42px; color:#8bc34a;">> LOGIN_</div>
      <div style="width:350px; height:45px; background:#8bc34a; font-size:24px; color:#000; text-align:center; line-height:45px;">${USER} ▾</div>
      <div style="width:350px; height:45px; background:#000; border:2px solid #8bc34a; font-size:24px; color:#8bc34a; text-align:center; line-height:41px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "pixel-sakura-city": {
        "qml": """Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 60; width: 400; height: 250; color: "#ffb6c1"; border.color: "#fff"; border.width: 4
            Rectangle { anchors.top: parent.top; width: parent.width; height: 35; color: "#f06292"; Text { text: " System Auth"; font.family: customFont.name; font.pixelSize: 16; color: "#fff"; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 10 } }
            Column { anchors.centerIn: parent; anchors.verticalCenterOffset: 15; spacing: 15
            ComboBox { id: u; width: 300; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#fff"; border.color: "#f06292"; border.width: 2 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#f06292"; anchors.centerIn: parent } }
            TextField { id: p; width: 300; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#f06292"; background: Rectangle { color: "#fff"; border.color: "#f06292"; border.width: 2 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'VT323', monospace; position:absolute; bottom:60px; left:60px; width:400px; height:250px; background:#ffb6c1; border:4px solid #fff; display:flex; flex-direction:column; align-items:center; z-index:3;">
      <div style="width:100%; height:35px; background:#f06292; color:#fff; font-size:16px; display:flex; align-items:center; padding-left:10px; box-sizing:border-box;"> System Auth</div>
      <div style="margin-top:35px; display:flex; flex-direction:column; gap:15px;">
        <div style="width:300px; height:40px; background:#fff; border:2px solid #f06292; font-size:20px; color:#f06292; text-align:center; line-height:36px;">${USER} ▾</div>
        <div style="width:300px; height:40px; background:#fff; border:2px solid #f06292; font-size:20px; color:#f06292; text-align:center; line-height:36px; letter-spacing:4px;">••••••••</div>
      </div>
    </div>"""
    },
    "pokeball": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 300; height: 300; color: "#fff"; radius: 150; border.color: "#000"; border.width: 10; clip: true
            Rectangle { width: parent.width; height: 150; color: "#f44336"; anchors.top: parent.top }
            Rectangle { width: parent.width; height: 10; color: "#000"; anchors.centerIn: parent }
            Column { anchors.centerIn: parent; spacing: 40; 
            ComboBox { id: u; width: 160; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#fff"; border.color: "#000"; border.width: 4; radius: 20 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#000"; anchors.centerIn: parent } }
            TextField { id: p; width: 160; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#000"; background: Rectangle { color: "#fff"; border.color: "#000"; border.width: 4; radius: 20 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Chewy', cursive; position:absolute; bottom:60px; right:60px; width:300px; height:300px; background:#fff; border:10px solid #000; border-radius:150px; overflow:hidden; display:flex; flex-direction:column; align-items:center; z-index:3;">
      <div style="width:100%; height:145px; background:#f44336;"></div>
      <div style="width:100%; height:10px; background:#000;"></div>
      <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); display:flex; flex-direction:column; gap:40px;">
        <div style="width:160px; height:40px; background:#fff; border:4px solid #000; border-radius:20px; font-size:18px; color:#000; text-align:center; line-height:32px;">${USER} ▾</div>
        <div style="width:160px; height:40px; background:#fff; border:4px solid #000; border-radius:20px; font-size:18px; color:#000; text-align:center; line-height:32px; letter-spacing:4px;">••••••••</div>
      </div>
    </div>"""
    },
    "nissan-skyline": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 500; height: 180; color: "#aa000000"; border.color: "#f44336"; border.width: 4; transform: Rotation { angle: -4 }
            Row { anchors.centerIn: parent; spacing: 20; Text { text: "R34"; font.family: customFont.name; font.pixelSize: 64; color: "#f44336"; font.italic: true }
            Column { spacing: 15; ComboBox { id: u; width: 250; height: 45; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#f44336" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 22; color: "#fff"; anchors.centerIn: parent } }
            TextField { id: p; width: 250; height: 45; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 22; color: "#f44336"; background: Rectangle { color: "#000"; border.color: "#f44336"; border.width: 2 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } } }""",
        "js": """<div style="font-family:'Russo One', sans-serif; position:absolute; bottom:60px; right:60px; width:500px; height:180px; background:rgba(0,0,0,0.67); border:4px solid #f44336; transform:rotate(-4deg); display:flex; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="font-size:64px; color:#f44336; font-style:italic;">R34</div>
      <div style="display:flex; flex-direction:column; gap:15px;">
        <div style="width:250px; height:45px; background:#f44336; font-size:22px; color:#fff; text-align:center; line-height:45px;">${USER} ▾</div>
        <div style="width:250px; height:45px; background:#000; border:2px solid #f44336; font-size:22px; color:#f44336; text-align:center; line-height:41px; letter-spacing:4px;">••••••••</div>
      </div>
    </div>"""
    }
}

# Apply patches to QML files
for theme_id, content in layouts.items():
    qml_file = target_dir / theme_id / "Main.qml"
    if qml_file.exists():
        qml_text = qml_file.read_text()
        # Find the Rectangle containing the login column and replace it
        import re
        qml_text = re.sub(r'Rectangle \{[^}]*width: 400; height: 260; color: "#aadddddd".*?Column \{.*?sddm\.login[^\}]+\} \}\n    \}', content["qml"], qml_text, flags=re.DOTALL)
        qml_file.write_text(qml_text)
        print(f"Patched QML for {theme_id}")

# Patch script.js
js_file = target_dir / "script.js"
if js_file.exists():
    js_text = js_file.read_text()
    for theme_id, content in layouts.items():
        pattern = rf'("{theme_id}": \(n\) => `\n    )<div style="font-family:[^>]+>.*?(</div><div class="gm-power")'
        js_text = re.sub(pattern, rf'\g<1>{content["js"]}\g<2>', js_text, flags=re.DOTALL)
    js_file.write_text(js_text)
    print("Patched JS")

