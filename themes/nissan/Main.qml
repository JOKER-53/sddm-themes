import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#ffb020"

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

    // Dynamic Tuner Racing Stripe
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 15
        color: "#ff3b00" // Racing orange/red
        opacity: 0.8
    }

    // Elegant Tuner Dashboard Panel (Bottom Right)
    Item {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 750
        height: 350

        // Parallelogram background effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: -50 // Give room for rotation
            color: "#ee0c0c0c" // Very dark, almost solid
            border.color: "#33ffffff"
            border.width: 1
            transform: Rotation {
                angle: -4
                origin.x: 750
                origin.y: 350
            }

            // Inner accent line
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 3
                color: "#ff3b00"
            }
        }

        // Login Content (Rotated slightly to match)
        Column {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 80
            anchors.bottomMargin: 80
            spacing: 25
            transform: Rotation {
                angle: -4
                origin.x: 400
                origin.y: 200
            }

            Text {
                text: "DRIVER AUTHENTICATION"
                font.family: customFont.name
                font.pixelSize: 22
                color: "#ff3b00"
                font.letterSpacing: 6
                font.bold: true
                anchors.right: parent.right
            }

            Row {
                spacing: 20
                anchors.right: parent.right

                ComboBox {
                    id: u
                    width: 220
                    height: 50
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
                    background: Rectangle {
                        color: "#1a1a1a"
                        border.color: u.activeFocus ? "#ff3b00" : "#444444"
                        border.width: 2
                    }
                    contentItem: Text {
                        text: u.currentText
                        color: "#ffffff"
                        font.family: customFont.name
                        font.pixelSize: 18
                        font.letterSpacing: 2
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                    }
                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40
                        background: Rectangle {
                            color: optionDelegate0.hovered ? "#33ff3b00" : "#000"
                        }
                        contentItem: Text {
                            text: model.name
                            color: "#fff"
                            font.family: customFont.name
                            font.pixelSize: 16
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                        }
                    }
                }

                TextField {
                    id: p
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 260
                    height: 50
                    placeholderText: "ACCESS CODE"
                    placeholderTextColor: "#666666"
                    focus: true
                    echoMode: TextInput.Password
                    font.family: customFont.name
                    font.pixelSize: 18
                    color: "#ffffff"
                    font.letterSpacing: 6
                    anchors.leftMargin: 20
                    padding: 20
                    background: Rectangle {
                        color: "#1a1a1a"
                        border.color: p.activeFocus ? "#ff3b00" : "#444444"
                        border.width: 2
                    }
                    onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
                }

                Rectangle {
                    width: 70
                    height: 50
                    color: "#ff3b00"
                    Text {
                        anchors.centerIn: parent
                        text: "GO"
                        color: "#000"
                        font.family: customFont.name
                        font.pixelSize: 18
                        font.bold: true
                    }
                    Common.ActionArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: {
                            parent.color = "#ffffff";
                        }
                        onExited: {
                            parent.color = "#ff3b00";
                        }
                        onClicked: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }
    }

    // Power Controls (Top Right, Sleek)
    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 40
        spacing: 20
        z: 100

        ComboBox {
            id: sessionCombo
            width: 140
            height: 36
            model: sessionModel
            textRole: "name"
            currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            background: Rectangle {
                color: "transparent"
            }
            contentItem: Text {
                text: sessionCombo.currentText
                color: "#ffffff"
                font.family: customFont.name
                font.pixelSize: 14
                font.letterSpacing: 2
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
            }
            delegate: ItemDelegate {
                id: optionDelegate1

                width: sessionCombo.width
                height: 36
                background: Rectangle {
                    color: optionDelegate1.hovered ? "#33ff3b00" : "#111"
                }
                contentItem: Text {
                    text: model.name
                    color: "#ffffff"
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
            font.family: customFont.name
            font.pixelSize: 14
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ff3b00";
                }
                onExited: {
                    parent.color = "#ffffff";
                }
                onClicked: sddm.reboot()
            }
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }

        Text {
            text: "SHUTDOWN"
            color: "#ffffff"
            font.family: customFont.name
            font.pixelSize: 14
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ff3b00";
                }
                onExited: {
                    parent.color = "#ffffff";
                }
                onClicked: sddm.powerOff()
            }
            Behavior on color {
                ColorAnimation {
                    duration: 150
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
            color: "#ff3b00"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ff3b00"
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
