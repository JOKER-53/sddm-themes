// BMW Museum — top placard, M-stripe accent column on the left side
// (keeps the cars on the right visible). Login behaves like a key-fob panel.
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
        // Telemetry bottom-left

        id: root

        property color themeAccent: config.brand || config.accent || "#1c69d4"
        property color mBlue: root.themeAccent
        property color mPurple: "#1f2e6e"
        property color mRed: "#e22718"
        property color ink: "#f4f4f4"
        property color sub: "#d0d0d0"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000000"
        Component.onCompleted: passField.forceActiveFocus()

        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        // Left dim wash so the panel reads
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.36

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    position: 0
                    color: "#000000"
                }

                GradientStop {
                    position: 1
                    color: "transparent"
                }

            }

        }

        // M-stripe column
        Row {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0

            Rectangle {
                width: 8
                height: parent.height
                color: root.mBlue
            }

            Rectangle {
                width: 8
                height: parent.height
                color: root.mPurple
            }

            Rectangle {
                width: 8
                height: parent.height
                color: root.mRed
            }

        }

        // Top museum placard
        Row {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 48
            anchors.leftMargin: 80
            spacing: 16

            Rectangle {
                width: 14
                height: 14
                radius: 7
                color: "#fff"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "BMW · M-MOTORSPORT"
                color: root.ink
                font.family: "Helvetica"
                font.pixelSize: 14
                font.letterSpacing: 5
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "—  1986  —  E28 M535i"
                color: root.sub
                font.family: "Helvetica"
                font.pixelSize: 12
                font.letterSpacing: 3
                anchors.verticalCenter: parent.verticalCenter
            }

        }

        // Key-fob login panel — left third
        ColumnLayout {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 80
            width: 380
            spacing: 10

            Text {
                text: "IGNITION"
                color: root.mBlue
                font.family: "Helvetica"
                font.pixelSize: 11
                font.letterSpacing: 5
            }

            TextField {
                id: bmwUser

                placeholderTextColor: color
                objectName: "usernameField"
                Accessible.name: qsTr("Username")
                enabled: !auth.busy
                text: userModel.lastUser || compact.defaultUsername
                placeholderText: "USERNAME"
                color: root.ink
                font.family: "sans-serif"
                font.pixelSize: 36
                font.bold: true

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "transparent"
                }

            }

            Text {
                text: "Authorized operator"
                color: root.sub
                font.pixelSize: 12
                font.letterSpacing: 2
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: root.mBlue
                Layout.topMargin: 14
            }

            TextField {
                id: passField

                objectName: "passwordField"
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                Layout.fillWidth: true
                placeholderText: "ENTER KEY CODE"
                placeholderTextColor: color
                focus: true
                echoMode: TextInput.Password
                color: root.ink
                font.family: "sans-serif"
                font.pixelSize: 18
                font.letterSpacing: 0
                onAccepted: auth.login(bmwUser.text, passField.text, auth.sessionIndex)

                Common.FieldFocus {
                }

                background: Rectangle {
                    color: "transparent"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 2
                        color: root.mRed
                    }

                }

            }

            Row {
                spacing: 10
                Layout.topMargin: 18

                Rectangle {
                    width: 110
                    height: 36
                    color: root.mBlue

                    Text {
                        anchors.centerIn: parent
                        text: "▸ START"
                        color: "#fff"
                        font.family: "Helvetica"
                        font.pixelSize: 12
                        font.letterSpacing: 4
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        onClicked: auth.login(bmwUser.text, passField.text, auth.sessionIndex)
                    }

                }

                Rectangle {
                    width: 90
                    height: 36
                    color: "transparent"
                    border.color: root.sub
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: systemBar.sessionName
                        color: root.sub
                        font.family: "Helvetica"
                        font.pixelSize: 11
                        font.letterSpacing: 3
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
        title: "BMW MUSEUM"
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
