import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle {
    width: 1920; height: 1080; color: "#000"
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    FontLoader { id: customFont; source: "assets/font.ttf" }
    
    Rectangle {
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.margins: 60; width: 400; height: 250; color: "#ffb6c1"; radius: 0; border.color: "#fff"; border.width: 4
        Column {
            anchors.centerIn: parent; spacing: 15
            Text { text: "PIXEL SAKURA"; font.family: customFont.name; font.pixelSize: 42; color: "#000" }
            ComboBox {
                id: u; width: 280; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#fff"; border.color: "#f06292"; border.width: 2 }
                contentItem: Text { text: u.currentText; font.family: customFont.name; font.pixelSize: 24; color: "#000"; anchors.centerIn: parent }
            }
            TextField {
                id: p; width: 280; height: 50; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#000"
                background: Rectangle { color: "#fff"; border.color: "#f06292"; border.width: 2 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
        }
    }

        Row {
         anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.margins: 20; spacing: 15; z: 100
        ComboBox {
            id: sessionCombo; width: 120; height: 30; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex; font.pixelSize: 11
            background: Rectangle { color: "#aaffb6c1"; radius: 4; border.color: "#fff" }
            contentItem: Text { text: sessionCombo.currentText; color: "#000"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 10 }
        }
        Rectangle {
            width: 80; height: 30; color: "#aaffb6c1"; radius: 4; border.color: "#fff"
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#000"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
        }
        Rectangle {
            width: 90; height: 30; color: "#aaffb6c1"; radius: 4; border.color: "#ff2e63"
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.pixelSize: 11; font.bold: true }
            MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
        }
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
            color: "#ffb6c1"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ffb6c1"
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
