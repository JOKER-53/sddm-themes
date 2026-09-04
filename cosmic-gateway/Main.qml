import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    FontLoader { id: customFont; source: "assets/font.ttf" }
    
    // Ambient pulsating overlay for sci-fi feel
    Rectangle {
        anchors.fill: parent
        color: "#1a0033"
        opacity: 0.3
        SequentialAnimation on opacity {
            loops: Animation.Infinite; running: true
            NumberAnimation { from: 0.1; to: 0.4; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.4; to: 0.1; duration: 4000; easing.type: Easing.InOutSine }
        }
    }

    // Main Holographic Login HUD
    Item {
        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 80
        width: 450; height: 380; transform: Rotation { angle: 3 }
        z: 10
        
        // Animated scanning grid background
        Rectangle {
            id: hudBg
            anchors.fill: parent; color: "#66000000"
            border.color: "#d500f9"; border.width: 3
            radius: 12
            
            // Subtle animated scanline
            Rectangle {
                width: parent.width; height: 4; color: "#00e5ff"; opacity: 0.5
                SequentialAnimation on y {
                    loops: Animation.Infinite; running: true
                    NumberAnimation { from: 0; to: hudBg.height - 4; duration: 3000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: hudBg.height - 4; to: 0; duration: 3000; easing.type: Easing.InOutSine }
                }
            }
        }
        
        // Outer decorative neon frame
        Rectangle {
            anchors.fill: parent; anchors.margins: -8; color: "transparent"
            border.color: "#00e5ff"; border.width: 1; radius: 18; opacity: 0.5
        }

        Column {
            anchors.centerIn: parent; spacing: 25
            
            // Glowing Title
            Text { 
                text: "GATEWAY ACCESS"; font.family: customFont.name; font.pixelSize: 36; 
                color: "#d500f9"; font.bold: true; font.letterSpacing: 4
                style: Text.Outline; styleColor: "#00e5ff"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Subtitle status
            Text {
                text: "SYSTEM: ONLINE // ENCRYPTED"; font.family: "Monospace"; font.pixelSize: 12; color: "#00e5ff"
                anchors.horizontalCenter: parent.horizontalCenter
                SequentialAnimation on opacity {
                    loops: Animation.Infinite; running: true
                    NumberAnimation { from: 1; to: 0; duration: 100 }
                    PauseAnimation { duration: 100 }
                    NumberAnimation { from: 0; to: 1; duration: 100 }
                    PauseAnimation { duration: 2000 }
                }
            }

            ComboBox {
                id: u; width: 320; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#33000000"; border.color: u.activeFocus ? "#d500f9" : "#00e5ff"; border.width: 2; radius: 6 }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 22; color: "#fff"
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#d500f9" : "#111"; radius: 6 }
                    contentItem: Text { text: model.name; color: "#fff"; font.family: customFont.name; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 320; height: 50; placeholderText: "ENTER PASSCODE"
                placeholderTextColor: "#8800e5ff"
                echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 26; color: "#fff"; font.letterSpacing: 6
                horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle { color: "#33000000"; border.color: p.activeFocus ? "#d500f9" : "#00e5ff"; border.width: 2; radius: 6 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            // Engage Button
            Rectangle {
                width: 200; height: 50; color: "#d500f9"; radius: 6; border.color: "#fff"; border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                Text { anchors.centerIn: parent; text: "INITIALIZE"; color: "#fff"; font.family: customFont.name; font.pixelSize: 20; font.letterSpacing: 3 }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { parent.color = "#00e5ff"; parent.border.color = "#d500f9" }
                    onExited: { parent.color = "#d500f9"; parent.border.color = "#fff" }
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
            }
        }
    }

    // Power Node UI (Bottom Left)
    Row {
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.margins: 40; spacing: 20; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 40; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#66000000"; radius: 4; border.color: "#00e5ff"; border.width: 2 }
            contentItem: Text { text: sessionCombo.currentText; color: "#00e5ff"; font.family: customFont.name; font.pixelSize: 14; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 40; background: Rectangle { color: parent.hovered ? "#00e5ff" : "#111" }
                contentItem: Text { text: model.name; color: parent.hovered ? "#000" : "#00e5ff"; font.family: customFont.name; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Rectangle {
            width: 120; height: 40; color: "#66000000"; radius: 4; border.color: "#00e5ff"; border.width: 2
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#00e5ff"; font.family: customFont.name; font.pixelSize: 14 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#00e5ff"; parent.children[0].color = "#000" }
                onExited: { parent.color = "#66000000"; parent.children[0].color = "#00e5ff" }
                onClicked: sddm.reboot() 
            }
        }
        
        Rectangle {
            width: 130; height: 40; color: "#66000000"; radius: 4; border.color: "#d500f9"; border.width: 2
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#d500f9"; font.family: customFont.name; font.pixelSize: 14 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#d500f9"; parent.children[0].color = "#fff" }
                onExited: { parent.color = "#66000000"; parent.children[0].color = "#d500f9" }
                onClicked: sddm.powerOff() 
            }
        }
    }
}
