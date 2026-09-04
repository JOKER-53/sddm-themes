import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#ffffff"
    
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Pokeball UI Card
    Rectangle {
        id: loginCard
        anchors.bottom: parent.bottom; anchors.right: parent.right
        anchors.margins: 80
        width: 320; height: 380
        radius: 40
        color: "#ffffff"
        border.color: "#222222"; border.width: 6
        
        // Red Top Half
        Rectangle {
            width: parent.width - 12; height: (parent.height / 2) - 6
            anchors.top: parent.top; anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#E3350D"
            radius: 34
            
            // Square off the bottom corners of the red half
            Rectangle {
                width: parent.width; height: 40
                anchors.bottom: parent.bottom
                color: "#E3350D"
            }
        }
        
        // Black Center Band
        Rectangle {
            width: parent.width; height: 16
            anchors.centerIn: parent
            color: "#222222"
        }
        
        // Pokeball Center Button (Login)
        Rectangle {
            id: pokeButton
            width: 100; height: 100; radius: 50
            anchors.centerIn: parent
            color: "#ffffff"
            border.color: "#222222"; border.width: 16
            
            // Inner clickable button
            Rectangle {
                anchors.centerIn: parent
                width: 50; height: 50; radius: 25
                color: pokeMouse.pressed ? "#cccccc" : (pokeMouse.containsMouse ? "#eeeeee" : "#ffffff")
                border.color: "#dddddd"; border.width: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "GO"; font.family: "sans-serif"; font.pixelSize: 16; font.bold: true; color: "#222"
                    opacity: pokeMouse.containsMouse ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }
            
            MouseArea {
                id: pokeMouse
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
        }

        // USERNAME INPUT (Top Red Half)
        ComboBox {
            id: u; width: 240; height: 46; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 50
            background: Rectangle { 
                color: "#ffffff"; radius: 23; border.color: u.activeFocus ? "#222222" : "transparent"; border.width: 3 
            }
            contentItem: Text { 
                text: u.currentText; font.family: customFont.name; font.pixelSize: 18; color: "#E3350D"
                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.bold: true
            }
            delegate: ItemDelegate {
                width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#ffdddd" : "#ffffff" }
                contentItem: Text { text: model.name; color: "#E3350D"; font.family: customFont.name; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }

        // PASSWORD INPUT (Bottom White Half)
        TextField {
            id: p; width: 240; height: 46; placeholderText: "PASSWORD"
            placeholderTextColor: "#aaaaaa"
            echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 18; color: "#222222"
            horizontalAlignment: TextInput.AlignHCenter; font.letterSpacing: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom; anchors.bottomMargin: 50
            background: Rectangle { 
                color: "#f5f5f5"; radius: 23; border.color: p.activeFocus ? "#E3350D" : "#dddddd"; border.width: 3 
            }
            onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
        }
    }

    // Power Controls (Top Right)
    Row {
        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 30; spacing: 15; z: 100
        
        ComboBox {
            id: sessionCombo; width: 120; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#ffffff"; radius: 18; border.color: "#222222"; border.width: 3 }
            contentItem: Text { text: sessionCombo.currentText; color: "#222222"; font.family: customFont.name; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.bold: true }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#ffdddd" : "#ffffff" }
                contentItem: Text { text: model.name; color: "#222222"; font.family: customFont.name; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Rectangle {
            width: 100; height: 36; color: "#ffffff"; radius: 18; border.color: "#222222"; border.width: 3
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#222222"; font.family: customFont.name; font.pixelSize: 12; font.bold: true }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: parent.color = "#ffdddd"
                onExited: parent.color = "#ffffff"
                onClicked: sddm.reboot() 
            }
        }
        
        Rectangle {
            width: 110; height: 36; color: "#E3350D"; radius: 18; border.color: "#222222"; border.width: 3
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; font.bold: true }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: parent.color = "#ff5555"
                onExited: parent.color = "#E3350D"
                onClicked: sddm.powerOff() 
            }
        }
    }
}
