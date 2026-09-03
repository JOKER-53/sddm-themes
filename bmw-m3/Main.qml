import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 150; color: "#ee0a0a0a"; border.color: "#1c69d4"; border.width: 1 }
    Row {
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottomMargin: 50; spacing: 40
        ComboBox {
            id: u; width: 250; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            background: Rectangle { color: "transparent"; border.color: "#1c69d4"; border.width: 2; radius: 25 }
            contentItem: Text { text: u.currentText; color: "#fff"; font.pixelSize: 18; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
        }
        TextField {
            id: p; width: 300; height: 50; placeholderText: "PIN CODE"; echoMode: TextInput.Password
            color: "#fff"; font.pixelSize: 18; horizontalAlignment: TextInput.AlignHCenter
            background: Rectangle { color: "transparent"; border.color: "#1c69d4"; border.width: 2; radius: 25 }
            onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
        }
        Rectangle {
            width: 150; height: 50; color: "#1c69d4"; radius: 25
            Text { anchors.centerIn: parent; text: "START ENGINE"; color: "#fff"; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) }
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