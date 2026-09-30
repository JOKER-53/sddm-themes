// Red Dead Redemption II — wanted-poster western frame.
// Structure: full-bleed key art, parchment "WANTED" card pinned bottom-center,
// small western clock top-right with double-rule border. Serif throughout.
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

        property color themeAccent: config.brand || config.accent || "#d4a574"
        property color sepia: root.themeAccent
        property color parch: "#e9d8b4"
        property color ink: "#2b1a0e"
        property color rust: "#7a2f1c"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#1a0e07"
        Component.onCompleted: p.forceActiveFocus()

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
            anchors.bottomMargin: 112 / viewport.layoutScale
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

                            placeholderTextColor: color
                            placeholderText: qsTr("Username")
                            objectName: "usernameField"
                            Accessible.name: qsTr("Username")
                            enabled: !auth.busy
                            anchors.fill: parent
                            anchors.margins: 4
                            text: userModel.lastUser || compact.defaultUsername
                            color: root.ink
                            font.family: "sans-serif"
                            font.pixelSize: 16

                            Common.FieldFocus {
                            }

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

                            objectName: "passwordField"
                            enabled: !auth.busy
                            Accessible.name: qsTr("Password")
                            anchors.fill: parent
                            anchors.margins: 4
                            focus: true
                            placeholderText: qsTr("Password")
                            placeholderTextColor: color
                            echoMode: TextInput.Password
                            color: root.ink
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
        title: "RDR2"
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
