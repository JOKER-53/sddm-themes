import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    // Minecraft Sakura Background
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true
        speed: 1.8 // Increased FPS / playback speed as requested
        cache: true
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Soft gradient to ensure UI readability
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: "transparent" }
            GradientStop { position: 1.0; color: "#aa000000" }
        }
    }

    // Sakura / Blocky UI Panel
    Rectangle {
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 80
        width: 450; height: 200
        color: "#44ffffff" // Soft frosted glass
        radius: 12
        border.color: "#ffb7c5"; border.width: 2 // Sakura pink border
        
        Column {
            anchors.centerIn: parent; spacing: 20
            
            Text { 
                text: "SKYLINE SPEC-R"; font.family: customFont.name; font.pixelSize: 28; 
                color: "#ffffff"; font.letterSpacing: 4; font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Outline; styleColor: "#ff8da1" // Sakura pink outline
            }
            
            Row {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                ComboBox {
                    id: u; width: 180; height: 46; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                    background: Rectangle { color: "#33000000"; radius: 8; border.color: u.activeFocus ? "#ffffff" : "#ffb7c5"; border.width: 2 }
                    contentItem: Text { 
                        text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#ffffff"
                        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                    }
                    delegate: ItemDelegate {
                        width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#ffb7c5" : "#33000000" }
                        contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    }
                }
                
                TextField {
                    id: p; width: 180; height: 46; placeholderText: "PASSWORD"
                    placeholderTextColor: "#aaffffff"
                    echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#ffffff"; font.letterSpacing: 4
                    horizontalAlignment: TextInput.AlignHCenter
                    background: Rectangle { color: "#33000000"; radius: 8; border.color: p.activeFocus ? "#ffffff" : "#ffb7c5"; border.width: 2 }
                    onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
                }
            }
        }
    }

    // Minimalist Power Controls
    Row {
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 40; spacing: 25; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent" }
            contentItem: Text { text: sessionCombo.currentText; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.right: parent.right }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#ffb7c5" : "#111" }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 14; horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffb7c5" }
                onExited: { parent.color = "#ffffff" }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffb7c5" }
                onExited: { parent.color = "#ffffff" }
                onClicked: sddm.powerOff() 
            }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }
}
