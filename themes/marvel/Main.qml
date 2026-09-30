// Marvel Studios — bold cinematic title-card layout.
// Structure: tiny logo wallpaper top, massive red "ENTER" block center,
// password as a slim white underline. Power row anchored bottom-right.
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
        // ---- Power controls bottom-right ----

        id: root

        property color themeAccent: config.brand || config.accent || "#ed1d24"
        property color brand: root.themeAccent
        property color text: "#ffffff"
        property color sub: "#9a9a9a"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000000"
        Component.onCompleted: passField.forceActiveFocus()

        // ---- Logo strip (the wallpaper IS the logo, kept small & centered) ----
        Common.Wallpaper {
            id: logo

            source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.18
            width: 680
            height: 250
            smooth: true
        }

        // ---- Massive red title block ----
        Rectangle {
            id: titleBlock

            anchors.top: logo.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: 520
            height: 110
            color: root.brand

            Text {
                anchors.centerIn: parent
                text: "ENTER"
                color: root.text
                font.family: "Impact"
                font.pixelSize: 78
                font.letterSpacing: 8
            }

        }

        // ---- Username + password in a credits-style stack ----
        ColumnLayout {
            anchors.top: titleBlock.bottom
            anchors.topMargin: 28
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 18
            width: 460

            TextField {
                id: userField

                placeholderTextColor: color
                objectName: "usernameField"
                Accessible.name: qsTr("Username")
                enabled: !auth.busy
                Layout.fillWidth: true
                text: userModel.lastUser || compact.defaultUsername
                placeholderText: "USER"
                color: root.text
                font.family: "sans-serif"
                font.pixelSize: 22
                font.letterSpacing: 0

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "transparent"
                    border.color: root.sub
                    border.width: 0

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 2
                        color: root.sub
                    }

                }

            }

            TextField {
                id: passField

                placeholderTextColor: color
                objectName: "passwordField"
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                Layout.fillWidth: true
                placeholderText: "PASSWORD"
                focus: true
                echoMode: TextInput.Password
                color: root.text
                font.family: "sans-serif"
                font.pixelSize: 22
                font.letterSpacing: 0
                onAccepted: auth.login(userField.text, passField.text, auth.sessionIndex)

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "transparent"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 2
                        color: root.brand
                    }

                }

            }

            Common.LoginSubmit {
                objectName: "loginButton"
                Layout.fillWidth: true
                width: parent.width
                accent: root.themeAccent
                enabled: !auth.busy
                onClicked: auth.login(userField.text, passField.text, auth.sessionIndex)
            }

        }

        Timer {
            id: resetTimer

            interval: 400
            onTriggered: titleBlock.color = root.brand
        }

        // Injected Top-Center Clock
        Column {
            id: clockGroup

            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2
            z: 10

            Text {
                id: injectedClockTime

                text: Qt.formatTime(new Date(), "hh:mm")
                font.family: "sans-serif"
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

            passwordField: viewport.compactMode ? compact.passwordField : passField
        }

    }

    Common.CompactGreeter {
        id: compact

        anchors.fill: parent
        visible: viewport.compactMode
        controller: auth
        accent: root.themeAccent
        title: "MARVEL"
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
