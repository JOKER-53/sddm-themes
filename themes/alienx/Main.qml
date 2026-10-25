// Alien X — Omnitrix sci-fi terminal.
// Structure: subject keeps its black bg on the right; left half is a
// vertical green-on-black command console. Hex-bordered inputs, scanlines.
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
        id: root

        property color themeAccent: config.brand || config.accent || "#8aff5a"
        property color glow: root.themeAccent
        property color text: "#d6ffd0"
        property color dim: "#98c68c"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"
        Component.onCompleted: {
            if (alienPassword)
                alienPassword.forceActiveFocus();
        }

        // subject on the right
        Common.Wallpaper {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
            fillMode: Image.PreserveAspectFit
            height: parent.height * 0.9
        }

        // scanline overlay
        Repeater {
            model: 360

            delegate: Rectangle {
                y: index * 3
                width: root.width
                height: 1
                color: root.glow
                opacity: 0.04
            }
        }

        // left console
        Column {
            x: 120
            anchors.verticalCenter: parent.verticalCenter
            spacing: 24
            width: 480

            Text {
                text: "OMNITRIX :: AUTH"
                color: root.glow
                font.family: "Monospace"
                font.pixelSize: 14
                font.letterSpacing: 8
            }

            Text {
                text: "[ DNA SAMPLE REQUIRED ]"
                color: root.dim
                font.family: "Monospace"
                font.pixelSize: 12
                font.letterSpacing: 4
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.glow
                opacity: 0.4
            }

            Text {
                id: bigClock
                objectName: "themeClock"

                color: root.glow
                font.family: "Monospace"
                font.pixelSize: 92
                font.bold: true
                text: Qt.formatDateTime(new Date(), "HH:mm")
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: bigClock.text = Qt.formatDateTime(new Date(), "HH:mm")
            }

            Common.UsernamePicker {
                id: alienUser
                objectName: "usernameField"
                controller: auth
                width: parent.width
                height: 52
                foreground: root.text
                font.pixelSize: 16
                background: Rectangle {
                    color: "#001100"
                    border.color: alienUser.activeFocus ? root.text : root.glow
                    border.width: alienUser.activeFocus ? 2 : 1
                }
            }

            TextField {
                id: alienPassword
                objectName: "passwordField"
                width: parent.width
                height: 52
                enabled: !auth.busy
                placeholderText: qsTr("Passphrase")
                placeholderTextColor: root.text
                color: root.text
                font.pixelSize: 16
                echoMode: TextInput.Password
                Accessible.name: qsTr("Password")
                Accessible.description: auth.rejected ? auth.errorMessage : ""
                onTextEdited: auth.dismissError()
                onAccepted: auth.login(auth.username, text, auth.sessionIndex)
                Common.FieldFocus {
                    controller: auth
                }
                background: Rectangle {
                    color: "#001100"
                    border.color: root.glow
                }
            }

            Rectangle {
                width: parent.width
                height: 48
                color: root.glow

                Text {
                    anchors.centerIn: parent
                    text: "▶ TRANSFORM"
                    color: "#000"
                    font.family: "Monospace"
                    font.bold: true
                    font.letterSpacing: 6
                }

                Common.ActionArea {
                    Accessible.name: qsTr("Sign in")
                    objectName: "loginButton"
                    enabled: !auth.busy
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: auth.login(auth.username, alienPassword.text, auth.sessionIndex)
                }
            }
        }

        Common.AuthController {
            id: auth

            passwordField: viewport.compactMode ? compact.passwordField : alienPassword
        }
    }

    Common.CompactGreeter {
        id: compact

        anchors.fill: parent
        visible: viewport.compactMode
        controller: auth
        accent: root.themeAccent
        title: "ALIEN X"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
    }

    Common.SystemBar {
        id: systemBar
        anchors.left: viewport.compactMode ? undefined : parent.left
        anchors.leftMargin: viewport.compactMode ? 0 : 40
        anchors.horizontalCenter: viewport.compactMode ? parent.horizontalCenter : undefined
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        controller: auth
        accent: root.themeAccent
        surface: "#ed001100"
        foreground: "#d6ffd0"
        cornerRadius: 0
        controlRadius: 0
        fontFamily: "Monospace"
        treatment: "line"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "ALIEN X"
        fontFamily: viewport.compactMode || !alienPassword ? "sans-serif" : alienPassword.font.family
        surface: viewport.compactMode || !alienPassword.background || alienPassword.background.color.a < 0.5 ? "#ed171717" : alienPassword.background.color
        foreground: viewport.compactMode || !alienPassword.background || alienPassword.background.color.a < 0.5 ? "#ffffff" : alienPassword.color
        cornerRadius: viewport.compactMode ? 10 : 0
        controller: auth
    }
}
