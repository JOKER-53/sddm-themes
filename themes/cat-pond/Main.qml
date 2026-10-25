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
        // Drop shadow for the lily pad
        // Power Buttons (Floating Bubbles)

        id: root

        property color themeAccent: config.brand || config.accent || "#4caf50"

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
            fillMode: Image.PreserveAspectFit
        }

        FontLoader {
            id: customFont

            source: "assets/font.ttf"
        }

        // Fake Drop shadow
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 55
            width: 380
            height: 380
            color: "#33000000"
            radius: 190
        }

        // Main Login Card (Lily Pad inspired)
        Rectangle {
            id: loginCard

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.right: parent.right
            anchors.margins: 60
            width: 380
            height: 380
            color: "#992e7d32"
            radius: 190
            border.color: "#a8e6cf"
            border.width: 4

            // Inner subtle glow
            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                radius: 186
                color: "transparent"
                border.color: "#33ffffff"
                border.width: 2
            }

            Column {
                anchors.centerIn: parent
                spacing: 18

                Text {
                    text: "CAT POND"
                    font.family: customFont.name
                    font.pixelSize: 48
                    color: "#fff"
                    font.bold: true
                    style: Text.Outline
                    styleColor: "#1b5e20"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "~ just keep floating ~"
                    font.family: customFont.name
                    font.pixelSize: 18
                    color: "#dcedc1"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 260
                    height: 48

                    background: Rectangle {
                        color: "#e8f5e9"
                        border.color: "#81c784"
                        border.width: 3
                        radius: 24
                    }

                    font.family: "sans-serif"
                    font.pixelSize: 20
                    foreground: "#2e7d32"

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40

                        background: Rectangle {
                            color: optionDelegate0.hovered ? "#c8e6c9" : "#e8f5e9"
                            radius: 20
                        }

                        contentItem: Text {
                            text: model.name
                            color: "#2e7d32"
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
                    height: 48
                    placeholderText: "password..."
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 24
                    color: "#1b5e20"
                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "#e8f5e9"
                        border.color: "#81c784"
                        border.width: 3
                        radius: 24
                    }
                }

                Rectangle {
                    width: 140
                    height: 46
                    color: root.themeAccent
                    radius: 23
                    border.color: "#a8e6cf"
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "DIVE IN"
                        color: "#fff"
                        font.family: customFont.name
                        font.pixelSize: 18
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = "#66bb6a"
                        onExited: parent.color = root.themeAccent
                        onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
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
        title: "CAT POND"
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
        surface: "#f0e8f5e9"
        foreground: "#2e6533"
        cornerRadius: 24
        controlRadius: 20
        fontFamily: "sans-serif"
        treatment: "pill"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "CAT POND"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 20
        controller: auth
    }
}
