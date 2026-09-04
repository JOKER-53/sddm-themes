import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    // Background
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Title floating above the command bar
    Text { 
        anchors.bottom: commandBar.top; anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        text: "SUNSET DRIVE"
        font.family: customFont.name; font.pixelSize: 64; 
        color: "#ff9d76" // Warm sunset peach
        style: Text.Outline; styleColor: "#55000000"
        
        // Subtle floating animation
        SequentialAnimation on anchors.bottomMargin {
            loops: Animation.Infinite
            NumberAnimation { from: 30; to: 35; duration: 2000; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 35; to: 30; duration: 2000; easing.type: Easing.InOutQuad }
        }
    }

    // UNIQUE HORIZONTAL COMMAND BAR (Floating Pill UI)
    Rectangle {
        id: commandBar
        anchors.bottom: parent.bottom; anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        width: 820; height: 60
        color: "#66110a08" // Deep warm dark translucent
        radius: 30
        border.color: "#44ff9d76"; border.width: 1
        
        // Background glow
        Rectangle {
            anchors.fill: parent; radius: 30; color: "transparent"
            border.color: "#22ff9d76"; border.width: 4; z: -1
        }

        Row {
            anchors.fill: parent; anchors.leftMargin: 20; anchors.rightMargin: 10
            spacing: 15

            // 1. User Selection
            ComboBox {
                id: u; width: 140; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle { color: "transparent" }
                contentItem: Text { 
                    text: u.currentText; font.family: "sans-serif"; font.pixelSize: 16; font.bold: true; color: "#ff9d76"
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 36; background: Rectangle { color: parent.hovered ? "#44ff9d76" : "#22110a08" }
                    contentItem: Text { text: model.name; color: "#ff9d76"; font.family: "sans-serif"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }

            // Separator
            Rectangle { width: 1; height: 30; color: "#44ff9d76"; anchors.verticalCenter: parent.verticalCenter }

            // 2. Password Input
            TextField {
                id: p; width: 220; height: 40
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: "Enter password..."
                placeholderTextColor: "#88ff9d76"
                echoMode: TextInput.Password; font.family: "sans-serif"; font.pixelSize: 16; color: "#ffffff"; font.letterSpacing: 2
                background: Rectangle { color: "transparent" }
                verticalAlignment: TextInput.AlignVCenter
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }

            // Login Button (Arrow)
            Rectangle {
                width: 40; height: 40; radius: 20; color: "#ff9d76"
                anchors.verticalCenter: parent.verticalCenter
                Text { anchors.centerIn: parent; text: "→"; color: "#111"; font.pixelSize: 20; font.bold: true }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: parent.color = "#ffffff"
                    onExited: parent.color = "#ff9d76"
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
                }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            // Separator
            Rectangle { width: 1; height: 30; color: "#44ff9d76"; anchors.verticalCenter: parent.verticalCenter }

            // 3. Session Selection
            ComboBox {
                id: sessionCombo; width: 100; height: 40; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle { color: "transparent" }
                contentItem: Text { 
                    text: sessionCombo.currentText; font.family: "sans-serif"; font.pixelSize: 13; color: "#ff9d76"
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#44ff9d76" : "#22110a08" }
                    contentItem: Text { text: model.name; color: "#ff9d76"; font.family: "sans-serif"; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }

            // Separator
            Rectangle { width: 1; height: 30; color: "#44ff9d76"; anchors.verticalCenter: parent.verticalCenter }

            // 4. Power Controls
            Row {
                spacing: 15; height: 40; anchors.verticalCenter: parent.verticalCenter
                
                Text { 
                    text: "⟳"; font.pixelSize: 22; color: "#ff9d76"; font.bold: true; anchors.verticalCenter: parent.verticalCenter
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color = "#ffffff"; onExited: parent.color = "#ff9d76"; onClicked: sddm.reboot() }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                Text { 
                    text: "⏻"; font.pixelSize: 22; color: "#ff5050"; font.bold: true; anchors.verticalCenter: parent.verticalCenter
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color = "#ffffff"; onExited: parent.color = "#ff5050"; onClicked: sddm.powerOff() }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
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
            color: "#ff9d76"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ff9d76"
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
