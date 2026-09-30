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
        // Minimalist Power Controls

        id: root

        property color themeAccent: config.brand || config.accent || "#f44336"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"

        // Minecraft Sakura Background
        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
            fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
            fillMode: Image.PreserveAspectCrop
            speed: 1.8 // Increased FPS / playback speed as requested
            cache: false
        }

        FontLoader {
            id: customFont

            source: "assets/font.ttf"
        }

        // Soft gradient to ensure UI readability
        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "transparent"
                }

                GradientStop {
                    position: 0.5
                    color: "transparent"
                }

                GradientStop {
                    position: 1
                    color: "#aa000000"
                }

            }

        }

        // Sakura / Blocky UI Panel
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 112 / viewport.layoutScale
            width: 580
            height: 264
            color: "#44ffffff" // Soft frosted glass
            radius: 12
            border.color: "#ffb7c5"
            border.width: 2 // Sakura pink border

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "SKYLINE SPEC-R"
                    font.family: customFont.name
                    font.pixelSize: 28
                    color: "#ffffff"
                    font.letterSpacing: 4
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline
                    styleColor: "#ff8da1" // Sakura pink outline
                }

                Row {
                    spacing: 15
                    anchors.horizontalCenter: parent.horizontalCenter

                    ComboBox {
                        id: u

                        objectName: "usernameField"
                        Accessible.name: qsTr("Username")
                        enabled: !auth.busy
                        width: 180
                        height: 46
                        model: userModel
                        textRole: "name"
                        currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                        background: Rectangle {
                            color: "#33000000"
                            radius: 8
                            border.color: u.activeFocus ? "#ffffff" : "#ffb7c5"
                            border.width: 2
                        }

                        contentItem: Text {
                            text: u.currentText
                            font.family: "sans-serif"
                            font.pixelSize: 20
                            color: "#ffffff"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }

                        delegate: ItemDelegate {
                            id: optionDelegate0

                            width: u.width
                            height: 40

                            background: Rectangle {
                                color: optionDelegate0.hovered ? "#ffb7c5" : "#33000000"
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
                        enabled: !auth.busy
                        Accessible.name: qsTr("Password")
                        width: 180
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
                        onAccepted: auth.login(u.currentText, p.text, auth.sessionIndex)

                        Common.FieldFocus {
                        }

                        background: Rectangle {
                            color: "#33000000"
                            radius: 8
                            border.color: p.activeFocus ? "#ffffff" : "#ffb7c5"
                            border.width: 2
                        }

                    }

                    Common.LoginSubmit {
                        objectName: "loginButton"
                        width: 110
                        accent: root.themeAccent
                        enabled: !auth.busy
                        onClicked: auth.login(u.currentText, p.text, auth.sessionIndex)
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
        title: "NISSAN SKYLINE"
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
