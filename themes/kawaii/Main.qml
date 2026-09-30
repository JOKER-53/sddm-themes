// Kawaii — soft pastel card with hearts.
// Structure: subject anchored right, big rounded pink-tinted card on the
// left with rounded inputs. Floating hearts animate. Cursive friendly type.
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

        property color themeAccent: config.brand || config.accent || "#ffb3d1"
        property color pink: root.themeAccent
        property color purple: "#c8a2ff"
        property color soft: "#fff0f6"
        property color cardBg: "#cc1a0f1f"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#0d0710"
        Component.onCompleted: p.forceActiveFocus()

        Common.Wallpaper {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
            fillMode: Image.PreserveAspectFit
            height: parent.height
        }

        // floating hearts
        Repeater {
            model: 12

            delegate: Text {
                text: "♡"
                color: root.pink
                opacity: 0.4
                font.pixelSize: 18 + (index % 4) * 8
                x: 80 + (index * 53) % 600
                y: 100 + (index * 91) % 900

                SequentialAnimation on y {
                    loops: Animation.Infinite

                    NumberAnimation {
                        to: 100 + (index * 91) % 900 - 30
                        duration: 2000 + index * 200
                        easing.type: Easing.InOutSine
                    }

                    NumberAnimation {
                        to: 100 + (index * 91) % 900
                        duration: 2000 + index * 200
                        easing.type: Easing.InOutSine
                    }

                }

            }

        }

        // rounded card
        Rectangle {
            x: 140
            anchors.verticalCenter: parent.verticalCenter
            width: 460
            height: 540
            radius: 36
            color: root.cardBg
            border.color: root.pink
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 36
                spacing: 18

                Text {
                    text: "welcome back  ♡"
                    color: root.pink
                    font.family: "Comic Sans MS"
                    font.pixelSize: 28
                }

                Text {
                    id: kc

                    color: root.soft
                    font.family: "Comic Sans MS"
                    font.pixelSize: 56
                    text: Qt.formatDateTime(new Date(), "HH:mm")
                }

                Text {
                    color: root.purple
                    font.family: "Comic Sans MS"
                    font.pixelSize: 14
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: kc.text = Qt.formatDateTime(new Date(), "HH:mm")
                }

                Item {
                    width: 1
                    height: 8
                }

                Rectangle {
                    width: parent.width - 0
                    height: 50
                    radius: 25
                    color: "#2a1530"
                    border.color: root.purple
                    border.width: 1

                    TextField {
                        id: u

                        placeholderTextColor: color
                        objectName: "usernameField"
                        Accessible.name: qsTr("Username")
                        enabled: !auth.busy
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        text: userModel.lastUser || compact.defaultUsername
                        placeholderText: "username ✿"
                        color: root.soft
                        font.family: "sans-serif"
                        font.pixelSize: 16

                        Common.FieldFocus {
                        }

                        background: Rectangle {
                            color: "transparent"
                        }

                    }

                }

                Rectangle {
                    width: parent.width
                    height: 50
                    radius: 25
                    color: "#2a1530"
                    border.color: root.pink
                    border.width: 1

                    TextField {
                        id: p

                        placeholderTextColor: color
                        objectName: "passwordField"
                        enabled: !auth.busy
                        Accessible.name: qsTr("Password")
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        placeholderText: "password ♡"
                        focus: true
                        echoMode: TextInput.Password
                        color: root.soft
                        font.family: "sans-serif"
                        font.pixelSize: 16
                        onAccepted: auth.login(u.text, p.text, auth.sessionIndex)

                        Common.FieldFocus {
                        }

                        background: Rectangle {
                            color: "transparent"
                        }

                    }

                }

                Rectangle {
                    width: parent.width
                    height: 52
                    radius: 26
                    color: root.pink

                    Text {
                        anchors.centerIn: parent
                        text: "let me in ♡"
                        color: "#3a1030"
                        font.family: "Comic Sans MS"
                        font.pixelSize: 18
                        font.bold: true
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
        title: "KAWAII"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
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
