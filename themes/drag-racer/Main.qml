// Drag Racer — racing telemetry overlay.
// Structure: full-bleed photo, top-left HUD with huge clock + lap-time vibe,
// bottom-right pill-shaped login. Race red accent, italic condensed type.
import QtQuick 2.15
import QtQuick.Controls 2.15
import "components" as Common

Rectangle {
    id: viewport

    property color themeAccent: root.themeAccent
    readonly property bool compactMode: width < 1200 || height < 680
    readonly property real layoutScale: Math.min(width / 1920, height / 1080)

    width: 1920
    height: 1080
    color: "#000000"

    Rectangle {
        // bottom-left power row

        id: root

        property color themeAccent: config.brand || config.accent || "#e63946"
        property color red: root.themeAccent
        property color white: "#ffffff"
        property color dim: "#8cffffff"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"
        Component.onCompleted: p.forceActiveFocus()

        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
            fillMode: Image.PreserveAspectCrop
        }

        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#99000000"
                }

                GradientStop {
                    position: 0.5
                    color: "#33000000"
                }

                GradientStop {
                    position: 1
                    color: "#cc000000"
                }

            }

        }

        // top-left HUD
        Column {
            x: 64
            y: 56
            spacing: 4

            Row {
                spacing: 10

                Rectangle {
                    width: 12
                    height: 12
                    color: root.red
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "STAGE // READY"
                    color: root.white
                    font.family: "Arial Black"
                    font.italic: true
                    font.pixelSize: 14
                    font.letterSpacing: 4
                }

            }

            Text {
                id: bigC

                color: root.white
                font.family: "Arial Black"
                font.italic: true
                font.pixelSize: 132
                text: Qt.formatDateTime(new Date(), "HH:mm")
            }

            Text {
                id: smC

                color: root.red
                font.family: "Monospace"
                font.pixelSize: 18
                font.letterSpacing: 2
                text: Qt.formatDateTime(new Date(), "ss.zzz").substring(0, 5) + "  |  " + Qt.formatDateTime(new Date(), "ddd dd MMM").toUpperCase()
            }

            Timer {
                interval: 50
                running: true
                repeat: true
                onTriggered: {
                    bigC.text = Qt.formatDateTime(new Date(), "HH:mm");
                    smC.text = Qt.formatDateTime(new Date(), "ss.zzz").substring(0, 5) + "  |  " + Qt.formatDateTime(new Date(), "ddd dd MMM").toUpperCase();
                }
            }

        }

        // bottom-right pill login
        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.margins: 56
            width: 560
            height: 96
            radius: 48
            color: "#ee0a0a0a"
            border.color: root.red
            border.width: 2

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                TextField {
                    id: u

                    placeholderTextColor: color
                    objectName: "usernameField"
                    Accessible.name: qsTr("Username")
                    enabled: !auth.busy
                    width: 150
                    height: parent.height
                    text: userModel.lastUser || compact.defaultUsername
                    placeholderText: "DRIVER"
                    color: root.white
                    font.family: "sans-serif"
                    font.italic: true
                    font.pixelSize: 16

                    Common.FieldFocus {
                    }

                    background: Rectangle {
                        color: "transparent"
                    }

                }

                Rectangle {
                    width: 1
                    height: parent.height - 16
                    color: root.dim
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: p

                    placeholderTextColor: color
                    objectName: "passwordField"
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 220
                    height: parent.height
                    placeholderText: "PASSCODE"
                    focus: true
                    echoMode: TextInput.Password
                    color: root.white
                    font.family: "sans-serif"
                    font.italic: true
                    font.pixelSize: 16
                    onAccepted: auth.login(u.text, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                    }

                    background: Rectangle {
                        color: "transparent"
                    }

                }

                Rectangle {
                    width: 96
                    height: parent.height
                    radius: 48
                    color: root.red

                    Text {
                        anchors.centerIn: parent
                        text: "GO"
                        color: root.white
                        font.family: "Arial Black"
                        font.italic: true
                        font.pixelSize: 24
                        font.letterSpacing: 3
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: auth.login(u.text, p.text, auth.sessionIndex)
                    }

                }

            }

        }

        Common.AuthController {
            id: auth

            passwordField: viewport.compactMode ? compact.passwordField : p
        }

    }

    Common.CompactGreeter {
        id: compact

        anchors.fill: parent
        visible: viewport.compactMode
        controller: auth
        accent: root.themeAccent
        title: "DRAG RACER"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
    }

    Common.SystemBar {
        id: systemBar

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        controller: auth
    }

    Common.LoginStatus {
        anchors.top: parent.top
        anchors.topMargin: viewport.compactMode ? 12 : Math.max(192, 192 * viewport.layoutScale)
        anchors.horizontalCenter: parent.horizontalCenter
        controller: auth
    }

}
