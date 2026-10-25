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
        // Removed the broken gradient overlay that ruined the image
        // Power Controls (Top Left, clean and subtle)

        id: root

        property color themeAccent: config.brand || config.accent || "#673ab7"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"

        // Lo-Fi Animated Background
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

        // Lo-Fi Style Floating Glass Player
        Rectangle {
            id: loginCard

            anchors.right: parent.right
            anchors.rightMargin: 80
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            width: 380
            height: 380
            color: "#44000000" // Simple, clean translucent glass
            radius: 20
            border.color: "#33ffffff"
            border.width: 1 // Very subtle white border, much cleaner than yellow

            Column {
                anchors.centerIn: parent
                spacing: 25

                // Title Area
                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "MOONLIT ROOFTOP"
                        font.family: customFont.name
                        font.pixelSize: 26
                        color: "#ffffff"
                        font.letterSpacing: 4
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: Text.Outline
                        styleColor: "#55000000"
                    }

                    Text {
                        text: "lofi vibes ~ relax and focus"
                        font.family: "sans-serif"
                        font.pixelSize: 12
                        color: "#b39ddb"
                        font.letterSpacing: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 300
                    height: 46
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        color: "#33000000"
                        radius: 23
                        border.color: u.activeFocus ? "#b39ddb" : "#44ffffff"
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
                            color: optionDelegate0.hovered ? "#55ffffff" : "#111"
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
                    placeholderText: "PASSWORD"
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 18
                    color: "#ffffff"
                    font.letterSpacing: 0
                    horizontalAlignment: TextInput.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "#33000000"
                        radius: 23
                        border.color: p.activeFocus ? "#b39ddb" : "#44ffffff"
                        border.width: 1
                    }
                }

                // Login Button (Play Button Style)
                Rectangle {
                    width: 160
                    height: 46
                    color: "transparent"
                    radius: 23
                    border.color: "#b39ddb"
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "ENTER ▶"
                        color: "#b39ddb"
                        font.family: customFont.name
                        font.pixelSize: 16
                        font.letterSpacing: 4
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
                            parent.color = "#b39ddb";
                            parent.children[0].color = "#000";
                        }
                        onExited: {
                            parent.color = "transparent";
                            parent.children[0].color = "#b39ddb";
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
        title: "MOONLIT ROOFTOP"
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
        surface: "#ed17152c"
        foreground: "#e4dcff"
        cornerRadius: 20
        controlRadius: 16
        fontFamily: "sans-serif"
        treatment: "pill"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "MOONLIT ROOFTOP"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 20
        controller: auth
    }
}
