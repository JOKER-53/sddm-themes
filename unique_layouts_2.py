import re
from pathlib import Path

target_dir = Path("/home/joker53/Projects/sddm-themes")

layouts = {
    "moonlit-rooftop-cat": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 320; height: 380; color: "#aa1a237e"; border.color: "#7986cb"; border.width: 3; transform: Rotation { angle: -3 }
            Column { anchors.centerIn: parent; spacing: 25; Text { text: "NIGHT"; font.family: customFont.name; font.pixelSize: 48; color: "#c5cae9" }
            ComboBox { id: u; width: 200; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#c5cae9"; radius: 5 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 22; color: "#1a237e"; anchors.centerIn: parent } }
            TextField { id: p; width: 200; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 22; color: "#1a237e"; background: Rectangle { color: "#c5cae9"; radius: 5 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Patrick Hand', cursive; position:absolute; bottom:60px; right:60px; width:320px; height:380px; background:rgba(26,35,126,0.67); border:3px solid #7986cb; transform:rotate(-3deg); display:flex; flex-direction:column; justify-content:center; align-items:center; gap:25px; z-index:3;">
      <div style="font-size:48px; color:#c5cae9;">NIGHT</div>
      <div style="width:200px; height:50px; background:#c5cae9; border-radius:5px; font-size:22px; color:#1a237e; text-align:center; line-height:50px;">${USER} ▾</div>
      <div style="width:200px; height:50px; background:#c5cae9; border-radius:5px; font-size:22px; color:#1a237e; text-align:center; line-height:50px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "neverness-to-everness": {
        "qml": """Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 60; width: 420; height: 200; color: "#dd000000"
            Rectangle { anchors.left: parent.left; height: parent.height; width: 8; color: "#e91e63" }
            Rectangle { anchors.right: parent.right; height: parent.height; width: 8; color: "#e91e63" }
            Column { anchors.centerIn: parent; spacing: 15; Text { text: "NTE_"; font.family: customFont.name; font.pixelSize: 36; color: "#fff" }
            Row { spacing: 10; ComboBox { id: u; width: 150; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#e91e63" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#fff"; anchors.centerIn: parent } }
            TextField { id: p; width: 150; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#fff"; background: Rectangle { color: "#333"; border.color: "#e91e63"; border.width: 1 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } } }""",
        "js": """<div style="font-family:'Shojumaru', cursive; position:absolute; bottom:60px; left:60px; width:420px; height:200px; background:rgba(0,0,0,0.87); border-left:8px solid #e91e63; border-right:8px solid #e91e63; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:15px; z-index:3;">
      <div style="font-size:36px; color:#fff;">NTE_</div>
      <div style="display:flex; gap:10px;">
        <div style="width:150px; height:40px; background:#e91e63; font-size:18px; color:#fff; text-align:center; line-height:40px;">${USER} ▾</div>
        <div style="width:150px; height:40px; background:#333; border:1px solid #e91e63; font-size:18px; color:#fff; text-align:center; line-height:38px; letter-spacing:4px;">••••••••</div>
      </div>
    </div>"""
    },
    "ocean-in-jar": {
        "qml": """Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 60; width: 300; height: 300; color: "#6603a9f4"; radius: 150; border.color: "#b3e5fc"; border.width: 2
            Column { anchors.centerIn: parent; spacing: 20; Text { text: "ocean"; font.family: customFont.name; font.pixelSize: 32; color: "#fff" }
            ComboBox { id: u; width: 180; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#fff"; radius: 20 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#0277bd"; anchors.centerIn: parent } }
            TextField { id: p; width: 180; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#0277bd"; background: Rectangle { color: "#fff"; radius: 20 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Comfortaa', cursive; position:absolute; bottom:60px; left:60px; width:300px; height:300px; background:rgba(3,169,244,0.4); border:2px solid #b3e5fc; border-radius:150px; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="font-size:32px; color:#fff;">ocean</div>
      <div style="width:180px; height:40px; background:#fff; border-radius:20px; font-size:18px; color:#0277bd; text-align:center; line-height:40px;">${USER} ▾</div>
      <div style="width:180px; height:40px; background:#fff; border-radius:20px; font-size:18px; color:#0277bd; text-align:center; line-height:40px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "pink-bloom": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 450; height: 280; color: "#ffebf0"; radius: 40; border.color: "#e91e63"; border.width: 1
            Column { anchors.centerIn: parent; spacing: 20; Text { text: "Bloom"; font.family: customFont.name; font.pixelSize: 56; color: "#e91e63" }
            Row { spacing: 15; ComboBox { id: u; width: 150; height: 45; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#e91e63"; radius: 10 }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#fff"; anchors.centerIn: parent } }
            TextField { id: p; width: 150; height: 45; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#e91e63"; background: Rectangle { color: "#fff"; border.color: "#e91e63"; border.width: 1; radius: 10 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } } }""",
        "js": """<div style="font-family:'Pacifico', cursive; position:absolute; bottom:60px; right:60px; width:450px; height:280px; background:#ffebf0; border:1px solid #e91e63; border-radius:40px; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="font-size:56px; color:#e91e63;">Bloom</div>
      <div style="display:flex; gap:15px;">
        <div style="width:150px; height:45px; background:#e91e63; border-radius:10px; font-size:20px; color:#fff; text-align:center; line-height:45px;">${USER} ▾</div>
        <div style="width:150px; height:45px; background:#fff; border:1px solid #e91e63; border-radius:10px; font-size:20px; color:#e91e63; text-align:center; line-height:43px; letter-spacing:4px;">••••••••</div>
      </div>
    </div>"""
    },
    "pirates-of-the-caribbean": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 60; width: 400; height: 350; color: "#8d6e63"; border.color: "#3e2723"; border.width: 10
            Rectangle { anchors.fill: parent; anchors.margins: 10; color: "transparent"; border.color: "#5d4037"; border.width: 2 }
            Column { anchors.centerIn: parent; spacing: 30; Text { text: "Captain's Log"; font.family: customFont.name; font.pixelSize: 42; color: "#3e2723" }
            ComboBox { id: u; width: 260; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#3e2723" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#d7ccc8"; anchors.centerIn: parent } }
            TextField { id: p; width: 260; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#3e2723"; background: Rectangle { color: "#d7ccc8"; border.color: "#3e2723"; border.width: 2 }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'Pirata One', cursive; position:absolute; bottom:60px; right:60px; width:400px; height:350px; background:#8d6e63; border:10px solid #3e2723; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:30px; z-index:3;">
      <div style="position:absolute; top:10px; left:10px; right:10px; bottom:10px; border:2px solid #5d4037; pointer-events:none;"></div>
      <div style="font-size:42px; color:#3e2723;">Captain's Log</div>
      <div style="width:260px; height:50px; background:#3e2723; font-size:24px; color:#d7ccc8; text-align:center; line-height:50px;">${USER} ▾</div>
      <div style="width:260px; height:50px; background:#d7ccc8; border:2px solid #3e2723; font-size:24px; color:#3e2723; text-align:center; line-height:46px; letter-spacing:4px;">••••••••</div>
    </div>"""
    },
    "super-mario-pixel": {
        "qml": """Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 60; width: 300; height: 300; color: "#fbc02d"; border.color: "#000"; border.width: 4
            Rectangle { anchors.left: parent.left; anchors.top: parent.top; width: parent.width; height: 4; color: "#fff" }
            Rectangle { anchors.left: parent.left; anchors.top: parent.top; width: 4; height: parent.height; color: "#fff" }
            Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; width: parent.width; height: 4; color: "#b71c1c" }
            Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; width: 4; height: parent.height; color: "#b71c1c" }
            Column { anchors.centerIn: parent; spacing: 20; Text { text: "?"; font.family: customFont.name; font.pixelSize: 100; color: "#d32f2f" }
            ComboBox { id: u; width: 220; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#d32f2f" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#fff"; anchors.centerIn: parent } }
            TextField { id: p; width: 220; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#fff"; background: Rectangle { color: "#d32f2f" }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } }""",
        "js": """<div style="font-family:'VT323', monospace; position:absolute; top:60px; right:60px; width:300px; height:300px; background:#fbc02d; border:4px solid #000; box-shadow: inset 4px 4px 0 #fff, inset -4px -4px 0 #b71c1c; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; z-index:3;">
      <div style="font-size:100px; color:#d32f2f; line-height:1;">?</div>
      <div style="width:220px; height:40px; background:#d32f2f; font-size:20px; color:#fff; text-align:center; line-height:40px;">${USER} ▾</div>
      <div style="width:220px; height:40px; background:#d32f2f; font-size:20px; color:#fff; text-align:center; line-height:40px; letter-spacing:4px;">••••••••</div>
    </div>"""
    }
}

for theme_id, content in layouts.items():
    qml_file = target_dir / theme_id / "Main.qml"
    if qml_file.exists():
        qml_text = qml_file.read_text()
        qml_text = re.sub(r'Rectangle \{[^}]*width: 400; height: 260; color: "#aadddddd".*?Column \{.*?sddm\.login[^\}]+\} \}\n    \}', content["qml"], qml_text, flags=re.DOTALL)
        qml_file.write_text(qml_text)
        print(f"Patched QML for {theme_id}")

js_file = target_dir / "script.js"
if js_file.exists():
    js_text = js_file.read_text()
    for theme_id, content in layouts.items():
        pattern = rf'("{theme_id}": \(n\) => `\n    )<div style="font-family:[^>]+>.*?(</div><div class="gm-power")'
        js_text = re.sub(pattern, rf'\g<1>{content["js"]}\g<2>', js_text, flags=re.DOTALL)
    js_file.write_text(js_text)
    print("Patched JS")

