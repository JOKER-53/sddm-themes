import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle { anchors.fill: parent; color: "#33000000" }
    Column {
        anchors.centerIn: parent; spacing: 15
        Text { text: "NIGHT DRIVE"; color: "#05d9e8"; font.pixelSize: 50; font.bold: true; font.italic: true }
        ComboBox {
            id: u; width: 300; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            background: Rectangle { color: "#aa000000"; border.color: "#ff2a6d"; border.width: 2 }
            contentItem: Text { text: u.currentText; color: "#fff"; font.pixelSize: 18; font.italic: true; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
        }
        TextField {
            id: p; width: 300; height: 40; placeholderText: "PASSWORD"; echoMode: TextInput.Password
            color: "#fff"; font.pixelSize: 18; font.italic: true; horizontalAlignment: TextInput.AlignHCenter
            background: Rectangle { color: "#aa000000"; border.color: "#05d9e8"; border.width: 2 }
            onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
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
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 30
                background: Rectangle { color: parent.hovered ? "#55ffffff" : "#000" }
                contentItem: Text { text: model.name; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter }
            }
        }
        Rectangle {
            width: 80; height: 30; color: "#aa000000"; border.color: "#55ffffff"; radius: 4
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() }
        }
        Rectangle {
            width: 80; height: 30; color: "#aa000000"; border.color: "#ff2e63"; radius: 4
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() }
        }
    }

}