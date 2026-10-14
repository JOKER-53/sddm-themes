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
        // Top-left power buttons (styled elegantly)

        id: root

        property color themeAccent: config.brand || config.accent || "#1c69d4"

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

        // Background Image
        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
            fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
            fillMode: Image.PreserveAspectCrop
        }

        // Sleek bottom panel with a top border only
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            width: parent.width
            height: 150
            color: "#d9000000" // rgba(0,0,0,0.85)

            // Top border line
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: root.themeAccent
            }

            Row {
                anchors.centerIn: parent
                spacing: 40

                // User ComboBox
                ComboBox {
                    id: u

                    objectName: "usernameField"
                    Accessible.name: qsTr("Username")
                    enabled: !auth.busy
                    width: 250
                    height: 50
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                    background: Rectangle {
                        color: "transparent"
                        border.color: root.themeAccent
                        border.width: 2
                        radius: 25
                    }

                    contentItem: Text {
                        text: u.currentText
                        color: "#fff"
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40

                        background: Rectangle {
                            color: optionDelegate0.hovered ? root.themeAccent : "#000"
                        }

                        contentItem: Text {
                            text: model.name
                            color: "#fff"
                            font.family: "sans-serif"
                            font.pixelSize: 20
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                    }

                }

                // Password Field
                TextField {
                    id: p

                    objectName: "passwordField"
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 300
                    height: 50
                    placeholderText: "PIN CODE"
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    color: "#fff"
                    font.family: "sans-serif"
                    font.pixelSize: 22
                    horizontalAlignment: TextInput.AlignHCenter
                    font.letterSpacing: 0
                    onAccepted: auth.login(u.currentText, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                    }

                    background: Rectangle {
                        color: "transparent"
                        border.color: root.themeAccent
                        border.width: 2
                        radius: 25
                    }

                }

                // Login Button
                Rectangle {
                    width: 200
                    height: 50
                    color: root.themeAccent
                    radius: 25

                    Text {
                        anchors.centerIn: parent
                        text: "START ENGINE"
                        color: "#fff"
                        font.family: customFont.name
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = "#2b7de0"
                        onExited: parent.color = root.themeAccent
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
        title: "BMW M3"
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
