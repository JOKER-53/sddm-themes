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
        id: root

        property color themeAccent: config.brand || config.accent || "#ff9d76"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"

        // Background
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

        // Title floating above the command bar
        Text {
            anchors.bottom: commandBar.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SUNSET DRIVE"
            font.family: customFont.name
            font.pixelSize: 64
            color: "#ff9d76" // Warm sunset peach
            style: Text.Outline
            styleColor: "#55000000"

            // Subtle floating animation
            SequentialAnimation on anchors.bottomMargin {
                loops: Animation.Infinite

                NumberAnimation {
                    from: 30
                    to: 35
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    from: 35
                    to: 30
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // UNIQUE HORIZONTAL COMMAND BAR (Floating Pill UI)
        Rectangle {
            id: commandBar

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.horizontalCenter: parent.horizontalCenter
            width: 510
            height: 60
            color: "#66110a08" // Deep warm dark translucent
            radius: 30
            border.color: "#44ff9d76"
            border.width: 1

            // Background glow
            Rectangle {
                anchors.fill: parent
                radius: 30
                color: "transparent"
                border.color: "#22ff9d76"
                border.width: 4
                z: -1
            }

            Row {
                // 4. Power Controls

                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 10
                spacing: 15

                // 1. User Selection
                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 140
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter

                    background: Rectangle {
                        color: "transparent"
                    }

                    font.family: "sans-serif"
                    font.pixelSize: 20
                    font.bold: true
                    foreground: "#ff9d76"

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 36

                        background: Rectangle {
                            color: optionDelegate0.hovered ? "#44ff9d76" : "#22110a08"
                        }

                        contentItem: Text {
                            text: model.name
                            color: "#ff9d76"
                            font.family: "sans-serif"
                            font.pixelSize: 20
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                // Separator
                Rectangle {
                    width: 1
                    height: 30
                    color: "#44ff9d76"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // 2. Password Input
                TextField {
                    id: p

                    objectName: "passwordField"
                    onTextEdited: auth.dismissError()
                    Accessible.description: auth.rejected ? auth.errorMessage : ""
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 220
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: "Enter password..."
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 16
                    color: "#ffffff"
                    font.letterSpacing: 0
                    verticalAlignment: TextInput.AlignVCenter
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "transparent"
                    }
                }

                // Login Button (Arrow)
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: "#ff9d76"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "→"
                        color: "#111"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = "#ffffff"
                        onExited: parent.color = "#ff9d76"
                        onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
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
        title: "MOUNTAIN SUNSET"
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
        surface: "#ed21130e"
        foreground: "#ffe4cf"
        cornerRadius: 24
        controlRadius: 20
        fontFamily: "sans-serif"
        treatment: "pill"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "MOUNTAIN SUNSET"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 20
        controller: auth
    }
}
