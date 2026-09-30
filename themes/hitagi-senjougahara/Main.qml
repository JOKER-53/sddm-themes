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
        // Power Controls (Bottom Left, below the panel)

        id: root

        property color themeAccent: config.brand || config.accent || "#ff0000"

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

        // Subtle dark gradient from the left to make the panel pop without a harsh box
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 800

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    position: 0
                    color: "#aa000000"
                }

                GradientStop {
                    position: 0.6
                    color: "#55000000"
                }

                GradientStop {
                    position: 1
                    color: "transparent"
                }

            }

        }

        // Elegant Shaft-style Vertical Japanese Text
        Column {
            anchors.left: parent.left
            anchors.leftMargin: 60
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                text: "戦"
                color: "#ffffff"
                font.pixelSize: 42
                font.bold: true
                style: Text.Outline
                styleColor: "#55000000"
            }

            Text {
                text: "場"
                color: "#ffffff"
                font.pixelSize: 42
                font.bold: true
                style: Text.Outline
                styleColor: "#55000000"
            }

            Text {
                text: "ヶ"
                color: "#dc143c"
                font.pixelSize: 42
                font.bold: true
                style: Text.Outline
                styleColor: "#55000000"
            }

            // Crimson accent
            Text {
                text: "原"
                color: "#ffffff"
                font.pixelSize: 42
                font.bold: true
                style: Text.Outline
                styleColor: "#55000000"
            }

        }

        // Main Login Panel (Left side, transparent & elegant)
        Column {
            // Small crimson divider

            anchors.left: parent.left
            anchors.leftMargin: 160
            anchors.verticalCenter: parent.verticalCenter
            spacing: 35

            Text {
                text: "SENJOUGAHARA"
                font.family: customFont.name
                font.pixelSize: 48
                color: "#ffffff"
                font.letterSpacing: 12
                font.bold: true
                style: Text.Outline
                styleColor: "#44000000"
            }

            Rectangle {
                width: 40
                height: 3
                color: "#dc143c"
            }

            ComboBox {
                id: u

                objectName: "usernameField"
                Accessible.name: qsTr("Username")
                enabled: !auth.busy
                width: 320
                height: 50
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                background: Rectangle {
                    color: "#22ffffff"
                    radius: 4
                    border.color: u.activeFocus ? "#dc143c" : "#55ffffff"
                    border.width: 1
                }

                contentItem: Text {
                    text: u.currentText
                    font.family: "sans-serif"
                    font.pixelSize: 20
                    color: "#ffffff"
                    font.letterSpacing: 4
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }

                delegate: ItemDelegate {
                    id: optionDelegate0

                    width: u.width
                    height: 40

                    background: Rectangle {
                        color: optionDelegate0.hovered ? "#33dc143c" : "#22000000"
                    }

                    contentItem: Text {
                        text: model.name
                        color: "#ffffff"
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        verticalAlignment: Text.AlignVCenter
                    }

                }

            }

            TextField {
                id: p

                objectName: "passwordField"
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: 320
                height: 50
                placeholderText: "P A S S W O R D"
                placeholderTextColor: color
                focus: true
                echoMode: TextInput.Password
                font.family: "sans-serif"
                font.pixelSize: 20
                color: "#ffffff"
                font.letterSpacing: 0
                anchors.leftMargin: 20
                padding: 20
                onAccepted: auth.login(u.currentText, p.text, auth.sessionIndex)

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "#22ffffff"
                    radius: 4
                    border.color: p.activeFocus ? "#dc143c" : "#55ffffff"
                    border.width: 1
                }

            }

            Rectangle {
                width: 180
                height: 46
                color: "transparent"
                radius: 4
                border.color: "#dc143c"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "UNLOCK"
                    color: "#dc143c"
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
                        parent.color = "#dc143c";
                        parent.children[0].color = "#ffffff";
                    }
                    onExited: {
                        parent.color = "transparent";
                        parent.children[0].color = "#dc143c";
                    }
                    onClicked: auth.login(u.currentText, p.text, auth.sessionIndex)
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 250
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
        title: "SENJOUGAHARA"
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
