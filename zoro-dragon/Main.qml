import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    FontLoader { id: customFont; source: "assets/font.ttf" }
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    Rectangle { anchors.left: parent.left; width: 500; height: parent.height; color: "#dd000000"; border.color: "#00ff44"; border.width: 2 }
    Column {
        anchors.left: parent.left; anchors.leftMargin: 50; anchors.verticalCenter: parent.verticalCenter; spacing: 30
        Text { text: "ZORO // DRAGON"; color: "#00ff44"; font.family: customFont.name; font.pixelSize: 42; font.bold: true }
        ComboBox {
            id: u; width: 350; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            background: Rectangle { color: "#2200ff44"; border.color: "#00ff44" }
            contentItem: Text { text: u.currentText; color: "#00ff44"; font.pixelSize: 18; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 15 }
        }
        TextField {
            id: p; width: 350; height: 50; placeholderText: "PASSWORD"; echoMode: TextInput.Password
            color: "#fff"; font.pixelSize: 18; background: Rectangle { color: "#11ffffff"; border.color: "#00ff44" }
            onAccepted: sddm.login(u.currentText, p.text, sessionModel.lastIndex)
        }
        Rectangle {
            width: 350; height: 50; color: "#00ff44"
            Text { anchors.centerIn: parent; text: "UNLEASH"; color: "#000"; font.bold: true; font.pixelSize: 18 }
            MouseArea { anchors.fill: parent; onClicked: sddm.login(u.currentText, p.text, sessionModel.lastIndex) }
        }
    }
}
