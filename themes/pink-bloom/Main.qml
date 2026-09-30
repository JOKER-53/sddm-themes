import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#e91e63"

    width: 1920
    height: 1080
    color: "#000"
    Common.Wallpaper {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
        fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
        fillMode: Image.PreserveAspectFit
    }
    FontLoader {
        id: customFont
        source: "assets/font.ttf"
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 60
        width: 450
        height: 280
        color: "#ffebf0"
        radius: 40
        border.color: root.themeAccent
        border.width: 1
        Column {
            anchors.centerIn: parent
            spacing: 15
            Text {
                text: "PINK BLOOM"
                font.family: customFont.name
                font.pixelSize: 42
                color: "#000"
            }
            ComboBox {
                id: u
                width: 280
                height: 50
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
                background: Rectangle {
                    color: "#fff"
                    border.color: root.themeAccent
                    border.width: 2
                }
                contentItem: Text {
                    text: u.currentText
                    font.family: customFont.name
                    font.pixelSize: 24
                    color: "#000"
                    anchors.centerIn: parent
                }
            }
            TextField {
                id: p
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: 280
                height: 50
                focus: true
                echoMode: TextInput.Password
                font.family: customFont.name
                font.pixelSize: 24
                color: "#000"
                background: Rectangle {
                    color: "#fff"
                    border.color: root.themeAccent
                    border.width: 2
                }
                onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20
        spacing: 15
        z: 100
        ComboBox {
            id: sessionCombo
            width: 120
            height: 30
            model: sessionModel
            textRole: "name"
            currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            font.pixelSize: 11
            background: Rectangle {
                color: "#aaff4081"
                radius: 4
                border.color: "#f8bbd0"
            }
            contentItem: Text {
                text: sessionCombo.currentText
                color: "#fff"
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
        }
        Rectangle {
            width: 80
            height: 30
            color: "#aaff4081"
            radius: 4
            border.color: "#f8bbd0"
            Text {
                anchors.centerIn: parent
                text: "REBOOT"
                color: "#fff"
                font.pixelSize: 11
                font.bold: true
            }
            Common.ActionArea {
                anchors.fill: parent
                onClicked: sddm.reboot()
            }
        }
        Rectangle {
            width: 90
            height: 30
            color: "#aaff4081"
            radius: 4
            border.color: "#ff2e63"
            Text {
                anchors.centerIn: parent
                text: "SHUTDOWN"
                color: "#ff2e63"
                font.pixelSize: 11
                font.bold: true
            }
            Common.ActionArea {
                anchors.fill: parent
                onClicked: sddm.powerOff()
            }
        }
    }

    // Injected Top-Center Clock
    Column {
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -10
        z: 10
        Text {
            id: injectedClockTime
            text: Qt.formatTime(new Date(), "hh:mm")
            font.family: customFont.name
            font.pixelSize: 84
            color: "#ff4081"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ff4081"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                injectedClockTime.text = Qt.formatTime(new Date(), "hh:mm");
                injectedClockDate.text = Qt.formatDate(new Date(), "dddd, MMMM d");
            }
        }
    }

    Common.AuthController {
        id: auth
        passwordField: p
    }
    Common.LoginStatus {
        anchors.top: parent.top
        anchors.topMargin: 160
        anchors.horizontalCenter: parent.horizontalCenter
        controller: auth
    }
}
