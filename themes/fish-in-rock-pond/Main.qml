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

        property color themeAccent: config.brand || config.accent || "#ff9800"

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

        // Jumping Fish Animation 🐟
        Item {
            id: fishContainer

            width: 64
            height: 64
            x: 400
            y: 700
            z: 50
            opacity: 0

            Text {
                id: fishEmoji

                text: "🐟"
                font.pixelSize: 56
                anchors.centerIn: parent
                rotation: -45
            }

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                // Wait underwater
                PauseAnimation {
                    duration: 3000
                }

                // Jump!
                ParallelAnimation {
                    // X movement (linear arc across the pond)
                    NumberAnimation {
                        target: fishContainer
                        property: "x"
                        from: 300
                        to: 1000
                        duration: 1500
                    }

                    // Y movement (arc - jump up then down due to gravity)
                    SequentialAnimation {
                        NumberAnimation {
                            target: fishContainer
                            property: "y"
                            from: 750
                            to: 400
                            duration: 750
                            easing.type: Easing.OutQuad
                        }

                        NumberAnimation {
                            target: fishContainer
                            property: "y"
                            from: 400
                            to: 800
                            duration: 750
                            easing.type: Easing.InQuad
                        }

                    }

                    // Splash rotation
                    SequentialAnimation {
                        NumberAnimation {
                            target: fishEmoji
                            property: "rotation"
                            from: -60
                            to: 60
                            duration: 1500
                        }

                    }

                    // Opacity (appear instantly when jumping, disappear when hitting water)
                    SequentialAnimation {
                        NumberAnimation {
                            target: fishContainer
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 150
                        }

                        PauseAnimation {
                            duration: 1200
                        }

                        NumberAnimation {
                            target: fishContainer
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 150
                        }

                    }

                }

                // Wait again
                PauseAnimation {
                    duration: 5000
                }

                // Second jump (other direction)
                ParallelAnimation {
                    NumberAnimation {
                        target: fishContainer
                        property: "x"
                        from: 1300
                        to: 600
                        duration: 1600
                    }

                    SequentialAnimation {
                        NumberAnimation {
                            target: fishContainer
                            property: "y"
                            from: 800
                            to: 450
                            duration: 800
                            easing.type: Easing.OutQuad
                        }

                        NumberAnimation {
                            target: fishContainer
                            property: "y"
                            from: 450
                            to: 850
                            duration: 800
                            easing.type: Easing.InQuad
                        }

                    }

                    SequentialAnimation {
                        NumberAnimation {
                            target: fishEmoji
                            property: "rotation"
                            from: -120
                            to: -240
                            duration: 1600
                        }

                    }

                    SequentialAnimation {
                        NumberAnimation {
                            target: fishContainer
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 150
                        }

                        PauseAnimation {
                            duration: 1300
                        }

                        NumberAnimation {
                            target: fishContainer
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 150
                        }

                    }

                }

            }

        }

        // Zen UI overlay
        Rectangle {
            // Deep teal overlay at the bottom

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
                    color: "#aa001a1a"
                }

            }

        }

        // Main Login Panel (Zen Garden Style)
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 120
            width: 400
            height: 360
            color: "#66002b2b" // Dark translucent teal
            radius: 12
            border.color: "#88ff9800"
            border.width: 1 // subtle koi orange border

            Column {
                anchors.centerIn: parent
                spacing: 25

                Text {
                    text: "KOI GARDEN"
                    font.family: customFont.name
                    font.pixelSize: 32
                    color: root.themeAccent
                    font.letterSpacing: 6
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ComboBox {
                    id: u

                    objectName: "usernameField"
                    Accessible.name: qsTr("Username")
                    enabled: !auth.busy
                    width: 300
                    height: 44
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: u.activeFocus ? root.themeAccent : "#66ffffff"
                        }

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
                            color: optionDelegate0.hovered ? "#33ff9800" : "transparent"
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
                    height: 44
                    placeholderText: "ENTER PASSCODE"
                    placeholderTextColor: color
                    focus: true
                    echoMode: TextInput.Password
                    font.family: "sans-serif"
                    font.pixelSize: 20
                    color: "#ffffff"
                    font.letterSpacing: 0
                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: auth.login(u.currentText, p.text, auth.sessionIndex)

                    Common.FieldFocus {
                    }

                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: p.activeFocus ? root.themeAccent : "#66ffffff"
                        }

                    }

                }

                Rectangle {
                    width: 160
                    height: 46
                    color: "transparent"
                    radius: 23
                    border.color: root.themeAccent
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "ENTER"
                        color: root.themeAccent
                        font.family: customFont.name
                        font.pixelSize: 18
                        font.letterSpacing: 4
                    }

                    Common.ActionArea {
                        enabled: !auth.busy
                        Accessible.name: qsTr("Sign in")
                        objectName: "loginButton"
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: {
                            parent.color = root.themeAccent;
                            parent.children[0].color = "#000";
                        }
                        onExited: {
                            parent.color = "transparent";
                            parent.children[0].color = root.themeAccent;
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
        title: "KOI POND"
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
