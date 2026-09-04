import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
        speed: 1.8 // Increased FPS
        cache: true
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }
    
    Rectangle {
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 60; 
        width: 400; height: 350; color: "#8d6e63"; radius: 0; border.color: "#3e2723"; border.width: 10
        
        // ADDED NEW THING: A gently rotating ship wheel / compass in the background of the box!
        Text {
            text: "⚓"
            font.pixelSize: 150
            color: "#3e2723"
            opacity: 0.15
            anchors.centerIn: parent
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0; to: 360
                duration: 20000
            }
        }

        Column {
            anchors.centerIn: parent; spacing: 15
            Text { text: "BLACK PEARL"; font.family: customFont.name; font.pixelSize: 42; color: "#000"; anchors.horizontalCenter: parent.horizontalCenter }
            ComboBox {
                id: u; width: 280; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#fff"; border.color: "#795548"; border.width: 2 }
                contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#000"; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
                delegate: ItemDelegate {
                    width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#e0e0e0" : "#fff" }
                    contentItem: Text { text: model.name; color: "#000"; font.family: customFont.name; font.pixelSize: 20; verticalAlignment: Text.AlignVCenter }
                }
            }
            TextField {
                id: p; width: 280; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#000"
                background: Rectangle { color: "#fff"; border.color: "#795548"; border.width: 2 }
                anchors.horizontalCenter: parent.horizontalCenter
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
        }
    }

    Row {
         anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 20; spacing: 15; z: 100
        ComboBox {
            id: sessionCombo; width: 120; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex; font.pixelSize: 11
            background: Rectangle { color: "#aa5d4037"; radius: 4; border.color: "#d7ccc8" }
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
        }
        Rectangle {
            width: 80; height: 30; color: "#aa5d4037"; radius: 4; border.color: "#d7ccc8"
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
        }
        Rectangle {
            width: 90; height: 30; color: "#aa5d4037"; radius: 4; border.color: "#ff2e63"
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
        }
    }
}
