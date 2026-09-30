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
        // Power row bottom-left

        id: root

        property color themeAccent: config.brand || config.accent || "#d62828"
        property color brand: root.themeAccent
        property color ink: "#f5e9e9"
        property color sub: "#e3c8c8"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#0a0203"
        Component.onCompleted: passField.forceActiveFocus()

        // Hero portrait — full screen now!
        Common.Wallpaper {
            id: hero

            source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            smooth: true
        }

        // Dark gradient overlay to make text readable against the full-screen image
        Rectangle {
            // Transparent on the right to show Deadpool

            anchors.fill: parent
            opacity: 0.8

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    position: 0
                    color: "#e60a0203"
                }

                // Darkest on the left where text is
                GradientStop {
                    position: 0.5
                    color: "#800a0203"
                }

                GradientStop {
                    position: 1
                    color: "transparent"
                }

            }

        }

        // Chat column on the LEFT
        ColumnLayout {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 80
            width: 520
            spacing: 14

            Text {
                text: "★ DEADPOOL OS"
                color: root.brand
                font.family: "Impact"
                font.pixelSize: 14
                font.letterSpacing: 4
            }

            Text {
                text: "Oh hey, you're back."
                color: root.ink
                font.pixelSize: 42
                font.bold: true
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "I was just monologuing to a coat rack.\nPassword. You know the drill, chimichanga."
                color: root.sub
                font.pixelSize: 16
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            // Chat bubble — username
            Rectangle {
                Layout.preferredWidth: 320
                Layout.preferredHeight: 44
                radius: 22
                color: "#1a1a1a"
                border.color: root.sub
                border.width: 1

                TextField {
                    id: userField

                    placeholderTextColor: color
                    placeholderText: qsTr("Username")
                    objectName: "usernameField"
                    Accessible.name: qsTr("Username")
                    enabled: !auth.busy
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    text: userModel.lastUser || compact.defaultUsername
                    color: root.ink
                    font.pixelSize: 15

                    Common.FieldFocus {
                    }

                    background: Rectangle {
                        color: "transparent"
                    }

                }

            }

            // Chat bubble — password (brand red) with glow
            Item {
                Layout.preferredWidth: 460
                Layout.preferredHeight: 52

                // Fake red glow layers
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width + 24
                    height: parent.height + 24
                    radius: 38
                    color: root.brand
                    opacity: 0.1
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width + 12
                    height: parent.height + 12
                    radius: 32
                    color: root.brand
                    opacity: 0.2
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width + 4
                    height: parent.height + 4
                    radius: 28
                    color: root.brand
                    opacity: 0.4
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: root.brand

                    TextField {
                        id: passField

                        objectName: "passwordField"
                        enabled: !auth.busy
                        Accessible.name: qsTr("Password")
                        anchors.fill: parent
                        anchors.leftMargin: 22
                        anchors.rightMargin: 70
                        placeholderText: qsTr("Password")
                        placeholderTextColor: color
                        focus: true
                        echoMode: TextInput.Password
                        color: "#ffffff"
                        font.pixelSize: 16
                        onAccepted: auth.login(userField.text, passField.text, auth.sessionIndex)

                        Common.FieldFocus {
                        }

                        background: Rectangle {
                            color: "transparent"
                        }

                    }

                    Common.LoginSubmit {
                        objectName: "loginButton"
                        width: 460
                        accent: root.themeAccent
                        enabled: !auth.busy
                        onClicked: auth.login(userField.text, passField.text, auth.sessionIndex)
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 22
                        anchors.verticalCenter: parent.verticalCenter
                        text: "↵"
                        color: "#fff"
                        font.pixelSize: 22
                    }

                }

            }

            Text {
                text: "🌮  ⚔️  🔫  ❤️‍🩹"
                font.pixelSize: 18
                opacity: 0.7
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
        title: "DEADPOOL"
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
