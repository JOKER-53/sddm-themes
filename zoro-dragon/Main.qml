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
            id: p; width: 350; height: 50; placeholderText: "PASSWORD"; focus: true; echoMode: TextInput.Password
            color: "#fff"; font.pixelSize: 18; background: Rectangle { color: "#11ffffff"; border.color: "#00ff44" }
            onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
        }
        Rectangle {
            width: 350; height: 50; color: "#00ff44"
            Text { anchors.centerIn: parent; text: "UNLEASH"; color: "#000"; font.bold: true; font.pixelSize: 18 }
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
            color: "#00ff44"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#00ff44"
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