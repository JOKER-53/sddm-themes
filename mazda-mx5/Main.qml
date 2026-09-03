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
            onAccepted: sddm.login(u.currentText, p.text, sessionModel.lastIndex)
        }
    }
}
