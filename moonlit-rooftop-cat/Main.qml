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

    // Subtle dark gradient from right to left
    Rectangle {
        anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom
        width: 800
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#aa0a0a1a" } // Deep midnight
        }
        rotation: 90 // Horizontal gradient
        transformOrigin: Item.Center
    }

    // Lo-Fi Style Floating Glass Player
    Rectangle {
        id: loginCard
        anchors.right: parent.right; anchors.rightMargin: 120
        anchors.verticalCenter: parent.verticalCenter
        width: 360; height: 420
        color: "#330a0a2a" // Deep translucent purple/blue
        radius: 24
        border.color: "#33ffd54f"; border.width: 1 // Subtle moon-gold border
        
        Column {
            anchors.centerIn: parent; spacing: 25

            // Title Area
            Column {
                spacing: 5; anchors.horizontalCenter: parent.horizontalCenter
                Text { 
                    text: "MOONLIT ROOFTOP"; font.family: customFont.name; font.pixelSize: 26; 
                    color: "#ffd54f"; font.letterSpacing: 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline; styleColor: "#44000000"
                }
                Text { 
                    text: "lofi vibes ~ relax and focus"; font.family: "sans-serif"; font.pixelSize: 12; 
                    color: "#b39ddb"; font.letterSpacing: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            ComboBox {
                id: u; width: 280; height: 46; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle { 
                    color: "#44000000"; radius: 23; border.color: u.activeFocus ? "#ffd54f" : "#44ffd54f"; border.width: 1 
                }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#ffffff"; font.letterSpacing: 2
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#33ffd54f" : "#111" }
                    contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 280; height: 46; placeholderText: "PASSWORD"
                placeholderTextColor: "#88b39ddb"
                echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#ffffff"; font.letterSpacing: 4
                horizontalAlignment: TextInput.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle { 
                    color: "#44000000"; radius: 23; border.color: p.activeFocus ? "#ffd54f" : "#44ffd54f"; border.width: 1 
                }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            // Login Button (Play Button Style)
            Rectangle {
                width: 160; height: 46; color: "transparent"; radius: 23; border.color: "#ffd54f"; border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                
                Text { anchors.centerIn: parent; text: "ENTER ▶"; color: "#ffd54f"; font.family: customFont.name; font.pixelSize: 16; font.letterSpacing: 4; font.bold: true }
                
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { parent.color = "#ffd54f"; parent.children[0].color = "#000" }
                    onExited: { parent.color = "transparent"; parent.children[0].color = "#ffd54f" }
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
            contentItem: Text { text: sessionCombo.currentText; color: "#b39ddb"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#33ffd54f" : "#111" }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#b39ddb"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffd54f" }
                onExited: { parent.color = "#b39ddb" }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#b39ddb"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffd54f" }
                onExited: { parent.color = "#b39ddb" }
                onClicked: sddm.powerOff() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }
}
