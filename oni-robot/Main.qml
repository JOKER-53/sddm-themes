import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle { anchors.fill: parent; color: "transparent"; border.color: "#ff5500"; border.width: 10; opacity: 0.8 }
    Rectangle {
        anchors.left: parent.left; anchors.leftMargin: 80; anchors.top: parent.top; anchors.topMargin: 80
        width: 400; height: 300; color: "#cc000000"; border.color: "#ff5500"; border.width: 2
        Column {
            anchors.centerIn: parent; spacing: 20
            Text { text: "[ PILOT LOGIN ]"; color: "#ff5500"; font.family: customFont.name; font.pixelSize: 22 }
            ComboBox {
                id: u; width: 300; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#000"; border.color: "#ff5500"; border.width: 1 }
                contentItem: Text { text: "> " + u.currentText; color: "#ff5500"; font.family: customFont.name; font.pixelSize: 18; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            }
            TextField {
                id: p; width: 300; height: 40; placeholderText: "> PASSWORD_"; echoMode: TextInput.Password
                color: "#ff5500"; font.family: customFont.name; font.pixelSize: 18
                background: Rectangle { color: "#000"; border.color: "#ff5500"; border.width: 1 }
                onAccepted: sddm.login(u.currentText, p.text, sessionModel.lastIndex)
            }
        }
    }
}
