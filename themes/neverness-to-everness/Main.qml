import QtQml 2.15
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
        // Power Controls (Bottom Right)

        id: root

        property color themeAccent: config.brand || config.accent || "#e91e63"

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

        // Subtle dark gradient from bottom
        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "transparent"
                }

                GradientStop {
                    position: 0.6
                    color: "transparent"
                }

                GradientStop {
                    position: 1
                    color: "#77000000"
                }

            }

        }

        // Anime Slice-of-Life Clock
        Text {
            id: timeDisplay

            anchors.top: parent.top
            anchors.topMargin: 80
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "sans-serif"
            font.pixelSize: 84
            font.weight: Font.Light
            color: "#ffffff"
            style: Text.Outline
            styleColor: "#33000000"

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    var d = new Date();
                    timeDisplay.text = d.toLocaleTimeString(Qt.locale(), "hh:mm");
                }
                Component.onCompleted: {
                    var d = new Date();
                    timeDisplay.text = d.toLocaleTimeString(Qt.locale(), "hh:mm");
                }
            }

        }

        Text {
            anchors.top: timeDisplay.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: "NEVERNESS TO EVERNESS"
            font.family: customFont.name
            font.pixelSize: 18
            font.letterSpacing: 8
            color: "#ffffff"
            opacity: 0.8
            style: Text.Outline
            styleColor: "#33000000"
        }

        // Elegant Login Panel
        Rectangle {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 60
            width: 380
            height: 260
            color: "#22ffffff" // Very soft translucent glass
            radius: 20
            border.color: "#66ffffff"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 25

                ComboBox {
                    id: u

                    objectName: "usernameField"
                    Accessible.name: qsTr("Username")
                    enabled: !auth.busy
                    width: 300
                    height: 46
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                    background: Rectangle {
                        color: "#44000000"
                        radius: 23
                        border.color: u.activeFocus ? "#ff77a9" : "transparent"
                        border.width: 1
                    }

                    contentItem: Text {
                        text: u.currentText
                        font.family: "sans-serif"
                        font.pixelSize: 20
                        color: "#ffffff"
                        font.letterSpacing: 2
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    delegate: ItemDelegate {
                        id: optionDelegate0

                        width: u.width
                        height: 40

                        background: Rectangle {
                            color: optionDelegate0.hovered ? "#33ff77a9" : "#dd000000"
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
                    onAccepted: auth.login(u.currentText, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                    }

                    background: Rectangle {
                        color: "#44000000"
                        radius: 23
                        border.color: p.activeFocus ? "#ff77a9" : "transparent"
                        border.width: 1
                    }

                }

                Rectangle {
                    width: 180
                    height: 46
                    color: "transparent"
                    radius: 23
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "LOGIN"
                        color: "#ffffff"
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
                            parent.color = "#ffffff";
                            parent.children[0].color = "#000000";
                        }
                        onExited: {
                            parent.color = "transparent";
                            parent.children[0].color = "#ffffff";
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
        title: "NTE ANIME"
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
