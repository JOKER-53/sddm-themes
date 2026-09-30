import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#d4f1f9"
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
        anchors.right: parent.right
        anchors.top: parent.top
        width: 400
        height: parent.height
        color: "#eeffffff"
        Column {
            anchors.centerIn: parent
            spacing: 40
            Text {
                text: "ZEN"
                font.family: customFont.name
                font.pixelSize: 72
                color: "#333"
            }
            ComboBox {
                id: u
                width: 250
                height: 40
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
                background: Rectangle {
                    color: "transparent"
                    border.color: "#333"
                }
                contentItem: Text {
                    text: u.currentText
                    font.family: customFont.name
                    font.pixelSize: 22
                    color: "#333"
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                }
            }
            TextField {
                id: p
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: 250
                height: 40
                focus: true
                echoMode: TextInput.Password
                placeholderText: "password"
                font.family: customFont.name
                font.pixelSize: 22
                color: "#333"
                background: Rectangle {
                    color: "transparent"
                    border.color: "#333"
                }
                onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
        }
    }
    Row {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 15
        z: 100
        ComboBox {
            id: sessionCombo
            width: 140
            height: 30
            model: sessionModel
            textRole: "name"
            currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            background: Rectangle {
                color: "#aa000000"
                border.color: "#55ffffff"
                radius: 4
            }
            contentItem: Text {
                text: sessionCombo.currentText
                color: "#fff"
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            delegate: ItemDelegate {
                id: optionDelegate0
                width: sessionCombo.width
                height: 30
                background: Rectangle {
                    color: optionDelegate0.hovered ? "#55ffffff" : "#000"
                }
                contentItem: Text {
                    text: model.name
                    color: "#fff"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            width: 80
            height: 30
            color: "#aa000000"
            border.color: "#55ffffff"
            radius: 4
            Text {
                anchors.centerIn: parent
                text: "REBOOT"
                color: "#fff"
                font.pixelSize: 11
                font.bold: true
            }
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.reboot()
            }
        }
        Rectangle {
            width: 80
            height: 30
            color: "#aa000000"
            border.color: "#ff2e63"
            radius: 4
            Text {
                anchors.centerIn: parent
                text: "SHUTDOWN"
                color: "#ff2e63"
                font.pixelSize: 11
                font.bold: true
            }
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
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
            color: "#333"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#333"
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
