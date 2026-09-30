// Red Dead Redemption II — wanted-poster western frame.
// Structure: full-bleed key art, parchment "WANTED" card pinned bottom-center,
// small western clock top-right with double-rule border. Serif throughout.
import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#d4a574"

    width: 1920
    height: 1080
    color: "#1a0e07"

    property color sepia: root.themeAccent
    property color parch: "#e9d8b4"
    property color ink: "#2b1a0e"
    property color rust: "#7a2f1c"

    Common.Wallpaper {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.25
    }

    // top-right clock with double border
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 40
        width: 280
        height: 110
        color: "#ee1a0e07"
        border.color: root.sepia
        border.width: 2
        Rectangle {
            anchors.fill: parent
            anchors.margins: 5
            color: "transparent"
            border.color: root.sepia
            border.width: 1
        }
        Column {
            anchors.centerIn: parent
            spacing: 2
            Text {
                id: rc
                color: root.sepia
                font.family: "Georgia"
                font.bold: true
                font.pixelSize: 44
                text: Qt.formatDateTime(new Date(), "HH:mm")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                color: root.parch
                opacity: 0.7
                font.family: "Georgia"
                font.italic: true
                font.pixelSize: 12
                font.letterSpacing: 3
                text: Qt.formatDateTime(new Date(), "MMMM d, yyyy").toUpperCase()
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: rc.text = Qt.formatDateTime(new Date(), "HH:mm")
        }
    }

    // wanted poster bottom-center
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 56
        width: 640
        height: 280
        color: root.parch
        border.color: root.ink
        border.width: 3
        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            color: "transparent"
            border.color: root.ink
            border.width: 1
        }

        Column {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "─── WANTED ───"
                color: root.ink
                font.family: "Georgia"
                font.bold: true
                font.pixelSize: 28
                font.letterSpacing: 8
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "ALIVE — by order of the camp"
                color: root.rust
                font.family: "Georgia"
                font.italic: true
                font.pixelSize: 13
                font.letterSpacing: 2
            }

            Item {
                width: 1
                height: 4
            }

            Row {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "NAME"
                    color: root.ink
                    font.family: "Georgia"
                    font.bold: true
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                    width: 80
                }
                Rectangle {
                    width: 380
                    height: 38
                    color: "transparent"
                    border.color: root.ink
                    border.width: 1
                    TextField {
                        id: u
                        anchors.fill: parent
                        anchors.margins: 4
                        text: userModel ? userModel.lastUser : ""
                        color: root.ink
                        font.family: "Georgia"
                        font.pixelSize: 16
                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }
            }
            Row {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "CODE"
                    color: root.ink
                    font.family: "Georgia"
                    font.bold: true
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                    width: 80
                }
                Rectangle {
                    width: 380
                    height: 38
                    color: "transparent"
                    border.color: root.ink
                    border.width: 1
                    TextField {
                        id: p
                        enabled: !auth.busy
                        Accessible.name: qsTr("Password")
                        anchors.fill: parent
                        anchors.margins: 4
                        focus: true
                        echoMode: TextInput.Password
                        color: root.ink
                        font.family: "Georgia"
                        font.pixelSize: 16
                        background: Rectangle {
                            color: "transparent"
                        }
                        onAccepted: auth.login(u.text, p.text, auth.sessionIndex)
                    }
                }
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                height: 40
                color: root.rust
                Text {
                    anchors.centerIn: parent
                    text: "RIDE OUT"
                    color: root.parch
                    font.family: "Georgia"
                    font.bold: true
                    font.pixelSize: 16
                    font.letterSpacing: 4
                }
                Common.ActionArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: auth.login(u.text, p.text, auth.sessionIndex)
                }
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 32
        spacing: 24
        Repeater {
            model: [
                {
                    l: "make camp",
                    fn: function () {
                        sddm.suspend();
                    }
                },
                {
                    l: "saddle up",
                    fn: function () {
                        sddm.reboot();
                    }
                },
                {
                    l: "end of trail",
                    fn: function () {
                        sddm.powerOff();
                    }
                }
            ]
            delegate: Text {
                text: modelData.l
                color: root.sepia
                font.family: "Georgia"
                font.italic: true
                font.pixelSize: 13
                font.letterSpacing: 2
                Common.ActionArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.color = root.parch
                    onExited: parent.color = root.sepia
                    onClicked: modelData.fn()
                }
            }
        }
    }

    Component.onCompleted: p.forceActiveFocus()

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

    Common.SessionPicker {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        controller: auth
        z: 100
    }
}
