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
        // Zen power controls (Bottom Right)

        id: root

        property color themeAccent: config.brand || config.accent || "#00bcd4"

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

        // Subtle dark gradient at the bottom for readability
        Rectangle {
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
                    color: "#aa000000"
                }
            }
        }

        // Alpine Explorer Dashboard (Login Panel)
        Rectangle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.margins: 80
            width: 420
            height: 380
            color: "#22000000" // Extremely subtle dark glass
            radius: 20
            border.color: "#44ffffff"
            border.width: 1

            // Inner bright border for glassy feel
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

                // Elegant Title
                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "MT. EVEREST"
                        font.family: customFont.name
                        font.pixelSize: 42
                        color: "#ffffff"
                        font.letterSpacing: 8
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: Text.Outline
                        styleColor: "#44000000"
                    }

                    Text {
                        text: "ELEVATION: 8,848 M"
                        font.family: "sans-serif"
                        font.pixelSize: 12
                        color: "#aaffffff"
                        font.letterSpacing: 4
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 300
                    height: 50

                    background: Rectangle {
                        color: "#33ffffff"
                        border.color: u.activeFocus ? "#fff" : "#88ffffff"
                        border.width: 1
                        radius: 25
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
                            color: optionDelegate0.hovered ? "#44ffffff" : "#22ffffff"
                            radius: 20
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
                    height: 50
                    placeholderText: "ENTER PASSKEY"
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
                        color: "#33ffffff"
                        border.color: p.activeFocus ? "#fff" : "#88ffffff"
                        border.width: 1
                        radius: 25
                    }
                }

                // Minimalist ASCEND button
                Rectangle {
                    width: 180
                    height: 50
                    color: "transparent"
                    radius: 25
                    border.color: "#ffffff"
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "ASCEND"
                        color: "#ffffff"
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
                            parent.color = "#ffffff";
                            parent.children[0].color = "#000";
                        }
                        onExited: {
                            parent.color = "transparent";
                            parent.children[0].color = "#ffffff";
                        }
                        onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
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
        title: "MT. EVEREST"
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
        surface: "#f0f1f7fa"
        foreground: "#224858"
        cornerRadius: 4
        controlRadius: 2
        fontFamily: "sans-serif"
        treatment: "panel"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "MT. EVEREST"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 20
        controller: auth
    }
}
