import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
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
        // Power Controls (Top Right, Sleek)

        id: root

        property color themeAccent: config.brand || config.accent || "#ffb020"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
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
            anchors.bottomMargin: 112 / viewport.layoutScale
            width: 750
            height: 280

            // Parallelogram background effect
            Rectangle {
                anchors.fill: parent
                anchors.margins: 0
                color: "#ee0c0c0c" // Very dark, almost solid
                border.color: "#33ffffff"
                border.width: 1

                // Inner accent line
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 3
                    color: "#ff3b00"
                }

                transform: Rotation {
                    angle: 0
                    origin.x: 750
                    origin.y: 350
                }
            }

            // Login Content (Rotated slightly to match)
            Column {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 80
                anchors.bottomMargin: 80
                spacing: 25

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

                    Common.UsernamePicker {
                        id: u

                        objectName: "usernameField"
                        controller: auth
                        Accessible.name: qsTr("Username")
                        width: 220
                        height: 50

                        background: Rectangle {
                            color: "#1a1a1a"
                            border.color: u.activeFocus ? "#ff3b00" : "#444444"
                            border.width: 2
                        }

                        foreground: "#ffffff"
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        font.letterSpacing: 2

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
                                font.family: "sans-serif"
                                font.pixelSize: 20
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                            }
                        }
                    }

                    TextField {
                        id: p

                        objectName: "passwordField"
                        onTextEdited: auth.dismissError()
                        Accessible.description: auth.rejected ? auth.errorMessage : ""
                        enabled: !auth.busy
                        Accessible.name: qsTr("Password")
                        width: 260
                        height: 50
                        placeholderText: "ACCESS CODE"
                        placeholderTextColor: color
                        focus: true
                        echoMode: TextInput.Password
                        font.family: "sans-serif"
                        font.pixelSize: 18
                        color: "#ffffff"
                        font.letterSpacing: 0
                        anchors.leftMargin: 20
                        padding: 20
                        onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                        Common.FieldFocus {
                            controller: auth
                        }

                        background: Rectangle {
                            color: "#1a1a1a"
                            border.color: p.activeFocus ? "#ff3b00" : "#444444"
                            border.width: 2
                        }
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
                            enabled: !auth.busy
                            Accessible.name: qsTr("Sign in")
                            objectName: "loginButton"
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: {
                                parent.color = "#ffffff";
                            }
                            onExited: {
                                parent.color = "#ff3b00";
                            }
                            onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }
                }

                transform: Rotation {
                    angle: 0
                    origin.x: 400
                    origin.y: 200
                }
            }
        }

        // Injected Top-Center Clock
        Column {
            id: clockGroup
            objectName: "themeClock"

            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2
            z: 10

            Text {
                id: injectedClockTime

                text: Qt.formatTime(new Date(), "hh:mm")
                font.family: customFont.name
                font.pixelSize: 72
                color: "#ffffff"
                style: Text.Outline
                styleColor: "#66000000"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: injectedClockDate

                text: Qt.formatDate(new Date(), "dddd, MMMM d")
                font.family: "sans-serif"
                font.pixelSize: 20
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

        Rectangle {
            x: clockGroup.x - 24
            y: clockGroup.y - 12
            width: clockGroup.width + 48
            height: clockGroup.height + 24
            radius: 12
            color: "#b3000000"
            z: 9
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
        title: "NISSAN DRIFT"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
        fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
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
        surface: "#ed11100c"
        foreground: "#ffe2ad"
        cornerRadius: 0
        controlRadius: 0
        fontFamily: "Monospace"
        treatment: "panel"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "NISSAN DRIFT"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 0
        controller: auth
    }
}
