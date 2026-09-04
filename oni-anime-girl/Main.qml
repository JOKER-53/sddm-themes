import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle {
        anchors.right: parent.right; anchors.rightMargin: 100; anchors.verticalCenter: parent.verticalCenter
        width: 350; height: 450; color: "#99000000"; border.color: "#ff00ff"; border.width: 1; radius: 15
        Column {
            anchors.centerIn: parent; spacing: 25
            Text { text: "ONI // SYSTEM"; color: "#ff00ff"; font.family: customFont.name; font.pixelSize: 24; font.bold: true; font.letterSpacing: 4 }
            ComboBox {
                id: u; width: 280; height: 45; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "transparent"; border.color: "#ff00ff"; border.width: 1 }
                contentItem: Text { text: u.currentText; color: "#ff00ff"; font.family: customFont.name; font.pixelSize: 16; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            }
            TextField {
                id: p; width: 280; height: 45; placeholderText: "PASSCODE"; echoMode: TextInput.Password
                color: "#fff"; font.family: customFont.name; font.pixelSize: 16; background: Rectangle { color: "transparent"; border.color: "#ff00ff"; border.width: 1 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            Rectangle {
                width: 280; height: 45; color: "#ff00ff"
                Text { anchors.centerIn: parent; text: "CONNECT"; color: "#000"; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) }
            }
        }
    }

    Row {
        anchors.top: parent.top; anchors.left: parent.left
        anchors.margins: 20; spacing: 15
        z: 100
        ComboBox {
            id: sessionCombo
            width: 140; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#aa000000"; border.color: "#55ffffff"; radius: 4 }
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.family: customFont.name; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 30
                background: Rectangle { color: parent.hovered ? "#55ffffff" : "#000" }
                contentItem: Text { text: model.name; color: "#fff"; font.family: customFont.name; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter }
            }
        }
        Rectangle {
            width: 80; height: 30; color: "#aa000000"; border.color: "#55ffffff"; radius: 4
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.family: customFont.name; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() }
        }
        Rectangle {
            width: 80; height: 30; color: "#aa000000"; border.color: "#ff2e63"; radius: 4
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.family: customFont.name; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() }
        }
    }

}