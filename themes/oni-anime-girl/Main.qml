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

        property color themeAccent: config.brand || config.accent || "#ff00ff"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"

        FontLoader {
            id: customFont

            source: "assets/font.ttf"
        }

        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
            fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 100
            anchors.verticalCenter: parent.verticalCenter
            width: 350
            height: 450
            color: "#99000000"
            border.color: root.themeAccent
            border.width: 1
            radius: 15

            Column {
                anchors.centerIn: parent
                spacing: 25

                Text {
                    text: "ONI // SYSTEM"
                    color: root.themeAccent
                    font.family: customFont.name
                    font.pixelSize: 24
                    font.bold: true
                    font.letterSpacing: 4
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 280
                    height: 45

                    background: Rectangle {
                        color: "transparent"
                        border.color: root.themeAccent
                        border.width: 1
                    }

                    foreground: root.themeAccent
                    font.family: "sans-serif"
                    font.pixelSize: 20
                }

                TextField {
                    id: p

                    placeholderTextColor: color
                    objectName: "passwordField"
                    onTextEdited: auth.dismissError()
                    Accessible.description: auth.rejected ? auth.errorMessage : ""
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 280
                    height: 45
                    placeholderText: "PASSCODE"
                    focus: true
                    echoMode: TextInput.Password
                    color: "#fff"
                    font.family: "sans-serif"
                    font.pixelSize: 16
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "transparent"
                        border.color: root.themeAccent
                        border.width: 1
                    }
                }

                Rectangle {
                    width: 280
                    height: 45
                    color: root.themeAccent

                    Text {
                        anchors.centerIn: parent
                        text: "CONNECT"
                        color: "#000"
                        font.bold: true
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                    }
                }
            }
        }

        // Injected Top-Center Clock
        Column {
            id: clockGroup
            objectName: "themeClock"

            anchors.left: parent.left
            anchors.leftMargin: 60
            anchors.top: parent.top
            anchors.topMargin: 40
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
        title: "ONI GIRL"
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
        surface: "#ed1d0526"
        foreground: "#ffe0ff"
        cornerRadius: 12
        controlRadius: 8
        fontFamily: "sans-serif"
        treatment: "line"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "ONI GIRL"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 15
        controller: auth
    }
}
