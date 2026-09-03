import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle { anchors.centerIn: parent; width: 600; height: 100; color: "#dd000000"; transform: Rotation { angle: -3 } }
    Row {
        anchors.centerIn: parent; spacing: 20
        ComboBox {
            id: u; width: 200; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            background: Rectangle { color: "#ffb020" }
            contentItem: Text { text: u.currentText; color: "#000"; font.pixelSize: 18; font.bold: true; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter }
        }
        TextField {
            id: p; width: 250; height: 40; placeholderText: "PASSWORD"; echoMode: TextInput.Password
            color: "#fff"; font.pixelSize: 18; background: Rectangle { color: "#000"; border.color: "#ffb020"; border.width: 2 }
            onAccepted: sddm.login(u.currentText, p.text, sessionModel.lastIndex)
        }
    }
}
