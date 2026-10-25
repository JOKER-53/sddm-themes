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
        // Power Controls (Top Right)

        id: root

        property color themeAccent: config.brand || config.accent || "#f44336"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#ffffff"

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

        // Pokeball UI Card
        Rectangle {
            id: loginCard

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.right: parent.right
            anchors.margins: 80
            width: 320
            height: 380
            radius: 40
            color: "#ffffff"
            border.color: "#222222"
            border.width: 6

            // Red Top Half
            Rectangle {
                width: parent.width - 12
                height: (parent.height / 2) - 6
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#E3350D"
                radius: 34

                // Square off the bottom corners of the red half
                Rectangle {
                    width: parent.width
                    height: 40
                    anchors.bottom: parent.bottom
                    color: "#E3350D"
                }
            }

            // Black Center Band
            Rectangle {
                width: parent.width
                height: 16
                anchors.centerIn: parent
                color: "#222222"
            }

            // Pokeball Center Button (Login)
            Rectangle {
                id: pokeButton

                width: 100
                height: 100
                radius: 50
                anchors.centerIn: parent
                color: "#ffffff"
                border.color: "#222222"
                border.width: 16

                // Inner clickable button
                Rectangle {
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    radius: 25
                    color: pokeMouse.pressed ? "#cccccc" : (pokeMouse.containsMouse ? "#eeeeee" : "#ffffff")
                    border.color: "#dddddd"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: "GO"
                        font.family: "sans-serif"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#222"
                        opacity: pokeMouse.containsMouse ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                }

                Common.ActionArea {
                    id: pokeMouse

                    Accessible.name: qsTr("Sign in")
                    objectName: "loginButton"
                    enabled: !auth.busy
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                }
            }

            // USERNAME INPUT (Top Red Half)
            Common.UsernamePicker {
                id: u

                objectName: "usernameField"
                controller: auth
                Accessible.name: qsTr("Username")
                width: 240
                height: 46
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50

                background: Rectangle {
                    color: "#ffffff"
                    radius: 23
                    border.color: u.activeFocus ? "#222222" : "transparent"
                    border.width: 3
                }

                font.family: "sans-serif"
                font.pixelSize: 20
                foreground: "#E3350D"
                font.bold: true

                delegate: ItemDelegate {
                    id: optionDelegate0

                    width: u.width
                    height: 40

                    background: Rectangle {
                        color: optionDelegate0.hovered ? "#ffdddd" : "#ffffff"
                    }

                    contentItem: Text {
                        text: model.name
                        color: "#E3350D"
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // PASSWORD INPUT (Bottom White Half)
            TextField {
                id: p

                objectName: "passwordField"
                onTextEdited: auth.dismissError()
                Accessible.description: auth.rejected ? auth.errorMessage : ""
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: 240
                height: 46
                placeholderText: "PASSWORD"
                placeholderTextColor: color
                focus: true
                echoMode: TextInput.Password
                font.family: "sans-serif"
                font.pixelSize: 18
                color: "#222222"
                horizontalAlignment: TextInput.AlignHCenter
                font.letterSpacing: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50
                onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                Common.FieldFocus {
                    controller: auth
                }

                background: Rectangle {
                    color: "#f5f5f5"
                    radius: 23
                    border.color: p.activeFocus ? "#E3350D" : "#dddddd"
                    border.width: 3
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
        title: "POKEBALL"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
        fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
    }

    Common.SystemBar {
        id: systemBar
        anchors.right: viewport.compactMode ? undefined : parent.right
        anchors.rightMargin: viewport.compactMode ? 0 : 40
        anchors.horizontalCenter: viewport.compactMode ? parent.horizontalCenter : undefined
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        controller: auth
        accent: root.themeAccent
        surface: "#f2ffffff"
        foreground: "#292929"
        cornerRadius: 24
        controlRadius: 20
        fontFamily: "sans-serif"
        treatment: "pill"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "POKEBALL"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 20
        controller: auth
    }
}
