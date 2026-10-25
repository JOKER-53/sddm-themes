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
        id: root

        property color themeAccent: config.brand || config.accent || "#f5a623"
        property color amber: root.themeAccent
        property color panel: "#e60a0a0a"
        property color text: "#ececec"
        property color dim: "#7a7a7a"
        property color redAlert: "#e53935"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"
        Component.onCompleted: p.forceActiveFocus()

        Common.Wallpaper {
            anchors.fill: parent
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        // Vignette for dramatic effect
        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#aa000000"
                }

                GradientStop {
                    position: 0.3
                    color: "transparent"
                }

                GradientStop {
                    position: 0.7
                    color: "transparent"
                }

                GradientStop {
                    position: 1
                    color: "#ee000000"
                }
            }
        }

        // Direction-aware car animation
        // Better way to do the car
        Item {
            id: carContainer

            property bool goingRight: true

            y: hud.y - 32
            x: -100
            width: 60
            height: 32
            z: 10

            Text {
                id: carEmoji

                anchors.centerIn: parent
                text: "🏎️"
                font.pixelSize: 32

                transform: Scale {
                    origin.x: carEmoji.width / 2
                    xScale: carContainer.goingRight ? 1 : -1
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: carContainer.goingRight ? carEmoji.left : undefined
                anchors.left: carContainer.goingRight ? undefined : carEmoji.right
                text: "💨"
                font.pixelSize: 24
            }

            SequentialAnimation on x {
                loops: Animation.Infinite
                running: true

                ScriptAction {
                    script: carContainer.goingRight = true
                }

                NumberAnimation {
                    from: -100
                    to: root.width + 100
                    duration: 6000
                    easing.type: Easing.InOutQuad
                }

                PauseAnimation {
                    duration: 2000
                }

                ScriptAction {
                    script: carContainer.goingRight = false
                }

                NumberAnimation {
                    from: root.width + 100
                    to: -100
                    duration: 5000
                    easing.type: Easing.InOutCubic
                }

                PauseAnimation {
                    duration: 3000
                }
            }
        }

        // ---- Dashboard HUD bar ----
        Rectangle {
            // right cluster

            id: hud

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 112 / viewport.layoutScale
            height: 140
            color: root.panel
            border.color: root.amber
            border.width: 2

            // Carbon fiber / scanline pattern overlay
            Column {
                anchors.fill: parent

                Repeater {
                    model: 35

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: index % 2 == 0 ? "#11ffffff" : "transparent"
                    }
                }
            }

            // Left Cluster: Clock and RPM
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 48
                anchors.verticalCenter: parent.verticalCenter
                spacing: 30

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: clk

                        color: root.amber
                        font.family: "Monospace"
                        font.pixelSize: 56
                        font.bold: true
                        text: Qt.formatDateTime(new Date(), "HH:mm:ss")
                    }

                    Text {
                        id: dt

                        color: root.dim
                        font.family: "Monospace"
                        font.pixelSize: 14
                        font.letterSpacing: 3
                        text: Qt.formatDateTime(new Date(), "ddd dd MMM yyyy").toUpperCase()
                    }
                }

                // Animated RPM Gauge
                Row {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 30
                    spacing: 4

                    Repeater {
                        model: 12

                        Rectangle {
                            property int baseHeight: index > 8 ? 60 : 40

                            width: 10
                            height: 10
                            radius: 2
                            color: index > 8 ? root.redAlert : root.amber

                            Timer {
                                running: true
                                repeat: true
                                interval: 100 + Math.random() * 200
                                onTriggered: parent.height = 10 + Math.random() * parent.baseHeight
                            }

                            Behavior on height {
                                NumberAnimation {
                                    duration: 150
                                }
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
                    clk.text = Qt.formatDateTime(new Date(), "HH:mm:ss");
                    dt.text = Qt.formatDateTime(new Date(), "ddd dd MMM yyyy").toUpperCase();
                }
            }

            // center login
            Row {
                anchors.centerIn: parent
                spacing: 20

                // Decorative label
                Text {
                    text: "SYSTEM\nOVERRIDE"
                    color: root.dim
                    font.family: "Monospace"
                    font.pixelSize: 10
                    font.bold: true
                    horizontalAlignment: Text.AlignRight
                    anchors.verticalCenter: parent.verticalCenter
                    font.letterSpacing: 2
                }

                Common.UsernamePicker {
                    id: u

                    objectName: "usernameField"
                    controller: auth
                    Accessible.name: qsTr("Username")
                    width: 220
                    height: 50

                    foreground: root.text
                    font.family: "sans-serif"
                    font.pixelSize: 20
                    font.bold: true
                    horizontalAlignment: TextInput.AlignHCenter

                    background: Rectangle {
                        color: "#33000000"
                        border.color: u.activeFocus ? root.amber : root.dim
                        border.width: 2
                    }
                }

                TextField {
                    id: p

                    placeholderTextColor: color
                    objectName: "passwordField"
                    onTextEdited: auth.dismissError()
                    Accessible.description: auth.rejected ? auth.errorMessage : ""
                    enabled: !auth.busy
                    Accessible.name: qsTr("Password")
                    width: 320
                    height: 50
                    placeholderText: "PASSWORD"
                    focus: true
                    echoMode: TextInput.Password
                    color: root.text
                    font.family: "sans-serif"
                    font.pixelSize: 20
                    font.bold: true
                    horizontalAlignment: TextInput.AlignHCenter
                    font.letterSpacing: 0
                    onAccepted: auth.login(auth.username, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                        controller: auth
                    }

                    background: Rectangle {
                        color: "#33000000"
                        border.color: p.activeFocus ? root.amber : root.dim
                        border.width: 2
                    }
                }

                Rectangle {
                    width: 120
                    height: 50
                    color: root.amber

                    Text {
                        anchors.centerIn: parent
                        text: "IGNITION"
                        color: "#000"
                        font.family: "Monospace"
                        font.bold: true
                        font.letterSpacing: 3
                        font.pixelSize: 18
                    }

                    Common.ActionArea {
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        enabled: !auth.busy
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = "#ffd54f"
                        onExited: parent.color = root.amber
                        onClicked: auth.login(auth.username, p.text, auth.sessionIndex)
                    }

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: true

                        NumberAnimation {
                            from: 0.8
                            to: 1
                            duration: 800
                        }

                        NumberAnimation {
                            from: 1
                            to: 0.8
                            duration: 800
                        }
                    }
                }
            }
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
        title: "CLASSIC JDM"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.jpg")
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
        surface: "#e60a0a0a"
        foreground: "#ffb020"
        cornerRadius: 0
        controlRadius: 0
        fontFamily: "Monospace"
        treatment: "stripe"
    }

    Common.LoginStatus {
        compactMode: viewport.compactMode
        accent: root.themeAccent
        title: "CLASSIC JDM"
        fontFamily: viewport.compactMode ? "sans-serif" : p.font.family
        surface: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ed171717" : p.background.color
        foreground: viewport.compactMode || !p.background || p.background.color.a < 0.5 ? "#ffffff" : p.color
        cornerRadius: viewport.compactMode ? 10 : 2
        controller: auth
    }
}
