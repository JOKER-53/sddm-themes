import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle { width: 1920; height: 1080; color: "#000"; AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
 FontLoader { id: customFont; source: "assets/font.ttf" }
 Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 80; width: 320; height: 200; color: "#aaffffff"; radius: 20; Column { anchors.centerIn: parent; spacing: 15; Text { text: "chill out..."; font.family: customFont.name; font.pixelSize: 32; color: "#a854f7" }
 ComboBox { id: u; width: 250; height: 40; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex; background: Rectangle { color: "#fff"; radius: 10 }
 contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#a854f7"; anchors.centerIn: parent } }
 TextField { id: p; width: 250; height: 40; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#555"; background: Rectangle { color: "#fff"; radius: 10 }
 onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) } } } 
    Row {
        anchors.top: parent.top; anchors.left: parent.left
        anchors.margins: 20; spacing: 15
        z: 100
        ComboBox {
            id: sessionCombo
            width: 140; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#aa000000"; border.color: "#55ffffff"; radius: 4 }
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
            delegate: ItemDelegate { width: sessionCombo.width; height: 30; background: Rectangle { color: parent.hovered ? "#55ffffff" : "#000" }
 contentItem: Text { text: model.name; color: "#fff"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter } }
        }
        Rectangle { width: 80; height: 30; color: "#aa000000"; border.color: "#55ffffff"; radius: 4; Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.pixelSize: 11; font.bold: true }
 MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() } }
        Rectangle { width: 80; height: 30; color: "#aa000000"; border.color: "#ff2e63"; radius: 4; Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true }
 MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() } }
    }
 
    // Injected Top-Center Clock
    Column {
        anchors.top: parent.top; anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -10; z: 10
        Text {
            id: injectedClockTime
            text: Qt.formatTime(new Date(), "hh:mm")
            font.family: customFont.name
            font.pixelSize: 84
            color: "#a854f7"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#a854f7"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                injectedClockTime.text = Qt.formatTime(new Date(), "hh:mm")
                injectedClockDate.text = Qt.formatDate(new Date(), "dddd, MMMM d")
            }
        }
    }
}