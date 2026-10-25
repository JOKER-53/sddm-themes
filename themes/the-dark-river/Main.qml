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
        // Power Controls (Top Right, minimalist)

        id: root

        property color themeAccent: config.brand || config.accent || "#c5a059"

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

        // Cinematic bottom vignette/gradient
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 600

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "transparent"
                }

                GradientStop {
                    position: 0.6
                    color: "#aa000000"
                }

                GradientStop {
                    position: 1
                    color: "#ee000000"
                }
            }
        }

        // Main UI Container (Bottom Center)
        Item {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.horizontalCenter: parent.horizontalCenter
            width: 600
            height: 250

            Column {
                anchors.centerIn: parent
                spacing: 30

                // Cinematic Title
                Text {
                    text: "THE DARK RIVER"
                    font.family: customFont.name
                    font.pixelSize: 54
                    color: root.themeAccent // Elegant gold
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline
                    styleColor: "#55000000"

                    // Subtle glowing pulse
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 0.8
                            to: 1
                            duration: 3000
                            easing.type: Easing.InOutSine
                        }

                        NumberAnimation {
                            from: 1
                            to: 0.8
                            duration: 3000
                            easing.type: Easing.InOutSine
                        }
                    }
                }

                // Inputs Row
                Row {
                    spacing: 20
                    anchors.horizontalCenter: parent.horizontalCenter

                    Common.UsernamePicker {
                        id: u

                        objectName: "usernameField"
                        controller: auth
                        Accessible.name: qsTr("Username")
                        width: 220
                        height: 46

                        background: Rectangle {
                            color: "#22000000"
                            border.color: u.activeFocus ? "#f0d498" : root.themeAccent
                            border.width: 1
                        }

                        font.family: "sans-serif"
                        font.pixelSize: 20
                        foreground: root.themeAccent

                        delegate: ItemDelegate {
                            id: optionDelegate0

                            width: u.width
                            height: 40

                            background: Rectangle {
                                color: optionDelegate0.hovered ? "#33c5a059" : "#111"
                            }

                            contentItem: Text {
                                text: model.name
                                color: root.themeAccent
                                font.family: "sans-serif"
                                font.pixelSize: 20
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
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
                        height: 46
                        placeholderText: "ENTER SECRET"
                        placeholderTextColor: color
                        focus: true
                        echoMode: TextInput.Password
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        color: "#ffffff"
                        font.letterSpacing: 0
                        horizontalAlignment: TextInput.AlignHCenter
                        onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                        Common.FieldFocus {
                            controller: auth
                        }

                        background: Rectangle {
                            color: "#22000000"
                            border.color: p.activeFocus ? "#f0d498" : root.themeAccent
                            border.width: 1
                        }
                    }

                    // Login Button
                    Rectangle {
                        width: 60
                        height: 46
                        color: "transparent"
                        border.color: root.themeAccent
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            color: root.themeAccent
                            font.pixelSize: 18
                        }

                        Common.ActionArea {
                            enabled: !auth.busy
                            Accessible.name: qsTr("Sign in")
                            objectName: "loginButton"
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: {
                                parent.color = root.themeAccent;
                                parent.children[0].color = "#000";
                            }
                            onExited: {
                                parent.color = "transparent";
                                parent.children[0].color = root.themeAccent;
                            }
                            onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 250
                            }
                        }
                    }
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
        title: "THE DARK RIVER"
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
        surface: "#ed151109"
        foreground: "#eadab9"
        cornerRadius: 2
        controlRadius: 0
        fontFamily: "serif"
        treatment: "panel"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "THE DARK RIVER"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 0
        controller: auth
    }
}
