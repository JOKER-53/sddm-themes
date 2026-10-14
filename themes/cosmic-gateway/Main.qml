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
        // Elegant, understated power controls

        id: root

        property color themeAccent: config.brand || config.accent || "#9c27b0"

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

        // Minimalist, premium login panel
        Rectangle {
            id: loginPanel

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 120
            width: 380
            height: 420
            color: "#99000000" // Deep translucent black
            radius: 16
            border.color: "#33ffffff"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 35

                // Elegant Title
                Text {
                    text: "GATEWAY"
                    font.family: customFont.name
                    font.pixelSize: 28
                    font.letterSpacing: 8
                    color: "#ffffff"
                    opacity: 0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // User Selection
                ComboBox {
                    id: u

                    objectName: "usernameField"
                    Accessible.name: qsTr("Username")
                    enabled: !auth.busy
                    width: 280
                    height: 40
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                    // Minimalist bottom-border style
                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: u.activeFocus ? "#fff" : "#44ffffff"
                        }

                    }

                    contentItem: Text {
                        text: u.currentText
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        font.letterSpacing: 2
                        color: "#ffffff"
                        opacity: 0.9
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40

                        background: Rectangle {
                            color: optionDelegate0.hovered ? "#1affffff" : "transparent"
                        }

                        contentItem: Text {
                            text: model.name
                            color: "#ffffff"
                            opacity: optionDelegate0.hovered ? 1 : 0.6
                            font.family: "sans-serif"
                            font.pixelSize: 20
                            font.letterSpacing: 2
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                    }

                }

                // Password Input
                TextField {
                    id: p

                    objectName: "passwordField"
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 280
                    height: 40
                    placeholderText: "PASSWORD"
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 18
                    font.letterSpacing: 0
                    color: "#ffffff"
                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: auth.login(u.currentText, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                    }

                    // Minimalist bottom-border style
                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: p.activeFocus ? "#fff" : "#44ffffff"
                        }

                    }

                }

                // Clean Submit Button
                Rectangle {
                    width: 160
                    height: 44
                    color: "transparent"
                    radius: 22
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "CONNECT"
                        color: parent.color == "#ffffff" ? "#000" : "#fff"
                        font.family: customFont.name
                        font.pixelSize: 14
                        font.letterSpacing: 4
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = "#ffffff"
                        onExited: parent.color = "transparent"
                        onClicked: auth.login(u.currentText, p.text, auth.sessionIndex)
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }

                    }

                }

            }

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
        title: "COSMIC GATEWAY"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
        fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
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
