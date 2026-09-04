import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Minimalist, premium login panel
    Rectangle {
        id: loginPanel
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right; anchors.rightMargin: 120
        width: 380; height: 420
        color: "#99000000" // Deep translucent black
        radius: 16
        border.color: "#33ffffff"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 35
            
            // Elegant Title
            Text { 
                text: "GATEWAY"
                font.family: customFont.name; font.pixelSize: 28; font.letterSpacing: 8
                color: "#ffffff"; opacity: 0.9
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // User Selection
            ComboBox {
                id: u; width: 280; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                
                // Minimalist bottom-border style
                background: Rectangle { 
                    color: "transparent"
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: u.activeFocus ? "#fff" : "#44ffffff" }
                }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 18; font.letterSpacing: 2
                    color: "#ffffff"; opacity: 0.9
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40
                    background: Rectangle { color: parent.hovered ? "#1affffff" : "transparent" }
                    contentItem: Text { 
                        text: model.name; color: "#ffffff"; opacity: parent.hovered ? 1.0 : 0.6
                        font.family: customFont.name; font.pixelSize: 16; font.letterSpacing: 2
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter 
                    }
                }
            }
            
            // Password Input
            TextField {
                id: p; width: 280; height: 40
                placeholderText: "PASSWORD"
                placeholderTextColor: "#55ffffff"
                echoMode: TextInput.Password
                font.family: customFont.name; font.pixelSize: 18; font.letterSpacing: 6
                color: "#ffffff"
                horizontalAlignment: TextInput.AlignHCenter
                
                // Minimalist bottom-border style
                background: Rectangle { 
                    color: "transparent"
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: p.activeFocus ? "#fff" : "#44ffffff" }
                }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            // Clean Submit Button
            Rectangle {
                width: 160; height: 44; color: "transparent"; radius: 22
                border.color: "#ffffff"; border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                
                Text { 
                    anchors.centerIn: parent; text: "CONNECT"; color: parent.color == "#ffffff" ? "#000" : "#fff" 
                    font.family: customFont.name; font.pixelSize: 14; font.letterSpacing: 4
                }
                
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: parent.color = "#ffffff"
                    onExited: parent.color = "transparent"
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
                
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }
    }

    // Elegant, understated power controls
    Row {
        anchors.bottom: parent.bottom; anchors.right: parent.right
        anchors.margins: 40; spacing: 25; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 32; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent" }
            contentItem: Text { 
                text: sessionCombo.currentText; color: "#ffffff"; opacity: 0.6
                font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 1
                verticalAlignment: Text.AlignVCenter; anchors.right: parent.right
            }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 32; background: Rectangle { color: parent.hovered ? "#1affffff" : "#111" }
                contentItem: Text { 
                    text: model.name; color: "#ffffff"; opacity: parent.hovered ? 1.0 : 0.6
                    font.family: customFont.name; font.pixelSize: 12
                    horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter 
                }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#ffffff"; opacity: 0.5
            font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: parent.opacity = 1.0
                onExited: parent.opacity = 0.5
                onClicked: sddm.reboot() 
            }
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#ffffff"; opacity: 0.5
            font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: parent.opacity = 1.0
                onExited: parent.opacity = 0.5
                onClicked: sddm.powerOff() 
            }
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
    }
}
