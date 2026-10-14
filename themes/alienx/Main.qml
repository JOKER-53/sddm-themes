// Alien X — Omnitrix sci-fi terminal.
// Structure: subject keeps its black bg on the right; left half is a
// vertical green-on-black command console. Hex-bordered inputs, scanlines.
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
        id: root

        property color themeAccent: config.brand || config.accent || "#8aff5a"
        property color glow: root.themeAccent
        property color text: "#d6ffd0"
        property color dim: "#98c68c"

        width: viewport.width / viewport.layoutScale
        height: viewport.height / viewport.layoutScale
        scale: viewport.layoutScale
        transformOrigin: Item.TopLeft
        visible: !viewport.compactMode
        color: "#000"
        Component.onCompleted: {
            if (userIn.pass)
                userIn.pass.forceActiveFocus();

        }

        // subject on the right
        Common.Wallpaper {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
            fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
            fillMode: Image.PreserveAspectFit
            height: parent.height * 0.9
        }

        // scanline overlay
        Repeater {
            model: 360

            delegate: Rectangle {
                y: index * 3
                width: root.width
                height: 1
                color: root.glow
                opacity: 0.04
            }

        }

        // left console
        Column {
            x: 120
            anchors.verticalCenter: parent.verticalCenter
            spacing: 24
            width: 480

            Text {
                text: "OMNITRIX :: AUTH"
                color: root.glow
                font.family: "Monospace"
                font.pixelSize: 14
                font.letterSpacing: 8
            }

            Text {
                text: "[ DNA SAMPLE REQUIRED ]"
                color: root.dim
                font.family: "Monospace"
                font.pixelSize: 12
                font.letterSpacing: 4
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.glow
                opacity: 0.4
            }

            Text {
                id: bigClock

                color: root.glow
                font.family: "Monospace"
                font.pixelSize: 92
                font.bold: true
                text: Qt.formatDateTime(new Date(), "HH:mm")
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: bigClock.text = Qt.formatDateTime(new Date(), "HH:mm")
            }

            // hex-style inputs
            Repeater {
                model: [{
                    "ph": "USER ID",
                    "id": "u"
                }, {
                    "ph": "PASSPHRASE",
                    "id": "p"
                }]

                delegate: Rectangle {
                    width: parent.width
                    height: 52
                    color: "transparent"
                    border.color: root.glow
                    border.width: 1

                    TextField {
                        id: tf

                        placeholderTextColor: color
                        objectName: modelData.id === "p" ? "passwordField" : "usernameField"
                        enabled: !auth.busy
                        Accessible.name: modelData.ph
                        anchors.fill: parent
                        anchors.margins: 2
                        placeholderText: "> " + modelData.ph
                        text: modelData.id === "u" && userModel.lastUser || compact.defaultUsername
                        echoMode: modelData.id === "p" ? TextInput.Password : TextInput.Normal
                        color: root.text
                        font.family: "sans-serif"
                        font.pixelSize: 16
                        onAccepted: {
                            if (modelData.id === "p")
                                auth.login(userIn.userField(), tf.text, auth.sessionIndex);

                        }
                        Component.onCompleted: {
                            if (modelData.id === "u")
                                userIn.user = tf;
                            else
                                userIn.pass = tf;
                        }

                        Common.FieldFocus {
                        }

                        background: Rectangle {
                            color: "#001100"
                        }

                    }

                }

            }

            QtObject {
                id: userIn

                property var user
                property var pass

                function userField() {
                    return user ? user.text : "";
                }

            }

            Rectangle {
                width: parent.width
                height: 48
                color: root.glow

                Text {
                    anchors.centerIn: parent
                    text: "▶ TRANSFORM"
                    color: "#000"
                    font.family: "Monospace"
                    font.bold: true
                    font.letterSpacing: 6
                }

                Common.ActionArea {
                    Accessible.name: qsTr("Sign in")
                    objectName: "loginButton"
                    enabled: !auth.busy
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: auth.login(userIn.userField(), userIn.pass.text, auth.sessionIndex)
                }

            }

        }

        Common.AuthController {
            id: auth

            passwordField: viewport.compactMode ? compact.passwordField : userIn.pass
        }

    }

    Common.CompactGreeter {
        id: compact

        anchors.fill: parent
        visible: viewport.compactMode
        controller: auth
        accent: root.themeAccent
        title: "ALIEN X"
        wallpaperSource: Qt.resolvedUrl(config.background || "assets/wallpaper.png")
        fallbackSource: Qt.resolvedUrl("assets/wallpaper.png")
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
