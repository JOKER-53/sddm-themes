import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    FontLoader { id: customFont; source: "assets/font.ttf" }
    
    Rectangle {
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.margins: 60; width: 300; height: 300; color: "#6603a9f4"; radius: 150; border.color: "#b3e5fc"; border.width: 2
        Column {
            anchors.centerIn: parent; spacing: 15
            Text { text: "OCEAN JAR"; font.family: customFont.name; font.pixelSize: 42; color: "#000" }
            ComboBox {
                id: u; width: 280; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#fff"; border.color: "#03a9f4"; border.width: 2 }
                contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#000"; anchors.centerIn: parent }
            }
            TextField {
                id: p; width: 280; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#000"
                background: Rectangle { color: "#fff"; border.color: "#03a9f4"; border.width: 2 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
        }
    }

        Row {
         anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 20; spacing: 15; z: 100
        ComboBox {
            id: sessionCombo; width: 120; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex; font.pixelSize: 11
            background: Rectangle { color: "#aa0277bd"; radius: 4; border.color: "#b3e5fc" }
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
        }
        Rectangle {
            width: 80; height: 30; color: "#aa0277bd"; radius: 4; border.color: "#b3e5fc"
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
        }
        Rectangle {
            width: 90; height: 30; color: "#aa0277bd"; radius: 4; border.color: "#ff2e63"
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
        }
    }
}
