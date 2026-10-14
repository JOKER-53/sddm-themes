// Gojo — monochrome manga split.
// Structure: left half = artwork bleed, right half = pure black with a thin
// white-stroke login. Manga vertical title "INFINITY" runs down the divider.
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

        property color themeAccent: config.brand || config.accent || "#ffffff"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"
        Component.onCompleted: p.forceActiveFocus()

        Common.Wallpaper {
            width: parent.width * 0.6
            height: parent.height
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
            fillMode: Image.PreserveAspectCrop
        }
        // hard divider

        Rectangle {
            x: parent.width * 0.6
            width: 2
            height: parent.height
            color: "#fff"
        }

        // vertical kanji-feel label
        Column {
            x: parent.width * 0.6 + 18
            y: 60
            spacing: 14

            Repeater {
                model: ["I", "N", "F", "I", "N", "I", "T", "Y"]

                delegate: Text {
                    text: modelData
                    color: "#fff"
                    font.family: "Times New Roman"
                    font.pixelSize: 22
                    font.letterSpacing: 4
                }

            }

        }

        // right-side login
        Column {
            anchors.right: parent.right
            anchors.rightMargin: 120
            anchors.verticalCenter: parent.verticalCenter
            spacing: 28
            width: 360

            Text {
                id: cl

                color: "#fff"
                font.family: "Times New Roman"
                font.pixelSize: 88
                font.weight: Font.Light
                text: Qt.formatDateTime(new Date(), "HH:mm")
            }

            Text {
                color: "#bdbdbd"
                font.family: "Times New Roman"
                font.italic: true
                font.pixelSize: 16
                text: "the honored one — " + Qt.formatDateTime(new Date(), "dddd").toLowerCase()
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: cl.text = Qt.formatDateTime(new Date(), "HH:mm")
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#fff"
                opacity: 0.6
            }

            TextField {
                id: u

                placeholderTextColor: color
                objectName: "usernameField"
                Accessible.name: qsTr("Username")
                enabled: !auth.busy
                width: parent.width
                text: userModel.lastUser || compact.defaultUsername
                placeholderText: "name"
                color: "#fff"
                font.family: "sans-serif"
                font.pixelSize: 20

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "transparent"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#fff"
                    }

                }

            }

            TextField {
                id: p

                placeholderTextColor: color
                objectName: "passwordField"
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: parent.width
                placeholderText: "password"
                focus: true
                echoMode: TextInput.Password
                color: "#fff"
                font.family: "sans-serif"
                font.pixelSize: 20
                onAccepted: auth.login(u.text, p.text, auth.sessionIndex)

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "transparent"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#fff"
                    }

                }

            }

            Text {
                text: "↵  unseal"
                color: "#fff"
                font.family: "Times New Roman"
                font.italic: true
                font.pixelSize: 16

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
        title: "GOJO"
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
