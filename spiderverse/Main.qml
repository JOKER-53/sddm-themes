import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    // Background with reduced FPS for a glitchy/stop-motion Spiderverse feel
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
        speed: 0.5 // Reduced FPS as requested
        cache: true
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // --- SPIDER WEBS SUSPENDING THE CARD ---
    // Web 1: Top right ceiling to top right of card
    Rectangle {
        x: 1500; y: -50; width: 400; height: 2; color: "#ffffff"
        opacity: 0.6; transformOrigin: Item.TopLeft; rotation: 70
        // subtle shadow/glow
        Rectangle { anchors.fill: parent; color: "#00ffff"; opacity: 0.5; anchors.margins: -1; z: -1 }
    }
    // Web 2: Right wall to bottom right of card
    Rectangle {
        x: 1920; y: 600; width: 300; height: 1; color: "#ffffff"
        opacity: 0.4; transformOrigin: Item.TopLeft; rotation: 165
    }
    // Web 3: Ceiling to top left of card
    Rectangle {
        x: 1200; y: -10; width: 500; height: 1; color: "#ffffff"
        opacity: 0.5; transformOrigin: Item.TopLeft; rotation: 55
        Rectangle { anchors.fill: parent; color: "#ff00ff"; opacity: 0.5; anchors.margins: -1; z: -1 }
    }
    // Web 4: Bottom edge to bottom left of card
    Rectangle {
        x: 1300; y: 1090; width: 400; height: 2; color: "#ffffff"
        opacity: 0.3; transformOrigin: Item.TopLeft; rotation: -60
    }

    // --- SUSPENDED GLITCH CARD ---
    Rectangle {
        id: loginCard
        anchors.right: parent.right; anchors.rightMargin: 150
        anchors.verticalCenter: parent.verticalCenter
        width: 380; height: 480
        color: "#111111"
        radius: 10
        border.color: "#222222"; border.width: 2
        
        // Glitch shadow effect (Cyan and Magenta)
        Rectangle {
            anchors.fill: parent; anchors.margins: -4
            anchors.horizontalCenterOffset: -4; anchors.verticalCenterOffset: 2
            color: "transparent"; border.color: "#00ffff"; border.width: 2
            radius: 12; z: -1; opacity: 0.7
        }
        Rectangle {
            anchors.fill: parent; anchors.margins: -4
            anchors.horizontalCenterOffset: 4; anchors.verticalCenterOffset: -2
            color: "transparent"; border.color: "#ff00ff"; border.width: 2
            radius: 12; z: -2; opacity: 0.7
        }

        Column {
            anchors.centerIn: parent; spacing: 25

            // SPIDER LOGO
            Text {
                text: "🕷"
                font.pixelSize: 64; color: "#ff0044"
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Subtle heartbeat animation
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.1; duration: 400; easing.type: Easing.OutQuad }
                    NumberAnimation { from: 1.1; to: 1.0; duration: 400; easing.type: Easing.InQuad }
                    PauseAnimation { duration: 1000 }
                }
            }

            Text { 
                text: "SYSTEM_ACCESS"; font.family: customFont.name; font.pixelSize: 28; 
                color: "#ffffff"; font.letterSpacing: 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ComboBox {
                id: u; width: 300; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { 
                    color: "#000000"; border.color: u.activeFocus ? "#00ffff" : "#333333"; border.width: 2 
                }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#00ffff"
                    verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 15
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#00ffff" : "#000000" }
                    contentItem: Text { text: model.name; color: parent.hovered ? "#000000" : "#00ffff"; font.family: customFont.name; font.pixelSize: 18; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 300; height: 50; placeholderText: "PASSWORD"
                placeholderTextColor: "#666666"
                echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#ff00ff"; font.letterSpacing: 4
                anchors.leftMargin: 15; padding: 15
                background: Rectangle { 
                    color: "#000000"; border.color: p.activeFocus ? "#ff00ff" : "#333333"; border.width: 2 
                }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }

            Rectangle {
                width: 300; height: 50; color: "#ff0044"
                Text { anchors.centerIn: parent; text: "CONNECT"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 20; font.bold: true; font.letterSpacing: 4 }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { parent.color = "#ffffff"; parent.children[0].color = "#ff0044" }
                    onExited: { parent.color = "#ff0044"; parent.children[0].color = "#ffffff" }
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
                Behavior on color { ColorAnimation { duration: 100 } }
            }
        }
    }

    // Power Controls (Top Left, Hacker Style)
    Row {
        anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 40; spacing: 20; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent"; border.color: "#00ffff"; border.width: 1 }
            contentItem: Text { text: sessionCombo.currentText; color: "#00ffff"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#00ffff" : "#000" }
                contentItem: Text { text: model.name; color: parent.hovered ? "#000" : "#00ffff"; font.family: customFont.name; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Rectangle {
            width: 120; height: 36; color: "transparent"; border.color: "#ff00ff"; border.width: 1
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#ff00ff"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ff00ff"; parent.children[0].color = "#000" }
                onExited: { parent.color = "transparent"; parent.children[0].color = "#ff00ff" }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
        
        Rectangle {
            width: 120; height: 36; color: "transparent"; border.color: "#ff0044"; border.width: 1
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff0044"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ff0044"; parent.children[0].color = "#fff" }
                onExited: { parent.color = "transparent"; parent.children[0].color = "#ff0044" }
                onClicked: sddm.powerOff() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    // Injected Top-Center Clock
    Column {
        anchors.top: parent.top; anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -10; z: 10
        Text {
            id: injectedClockTime
            text: Qt.formatTime(new Date(), "hh:mm")
            font.family: customFont.name
            font.pixelSize: 84
            color: "#ff00ff"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ff00ff"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                injectedClockTime.text = Qt.formatTime(new Date(), "hh:mm")
                injectedClockDate.text = Qt.formatDate(new Date(), "dddd, MMMM d")
            }
        }
    }
}
