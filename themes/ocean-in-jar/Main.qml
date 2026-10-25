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
        // Minimalist Deep Ocean Power Controls

        id: root

        property color themeAccent: config.brand || config.accent || "#03a9f4"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"

        // Pixel Art Ocean Jars Animation
        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
            fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
            fillMode: Image.PreserveAspectFit
            speed: 0.6 // Reduced FPS for a calmer, slower underwater animation
            cache: false
        }

        FontLoader {
            id: customFont

            source: "assets/font.ttf"
        }

        // Subtle deep-sea glow at the bottom
        Rectangle {
            // Subtle deep blue glow

            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "transparent"
                }

                GradientStop {
                    position: 0.7
                    color: "transparent"
                }

                GradientStop {
                    position: 1
                    color: "#440277bd"
                }
            }
        }

        // Aquarium Glass Login Panel (Bottom Center)
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.horizontalCenter: parent.horizontalCenter
            width: 380
            height: 260
            color: "#1a03a9f4" // Deep translucent ocean blue
            radius: 20
            border.color: "#33b3e5fc"
            border.width: 1

            // Inner glass highlight
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 19
                color: "transparent"
                border.color: "#11ffffff"
                border.width: 1
            }

            Column {
                anchors.centerIn: parent
                spacing: 25

                Text {
                    text: "DEEP SEA SPECIMENS"
                    font.family: customFont.name
                    font.pixelSize: 18
                    color: "#b3e5fc"
                    font.letterSpacing: 6
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline
                    styleColor: "#55000000"
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 300
                    height: 46

                    background: Rectangle {
                        color: "#22000000"
                        radius: 23
                        border.color: u.activeFocus ? "#4fc3f7" : "#4403a9f4"
                        border.width: 1
                    }

                    font.family: "sans-serif"
                    font.pixelSize: 20
                    foreground: "#ffffff"
                    font.letterSpacing: 2

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40

                        background: Rectangle {
                            color: optionDelegate0.hovered ? "#3303a9f4" : "#111"
                        }

                        contentItem: Text {
                            text: model.name
                            color: "#ffffff"
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
                    width: 300
                    height: 46
                    placeholderText: "ACCESS CODE"
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 18
                    color: "#ffffff"
                    font.letterSpacing: 0
                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "#22000000"
                        radius: 23
                        border.color: p.activeFocus ? "#4fc3f7" : "#4403a9f4"
                        border.width: 1
                    }
                }

                Rectangle {
                    width: 160
                    height: 44
                    color: "transparent"
                    radius: 22
                    border.color: "#4fc3f7"
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "DIVE"
                        color: "#4fc3f7"
                        font.family: customFont.name
                        font.pixelSize: 16
                        font.letterSpacing: 6
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
                            parent.color = "#4fc3f7";
                            parent.children[0].color = "#000";
                        }
                        onExited: {
                            parent.color = "transparent";
                            parent.children[0].color = "#4fc3f7";
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
        title: "OCEAN JAR"
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
        surface: "#ee071e2a"
        foreground: "#c9f0ff"
        cornerRadius: 24
        controlRadius: 20
        fontFamily: "sans-serif"
        treatment: "pill"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "OCEAN JAR"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 20
        controller: auth
    }
}
