import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Cinematic bottom vignette/gradient
    Rectangle {
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        height: 600
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.6; color: "#aa000000" }
            GradientStop { position: 1.0; color: "#ee000000" }
        }
    }

    // Main UI Container (Bottom Center)
    Item {
        anchors.bottom: parent.bottom; anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        width: 600; height: 250
        
        Column {
            anchors.centerIn: parent; spacing: 30
            
            // Cinematic Title
            Text { 
                text: "THE DARK RIVER"
                font.family: customFont.name; font.pixelSize: 54; 
                color: "#c5a059" // Elegant gold
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Outline; styleColor: "#55000000"
                
                // Subtle glowing pulse
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.8; to: 1.0; duration: 3000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.0; to: 0.8; duration: 3000; easing.type: Easing.InOutSine }
                }
            }

            // Inputs Row
            Row {
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                ComboBox {
                    id: u; width: 220; height: 46; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                    background: Rectangle { 
                        color: "#22000000"; border.color: u.activeFocus ? "#f0d498" : "#c5a059"; border.width: 1 
                    }
                    contentItem: Text { 
                        text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#c5a059"
                        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                    }
                    delegate: ItemDelegate {
                        width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#33c5a059" : "#111" }
                        contentItem: Text { text: model.name; color: "#c5a059"; font.family: customFont.name; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    }
                }
                
                TextField {
                    id: p; width: 260; height: 46; placeholderText: "ENTER SECRET"
                    placeholderTextColor: "#66c5a059"
                    echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"; font.letterSpacing: 4
                    horizontalAlignment: TextInput.AlignHCenter
                    background: Rectangle { 
                        color: "#22000000"; border.color: p.activeFocus ? "#f0d498" : "#c5a059"; border.width: 1 
                    }
                    onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
                }
                
                // Login Button
                Rectangle {
                    width: 60; height: 46; color: "transparent"; border.color: "#c5a059"; border.width: 1
                    Text { anchors.centerIn: parent; text: "▶"; color: "#c5a059"; font.pixelSize: 18 }
                    MouseArea { 
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onEntered: { parent.color = "#c5a059"; parent.children[0].color = "#000" }
                        onExited: { parent.color = "transparent"; parent.children[0].color = "#c5a059" }
                        onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                    }
                    Behavior on color { ColorAnimation { duration: 250 } }
                }
            }
        }
    }

    // Power Controls (Top Right, minimalist)
    Row {
        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 40; spacing: 25; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent" }
            contentItem: Text { text: sessionCombo.currentText; color: "#c5a059"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.right: parent.right }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#33c5a059" : "#111" }
                contentItem: Text { text: model.name; color: "#c5a059"; font.family: customFont.name; font.pixelSize: 12; horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#c5a059"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffffff" }
                onExited: { parent.color = "#c5a059" }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#c5a059"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffffff" }
                onExited: { parent.color = "#c5a059" }
                onClicked: sddm.powerOff() 
            }
            Behavior on color { ColorAnimation { duration: 200 } }
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
            color: "#c5a059"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#c5a059"
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
