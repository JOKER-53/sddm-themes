import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#9c27b0"

    width: 1920
    height: 1080
    color: "#000"

    Common.Wallpaper {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
        fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
        fillMode: Image.PreserveAspectCrop
    }
    FontLoader {
        id: customFont
        source: "assets/font.ttf"
    }

    // Minimalist, premium login panel
    Rectangle {
        id: loginPanel
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 120
        width: 380
        height: 420
        color: "#99000000" // Deep translucent black
        radius: 16
        border.color: "#33ffffff"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 35

            // Elegant Title
            Text {
                text: "GATEWAY"
                font.family: customFont.name
                font.pixelSize: 28
                font.letterSpacing: 8
                color: "#ffffff"
                opacity: 0.9
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // User Selection
            ComboBox {
                id: u
                width: 280
                height: 40
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                // Minimalist bottom-border style
                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: u.activeFocus ? "#fff" : "#44ffffff"
                    }
                }
                contentItem: Text {
                    text: u.currentText
                    font.family: customFont.name
                    font.pixelSize: 18
                    font.letterSpacing: 2
                    color: "#ffffff"
                    opacity: 0.9
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                delegate: ItemDelegate {
                    id: optionDelegate0

                    width: u.width
                    height: 40
                    background: Rectangle {
                        color: optionDelegate0.hovered ? "#1affffff" : "transparent"
                    }
                    contentItem: Text {
                        text: model.name
                        color: "#ffffff"
                        opacity: optionDelegate0.hovered ? 1.0 : 0.6
                        font.family: customFont.name
                        font.pixelSize: 16
                        font.letterSpacing: 2
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Password Input
            TextField {
                id: p
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: 280
                height: 40
                placeholderText: "PASSWORD"
                placeholderTextColor: "#55ffffff"
                focus: true
                echoMode: TextInput.Password
                font.family: customFont.name
                font.pixelSize: 18
                font.letterSpacing: 6
                color: "#ffffff"
                horizontalAlignment: TextInput.AlignHCenter

                // Minimalist bottom-border style
                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: p.activeFocus ? "#fff" : "#44ffffff"
                    }
                }
                onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
            }

            // Clean Submit Button
            Rectangle {
                width: 160
                height: 44
                color: "transparent"
                radius: 22
                border.color: "#ffffff"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    anchors.centerIn: parent
                    text: "CONNECT"
                    color: parent.color == "#ffffff" ? "#000" : "#fff"
                    font.family: customFont.name
                    font.pixelSize: 14
                    font.letterSpacing: 4
                }

                Common.ActionArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.color = "#ffffff"
                    onExited: parent.color = "transparent"
                    onClicked: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }
    }

    // Elegant, understated power controls
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        spacing: 25
        z: 100

        ComboBox {
            id: sessionCombo
            width: 140
            height: 32
            model: sessionModel
            textRole: "name"
            currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            background: Rectangle {
                color: "transparent"
            }
            contentItem: Text {
                text: sessionCombo.currentText
                color: "#ffffff"
                opacity: 0.6
                font.family: customFont.name
                font.pixelSize: 12
                font.letterSpacing: 1
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
            }
            delegate: ItemDelegate {
                id: optionDelegate1

                width: sessionCombo.width
                height: 32
                background: Rectangle {
                    color: optionDelegate1.hovered ? "#1affffff" : "#111"
                }
                contentItem: Text {
                    text: model.name
                    color: "#ffffff"
                    opacity: optionDelegate1.hovered ? 1.0 : 0.6
                    font.family: customFont.name
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Text {
            text: "RESTART"
            color: "#ffffff"
            opacity: 0.5
            font.family: customFont.name
            font.pixelSize: 12
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.opacity = 1.0
                onExited: parent.opacity = 0.5
                onClicked: sddm.reboot()
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        Text {
            text: "SHUTDOWN"
            color: "#ffffff"
            opacity: 0.5
            font.family: customFont.name
            font.pixelSize: 12
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.opacity = 1.0
                onExited: parent.opacity = 0.5
                onClicked: sddm.powerOff()
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
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
            color: "#ffffff"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ffffff"
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
