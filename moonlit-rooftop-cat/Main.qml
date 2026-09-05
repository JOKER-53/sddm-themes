import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    // Lo-Fi Animated Background
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Removed the broken gradient overlay that ruined the image

    // Lo-Fi Style Floating Glass Player
    Rectangle {
        id: loginCard
        anchors.right: parent.right; anchors.rightMargin: 80
        anchors.bottom: parent.bottom; anchors.bottomMargin: 80
        width: 380; height: 380
        color: "#44000000" // Simple, clean translucent glass
        radius: 20
        border.color: "#33ffffff"; border.width: 1 // Very subtle white border, much cleaner than yellow
        
        Column {
            anchors.centerIn: parent; spacing: 25

            // Title Area
            Column {
                spacing: 5; anchors.horizontalCenter: parent.horizontalCenter
                Text { 
                    text: "MOONLIT ROOFTOP"; font.family: customFont.name; font.pixelSize: 26; 
                    color: "#ffffff"; font.letterSpacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline; styleColor: "#55000000"
                }
                Text { 
                    text: "lofi vibes ~ relax and focus"; font.family: "sans-serif"; font.pixelSize: 12; 
                    color: "#b39ddb"; font.letterSpacing: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            ComboBox {
                id: u; width: 300; height: 46; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle { 
                    color: "#33000000"; radius: 23; border.color: u.activeFocus ? "#b39ddb" : "#44ffffff"; border.width: 1 
                }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#ffffff"; font.letterSpacing: 2
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#55ffffff" : "#111" }
                    contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 300; height: 46; placeholderText: "PASSWORD"
                placeholderTextColor: "#88ffffff"
                focus: true; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#ffffff"; font.letterSpacing: 4
                horizontalAlignment: TextInput.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle { 
                    color: "#33000000"; radius: 23; border.color: p.activeFocus ? "#b39ddb" : "#44ffffff"; border.width: 1 
                }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            // Login Button (Play Button Style)
            Rectangle {
                width: 160; height: 46; color: "transparent"; radius: 23; border.color: "#b39ddb"; border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                
                Text { anchors.centerIn: parent; text: "ENTER ▶"; color: "#b39ddb"; font.family: customFont.name; font.pixelSize: 16; font.letterSpacing: 4; font.bold: true }
                
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { parent.color = "#b39ddb"; parent.children[0].color = "#000" }
                    onExited: { parent.color = "transparent"; parent.children[0].color = "#b39ddb" }
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
                Behavior on color { ColorAnimation { duration: 250 } }
            }
        }
    }

    // Power Controls (Top Left, clean and subtle)
    Row {
        anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 40; spacing: 25; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent" }
            contentItem: Text { text: sessionCombo.currentText; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#55ffffff" : "#111" }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#b39ddb" }
                onExited: { parent.color = "#ffffff" }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#b39ddb" }
                onExited: { parent.color = "#ffffff" }
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
            color: "#b39ddb"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#b39ddb"
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
