import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 300; color: "transparent"
        gradient: Gradient { GradientStop { position: 0.0; color: "transparent" }; GradientStop { position: 1.0; color: "#ff000000" } } }
    Row {
        anchors.bottom: parent.bottom; anchors.bottomMargin: 60; anchors.right: parent.right; anchors.rightMargin: 80; spacing: 10
        ComboBox {
            id: u; width: 220; height: 60; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            background: Rectangle { color: "#d4202c" }
            contentItem: Text { text: u.currentText; color: "#fff"; font.pixelSize: 24; font.bold: true; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
        }
        TextField {
            id: p; width: 280; height: 60; placeholderText: "KEY"; echoMode: TextInput.Password
            color: "#fff"; font.pixelSize: 24; horizontalAlignment: TextInput.AlignHCenter
            background: Rectangle { color: "#000"; border.color: "#d4202c"; border.width: 3 }
            onAccepted: sddm.login(u.currentText, p.text, sessionModel.lastIndex)
        }
    }
}
