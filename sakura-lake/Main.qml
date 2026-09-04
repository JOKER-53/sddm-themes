import QtQuick 2.15; import QtQuick.Controls 2.15 Rectangle { width: 1920; height: 1080; color: "#000" AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true } FontLoader { id: customFont; source: "assets/font.ttf" } Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: 60; anchors.bottomMargin: 60; width: 500; height: 80; color: "#ddffffff"; radius: 40 Row { anchors.centerIn: parent; spacing: 20 ComboBox { id: u; width: 200; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "transparent" }; contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#ffb7c5"; anchors.centerIn: parent } } Rectangle { width: 1; height: 30; color: "#ffb7c5" } TextField { id: p; width: 200; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#555"; background: Rectangle { color: "transparent" }; onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } } 
    Row {
        anchors.top: parent.top; anchors.left: parent.left
        anchors.margins: 20; spacing: 15
        z: 100
        ComboBox {
            id: sessionCombo
            width: 140; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#aa000000"; border.color: "#55ffffff"; radius: 4 }
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            delegate: ItemDelegate { width: sessionCombo.width; height: 30; background: Rectangle { color: parent.hovered ? "#55ffffff" : "#000" }; contentItem: Text { text: model.name; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter } }
        }
        Rectangle { width: 80; height: 30; color: "#aa000000"; border.color: "#55ffffff"; radius: 4 Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.pixelSize: 11; font.bold: true } MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() } }
        Rectangle { width: 80; height: 30; color: "#aa000000"; border.color: "#ff2e63"; radius: 4 Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true } MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() } }
    }
 }