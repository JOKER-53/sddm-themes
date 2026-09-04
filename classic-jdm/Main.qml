import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#000"

    property color amber: "#f5a623"
    property color panel: "#e60a0a0a"
    property color text:  "#ececec"
    property color dim:   "#7a7a7a"
    property color redAlert: "#e53935"

    Image {
        anchors.fill: parent
        source: "assets/wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }
    
    // Vignette for dramatic effect
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa000000" }
            GradientStop { position: 0.3; color: "transparent" }
            GradientStop { position: 0.7; color: "transparent" }
            GradientStop { position: 1.0; color: "#ee000000" }
        }
    }

    // Toy car driving across the top of the HUD
    Text {
        id: toyCar
        text: "🏎️💨"
        font.pixelSize: 32
        y: hud.y - 32
        x: -100
        z: 10
        SequentialAnimation on x {
            loops: Animation.Infinite
            running: true
            NumberAnimation { from: -100; to: root.width + 100; duration: 5000; easing.type: Easing.InOutQuad }
            PauseAnimation { duration: 4000 }
            NumberAnimation { from: root.width + 100; to: -100; duration: 4500; easing.type: Easing.InOutQuad }
            PauseAnimation { duration: 3000 }
        }
        // Flip the car when going backwards
        transform: Scale {
            origin.x: toyCar.width/2
            xScale: toyCar.x > root.width/2 && toyCar.xAnimationDirection < 0 ? -1 : 1 // Pseudo logic, we'll just use property trick
        }
    }
    
    // Track direction for the car flip
    
    // Better way to do the car
    Item {
        id: carContainer
        y: hud.y - 32
        x: -100
        width: 60; height: 32
        z: 10
        Text {
            id: carEmoji
            anchors.centerIn: parent
            text: "🏎️"
            font.pixelSize: 32
            transform: Scale { origin.x: carEmoji.width/2; xScale: carContainer.goingRight ? 1 : -1 }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: carContainer.goingRight ? carEmoji.left : undefined
            anchors.left: carContainer.goingRight ? undefined : carEmoji.right
            text: "💨"
            font.pixelSize: 24
        }
        property bool goingRight: true
        SequentialAnimation on x {
            loops: Animation.Infinite
            running: true
            ScriptAction { script: carContainer.goingRight = true }
            NumberAnimation { from: -100; to: root.width + 100; duration: 6000; easing.type: Easing.InOutQuad }
            PauseAnimation { duration: 2000 }
            ScriptAction { script: carContainer.goingRight = false }
            NumberAnimation { from: root.width + 100; to: -100; duration: 5000; easing.type: Easing.InOutCubic }
            PauseAnimation { duration: 3000 }
        }
    }

    // ---- Dashboard HUD bar ----
    Rectangle {
        id: hud
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        height: 140
        color: root.panel
        border.color: root.amber; border.width: 2
        
        // Carbon fiber / scanline pattern overlay
        Column {
            anchors.fill: parent
            Repeater {
                model: 35
                Rectangle { width: parent.width; height: 2; color: index % 2 == 0 ? "#11ffffff" : "transparent" }
            }
        }

        // Left Cluster: Clock and RPM
        Row {
            anchors.left: parent.left; anchors.leftMargin: 48
            anchors.verticalCenter: parent.verticalCenter
            spacing: 30
            
            Column {
                anchors.verticalCenter: parent.verticalCenter
                Text { id: clk; color: root.amber; font.family: "Monospace"; font.pixelSize: 56; font.bold: true; text: Qt.formatDateTime(new Date(), "HH:mm:ss") }
                Text { id: dt; color: root.dim; font.family: "Monospace"; font.pixelSize: 14; font.letterSpacing: 3; text: Qt.formatDateTime(new Date(), "ddd dd MMM yyyy").toUpperCase() }
            }
            
            // Animated RPM Gauge
            Row {
                anchors.bottom: parent.bottom; anchors.bottomMargin: 30; spacing: 4
                Repeater {
                    model: 12
                    Rectangle {
                        property int baseHeight: index > 8 ? 60 : 40
                        width: 10; height: 10; radius: 2
                        color: index > 8 ? root.redAlert : root.amber
                        Behavior on height { NumberAnimation { duration: 150 } }
                        Timer { running: true; repeat: true; interval: 100 + Math.random() * 200; onTriggered: parent.height = 10 + Math.random() * parent.baseHeight }
                    }
                }
            }
        }
        
        Timer { interval: 1000; running: true; repeat: true
            onTriggered: { clk.text = Qt.formatDateTime(new Date(), "HH:mm:ss"); dt.text = Qt.formatDateTime(new Date(), "ddd dd MMM yyyy").toUpperCase() } }

        // center login
        Row {
            anchors.centerIn: parent; spacing: 20
            
            // Decorative label
            Text {
                text: "SYSTEM\nOVERRIDE"; color: root.dim; font.family: "Monospace"; font.pixelSize: 10; font.bold: true
                horizontalAlignment: Text.AlignRight; anchors.verticalCenter: parent.verticalCenter; font.letterSpacing: 2
            }
            
            TextField {
                id: u; width: 220; height: 50
                text: userModel ? userModel.lastUser : ""
                placeholderText: "USER"
                color: root.text; font.family: "Monospace"; font.pixelSize: 20; font.bold: true; horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle { color: "#33000000"; border.color: u.activeFocus ? root.amber : root.dim; border.width: 2 }
            }
            TextField {
                id: p; width: 320; height: 50
                placeholderText: "PASSWORD"; echoMode: TextInput.Password
                color: root.text; font.family: "Monospace"; font.pixelSize: 20; font.bold: true; horizontalAlignment: TextInput.AlignHCenter; font.letterSpacing: 6
                background: Rectangle { color: "#33000000"; border.color: p.activeFocus ? root.amber : root.dim; border.width: 2 }
                onAccepted: sddm.login(u.text, p.text, s.currentIndex)
            }
            Rectangle {
                width: 120; height: 50; color: root.amber
                Text { anchors.centerIn: parent; text: "IGNITION"; color: "#000"; font.family: "Monospace"; font.bold: true; font.letterSpacing: 3; font.pixelSize: 18 }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: parent.color = "#ffd54f"
                    onExited: parent.color = root.amber
                    onClicked: sddm.login(u.text, p.text, s.currentIndex) 
                }
                SequentialAnimation on opacity {
                    loops: Animation.Infinite; running: true
                    NumberAnimation { from: 0.8; to: 1.0; duration: 800 }
                    NumberAnimation { from: 1.0; to: 0.8; duration: 800 }
                }
            }
        }

        // right cluster
        Row {
            anchors.right: parent.right; anchors.rightMargin: 48
            anchors.verticalCenter: parent.verticalCenter; spacing: 30
            ComboBox {
                id: s; width: 180; height: 40; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
                background: Rectangle { color: "#33000000"; border.color: root.dim; border.width: 1 }
                contentItem: Text { text: s.currentText; color: root.amber; font.family: "Monospace"; font.pixelSize: 14; font.bold: true; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
                delegate: ItemDelegate {
                    width: s.width; height: 40; background: Rectangle { color: parent.hovered ? root.amber : "#111" }
                    contentItem: Text { text: model.name; color: parent.hovered ? "#000" : root.amber; font.family: "Monospace"; font.pixelSize: 14; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            Text { 
                id: pwr; text: "⏻"; color: root.amber; font.pixelSize: 32 
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { pwr.color = root.redAlert; pwr.font.pixelSize = 36 }
                    onExited: { pwr.color = root.amber; pwr.font.pixelSize = 32 }
                    onClicked: sddm.powerOff() 
                } 
                Behavior on font.pixelSize { NumberAnimation { duration: 150 } }
            }
            Text { 
                id: rbt; text: "↻"; color: root.amber; font.pixelSize: 32
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { rbt.color = "#4fc3f7"; rbt.rotation = 180 }
                    onExited: { rbt.color = root.amber; rbt.rotation = 0 }
                    onClicked: sddm.reboot() 
                } 
                Behavior on rotation { NumberAnimation { duration: 300 } }
            }
        }
    }

    Connections { target: sddm; function onLoginFailed() { p.text = "" } }
    Component.onCompleted: p.forceActiveFocus()
}
