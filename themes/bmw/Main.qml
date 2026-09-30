// BMW Museum — top placard, M-stripe accent column on the left side
// (keeps the cars on the right visible). Login behaves like a key-fob panel.
import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#1c69d4"

    width: 1920
    height: 1080
    color: "#000000"

    property color mBlue: root.themeAccent
    property color mPurple: "#1f2e6e"
    property color mRed: "#e22718"
    property color ink: "#f4f4f4"
    property color sub: "#9a9a9a"

    Common.Wallpaper {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // Left dim wash so the panel reads
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.36
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: "#000000"
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }

    // M-stripe column
    Row {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        Rectangle {
            width: 8
            height: parent.height
            color: root.mBlue
        }
        Rectangle {
            width: 8
            height: parent.height
            color: root.mPurple
        }
        Rectangle {
            width: 8
            height: parent.height
            color: root.mRed
        }
    }

    // Top museum placard
    Row {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 48
        anchors.leftMargin: 80
        spacing: 16
        Rectangle {
            width: 14
            height: 14
            radius: 7
            color: "#fff"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: "BMW · M-MOTORSPORT"
            color: root.ink
            font.family: "Helvetica"
            font.pixelSize: 14
            font.letterSpacing: 5
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: "—  1986  —  E28 M535i"
            color: root.sub
            font.family: "Helvetica"
            font.pixelSize: 12
            font.letterSpacing: 3
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Key-fob login panel — left third
    ColumnLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 80
        width: 380
        spacing: 10

        Text {
            text: "IGNITION"
            color: root.mBlue
            font.family: "Helvetica"
            font.pixelSize: 11
            font.letterSpacing: 5
        }
        TextField {
            id: bmwUser
            text: userModel ? userModel.lastUser : ""
            placeholderText: "USERNAME"
            background: Rectangle {
                color: "transparent"
            }
            color: root.ink
            font.family: "Helvetica"
            font.pixelSize: 36
            font.bold: true
        }
        Text {
            text: "Authorized operator"
            color: root.sub
            font.pixelSize: 12
            font.letterSpacing: 2
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: root.mBlue
            Layout.topMargin: 14
        }

        TextField {
            id: passField
            Layout.fillWidth: true
            placeholderText: "ENTER KEY CODE"
            placeholderTextColor: root.sub
            focus: true
            echoMode: TextInput.Password
            color: root.ink
            font.family: "Helvetica"
            font.pixelSize: 18
            font.letterSpacing: 6
            background: Rectangle {
                color: "transparent"
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 2
                    color: root.mRed
                }
            }
            onAccepted: auth.login(bmwUser.text, passField.text, auth.sessionIndex)
        }

        Row {
            spacing: 10
            Layout.topMargin: 18
            Rectangle {
                width: 110
                height: 36
                color: root.mBlue
                Text {
                    anchors.centerIn: parent
                    text: "▸ START"
                    color: "#fff"
                    font.family: "Helvetica"
                    font.pixelSize: 12
                    font.letterSpacing: 4
                }
                Common.ActionArea {
                    anchors.fill: parent
                    onClicked: auth.login(bmwUser.text, passField.text, auth.sessionIndex)
                }
            }
            Rectangle {
                width: 90
                height: 36
                color: "transparent"
                border.color: root.sub
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "PLASMA"
                    color: root.sub
                    font.family: "Helvetica"
                    font.pixelSize: 11
                    font.letterSpacing: 3
                }
            }
        }
    }

    // Telemetry bottom-left
    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 80
        anchors.bottomMargin: 36
        spacing: 28
        Repeater {
            model: [
                {
                    l: "⏻ OFF",
                    fn: function () {
                        sddm.powerOff();
                    }
                },
                {
                    l: "↻ RST",
                    fn: function () {
                        sddm.reboot();
                    }
                },
                {
                    l: "☾ SLP",
                    fn: function () {
                        sddm.suspend();
                    }
                }
            ]
            delegate: Text {
                text: modelData.l
                color: root.sub
                font.family: "Helvetica"
                font.pixelSize: 11
                font.letterSpacing: 3
                Common.ActionArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.fn()
                }
            }
        }
    }

    Component.onCompleted: passField.forceActiveFocus()

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
            font.family: "sans-serif"
            font.pixelSize: 84
            color: "#ffffff"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: "sans-serif"
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
        passwordField: passField
    }
    Common.LoginStatus {
        anchors.top: parent.top
        anchors.topMargin: 160
        anchors.horizontalCenter: parent.horizontalCenter
        controller: auth
    }

    Common.SessionPicker {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        controller: auth
        z: 100
    }
}
