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
        // Power Options

        id: root

        property color themeAccent: config.brand || config.accent || "#ff2a6d"
        property color neonPink: config.neonPink || root.themeAccent
        property color neonCyan: config.neonCyan || "#05d9e8"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"
        Component.onCompleted: passField.forceActiveFocus()

        Common.Wallpaper {
            id: bg

            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
            fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
            fillMode: Image.PreserveAspectFit
        }

        // Vignette overlay
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: root.neonCyan
            border.width: 1
            opacity: 0.15

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#aa000000"
                }

                GradientStop {
                    position: 0.5
                    color: "#00000000"
                }

                GradientStop {
                    position: 1
                    color: "#dd000000"
                }

            }

        }

        // High-tech slanted HUD container
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            anchors.horizontalCenter: parent.horizontalCenter
            width: 700
            height: 280
            color: "#88000000"
            border.color: root.neonPink
            border.width: 2
            radius: 8

            // Glowing border effect
            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                color: "transparent"
                border.color: root.neonPink
                border.width: 1
                opacity: 0.5
                radius: 10
            }

            Row {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 40

                // Left side: Clock & Info
                Column {
                    width: 250
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "SYSTEM LOGIN"
                        color: root.neonCyan
                        font.family: "Monospace"
                        font.pixelSize: 14
                        font.letterSpacing: 4
                    }

                    Text {
                        id: clockText

                        text: Qt.formatDateTime(new Date(), "HH:mm")
                        color: "#fff"
                        font.family: "Impact"
                        font.pixelSize: 80
                        font.letterSpacing: 4
                        style: Text.Outline
                        styleColor: root.neonPink
                    }

                    Text {
                        id: dateText

                        text: Qt.formatDateTime(new Date(), "yyyy-MM-dd")
                        color: root.neonCyan
                        font.family: "Monospace"
                        font.pixelSize: 16
                        font.letterSpacing: 2
                    }

                }

                Rectangle {
                    width: 2
                    height: parent.height
                    color: root.neonPink
                    opacity: 0.5
                }

                // Right side: Inputs
                Column {
                    width: 300
                    spacing: 20
                    anchors.verticalCenter: parent.verticalCenter

                    // USERNAME DROPDOWN
                    ComboBox {
                        id: userCombo

                        objectName: "usernameField"
                        Accessible.name: qsTr("Username")
                        enabled: !auth.busy
                        width: parent.width
                        height: 44
                        model: userModel
                        textRole: "name"
                        currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                        background: Rectangle {
                            color: "#33000000"
                            border.color: root.neonCyan
                            border.width: 1
                        }

                        contentItem: Text {
                            text: userCombo.currentText + " ▾"
                            color: root.neonCyan
                            font.family: "sans-serif"
                            font.pixelSize: 20
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                        }

                        delegate: ItemDelegate {
                            id: optionDelegate0

                            width: userCombo.width
                            height: 40

                            contentItem: Text {
                                text: model.name
                                color: root.neonCyan
                                font.family: "sans-serif"
                                font.pixelSize: 20
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                color: optionDelegate0.hovered ? "#3305d9e8" : "#cc000000"
                                border.color: root.neonCyan
                                border.width: optionDelegate0.hovered ? 1 : 0
                            }

                        }

                        popup: Popup {
                            y: userCombo.height - 1
                            width: userCombo.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: userCombo.popup.visible ? userCombo.delegateModel : null
                                currentIndex: userCombo.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator {
                                }

                            }

                            background: Rectangle {
                                color: "#dd000000"
                                border.color: root.neonCyan
                            }

                        }

                    }

                    // PASSWORD INPUT
                    TextField {
                        id: passField

                        placeholderTextColor: color
                        objectName: "passwordField"
                        enabled: !auth.busy
                        Accessible.name: qsTr("Password")
                        width: parent.width
                        height: 44
                        placeholderText: "PASSWORD"
                        focus: true
                        echoMode: TextInput.Password
                        color: "#fff"
                        font.family: "sans-serif"
                        font.pixelSize: 16
                        font.letterSpacing: 0
                        onAccepted: auth.login(userCombo.currentText, passField.text, auth.sessionIndex)

                        Common.FieldFocus {
                        }

                        background: Rectangle {
                            color: "#33000000"
                            border.color: root.neonPink
                            border.width: 1
                        }

                    }

                    // LOGIN BUTTON
                    Rectangle {
                        width: parent.width
                        height: 44
                        color: root.neonPink

                        Text {
                            anchors.centerIn: parent
                            text: "INITIALIZE //"
                            color: "#000"
                            font.family: "Impact"
                            font.pixelSize: 20
                            font.letterSpacing: 2
                        }

                        Common.ActionArea {
                            Accessible.name: qsTr("Sign in")
                            objectName: "loginButton"
                            enabled: !auth.busy
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: auth.login(userCombo.currentText, passField.text, auth.sessionIndex)
                        }

                    }

                }

            }

        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clockText.text = Qt.formatDateTime(new Date(), "HH:mm");
                dateText.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd");
            }
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
        title: "NEON"
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
