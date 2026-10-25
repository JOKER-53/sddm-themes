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
        // Power Controls (Top Left, Hacker Style)

        id: root

        property color themeAccent: config.brand || config.accent || "#00ffff"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"

        // Background with reduced FPS for a glitchy/stop-motion Spiderverse feel
        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
            fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
            fillMode: Image.PreserveAspectCrop
            speed: 0.5 // Reduced FPS as requested
            cache: false
        }

        FontLoader {
            id: customFont

            source: "assets/font.ttf"
        }

        // --- SPIDER WEBS SUSPENDING THE CARD ---
        // Web 1: Top right ceiling to top right of card
        Rectangle {
            x: 1500
            y: -50
            width: 400
            height: 2
            color: "#ffffff"
            opacity: 0.6
            transformOrigin: Item.TopLeft
            rotation: 70

            // subtle shadow/glow
            Rectangle {
                anchors.fill: parent
                color: root.themeAccent
                opacity: 0.5
                anchors.margins: -1
                z: -1
            }
        }

        // Web 2: Right wall to bottom right of card
        Rectangle {
            x: 1920
            y: 600
            width: 300
            height: 1
            color: "#ffffff"
            opacity: 0.4
            transformOrigin: Item.TopLeft
            rotation: 165
        }

        // Web 3: Ceiling to top left of card
        Rectangle {
            x: 1200
            y: -10
            width: 500
            height: 1
            color: "#ffffff"
            opacity: 0.5
            transformOrigin: Item.TopLeft
            rotation: 55

            Rectangle {
                anchors.fill: parent
                color: "#ff00ff"
                opacity: 0.5
                anchors.margins: -1
                z: -1
            }
        }

        // Web 4: Bottom edge to bottom left of card
        Rectangle {
            x: 1300
            y: 1090
            width: 400
            height: 2
            color: "#ffffff"
            opacity: 0.3
            transformOrigin: Item.TopLeft
            rotation: -60
        }

        // --- SUSPENDED GLITCH CARD ---
        Rectangle {
            id: loginCard

            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.verticalCenter: parent.verticalCenter
            width: 380
            height: 480
            color: "#111111"
            radius: 10
            border.color: "#222222"
            border.width: 2

            // Glitch shadow effect (Cyan and Magenta)
            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                anchors.horizontalCenterOffset: -4
                anchors.verticalCenterOffset: 2
                color: "transparent"
                border.color: root.themeAccent
                border.width: 2
                radius: 12
                z: -1
                opacity: 0.7
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                anchors.horizontalCenterOffset: 4
                anchors.verticalCenterOffset: -2
                color: "transparent"
                border.color: "#ff00ff"
                border.width: 2
                radius: 12
                z: -2
                opacity: 0.7
            }

            Column {
                anchors.centerIn: parent
                spacing: 25

                // SPIDER LOGO
                Text {
                    text: "🕷"
                    font.pixelSize: 64
                    color: "#ff0044"
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Subtle heartbeat animation
                    SequentialAnimation on scale {
                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 1
                            to: 1.1
                            duration: 400
                            easing.type: Easing.OutQuad
                        }

                        NumberAnimation {
                            from: 1.1
                            to: 1
                            duration: 400
                            easing.type: Easing.InQuad
                        }

                        PauseAnimation {
                            duration: 1000
                        }
                    }
                }

                Text {
                    text: "SYSTEM_ACCESS"
                    font.family: customFont.name
                    font.pixelSize: 28
                    color: "#ffffff"
                    font.letterSpacing: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 300
                    height: 50

                    background: Rectangle {
                        color: "#000000"
                        border.color: u.activeFocus ? root.themeAccent : "#333333"
                        border.width: 2
                    }

                    font.family: "sans-serif"
                    font.pixelSize: 20
                    foreground: root.themeAccent

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40

                        background: Rectangle {
                            color: optionDelegate0.hovered ? root.themeAccent : "#000000"
                        }

                        contentItem: Text {
                            text: model.name
                            color: optionDelegate0.hovered ? "#000000" : root.themeAccent
                            font.family: "sans-serif"
                            font.pixelSize: 20
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
                    width: 300
                    height: 50
                    placeholderText: "PASSWORD"
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 20
                    color: "#ff00ff"
                    font.letterSpacing: 0
                    anchors.leftMargin: 15
                    padding: 15
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "#000000"
                        border.color: p.activeFocus ? "#ff00ff" : "#333333"
                        border.width: 2
                    }
                }

                Rectangle {
                    width: 300
                    height: 50
                    color: "#ff0044"

                    Text {
                        anchors.centerIn: parent
                        text: "CONNECT"
                        color: "#ffffff"
                        font.family: customFont.name
                        font.pixelSize: 20
                        font.bold: true
                        font.letterSpacing: 4
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
                            parent.children[0].color = "#ff0044";
                        }
                        onExited: {
                            parent.color = "#ff0044";
                            parent.children[0].color = "#ffffff";
                        }
                        onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
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
        title: "SPIDER-VERSE"
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
        surface: "#ee100a24"
        foreground: "#e0ffff"
        cornerRadius: 0
        controlRadius: 0
        fontFamily: "sans-serif"
        treatment: "panel"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "SPIDER-VERSE"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 10
        controller: auth
    }
}
