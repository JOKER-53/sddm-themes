import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#03a9f4"

    width: 1920
    height: 1080
    color: "#000"

    // Pixel Art Ocean Jars Animation
    Common.Wallpaper {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.mp4")
        fallbackSource: Qt.resolvedUrl("assets/thumbnail.jpg")
        fillMode: Image.PreserveAspectFit
        speed: 0.6 // Reduced FPS for a calmer, slower underwater animation
        cache: false
    }
    FontLoader {
        id: customFont
        source: "assets/font.ttf"
    }

    // Subtle deep-sea glow at the bottom
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 0.7
                color: "transparent"
            }
            GradientStop {
                position: 1.0
                color: "#440277bd"
            } // Subtle deep blue glow
        }
    }

    // Aquarium Glass Login Panel (Bottom Center)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        width: 380
        height: 260
        color: "#1a03a9f4" // Deep translucent ocean blue
        radius: 20
        border.color: "#33b3e5fc"
        border.width: 1

        // Inner glass highlight
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

            Text {
                text: "DEEP SEA SPECIMENS"
                font.family: customFont.name
                font.pixelSize: 18
                color: "#b3e5fc"
                font.letterSpacing: 6
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Outline
                styleColor: "#55000000"
            }

            ComboBox {
                id: u
                width: 300
                height: 46
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
                background: Rectangle {
                    color: "#22000000"
                    radius: 23
                    border.color: u.activeFocus ? "#4fc3f7" : "#4403a9f4"
                    border.width: 1
                }
                contentItem: Text {
                    text: u.currentText
                    font.family: customFont.name
                    font.pixelSize: 18
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
                        color: optionDelegate0.hovered ? "#3303a9f4" : "#111"
                    }
                    contentItem: Text {
                        text: model.name
                        color: "#ffffff"
                        font.family: customFont.name
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            TextField {
                id: p
                enabled: !auth.busy
                Accessible.name: qsTr("Password")
                width: 300
                height: 46
                placeholderText: "ACCESS CODE"
                placeholderTextColor: "#66b3e5fc"
                focus: true
                echoMode: TextInput.Password
                font.family: customFont.name
                font.pixelSize: 18
                color: "#ffffff"
                font.letterSpacing: 6
                horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle {
                    color: "#22000000"
                    radius: 23
                    border.color: p.activeFocus ? "#4fc3f7" : "#4403a9f4"
                    border.width: 1
                }
                onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
            }

            Rectangle {
                width: 160
                height: 44
                color: "transparent"
                radius: 22
                border.color: "#4fc3f7"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    anchors.centerIn: parent
                    text: "DIVE"
                    color: "#4fc3f7"
                    font.family: customFont.name
                    font.pixelSize: 16
                    font.letterSpacing: 6
                    font.bold: true
                }
                Common.ActionArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.color = "#4fc3f7";
                        parent.children[0].color = "#000";
                    }
                    onExited: {
                        parent.color = "transparent";
                        parent.children[0].color = "#4fc3f7";
                    }
                    onClicked: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
        }
    }

    // Minimalist Deep Ocean Power Controls
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        spacing: 25
        z: 100

        ComboBox {
            id: sessionCombo
            width: 140
            height: 36
            model: sessionModel
            textRole: "name"
            currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            background: Rectangle {
                color: "transparent"
            }
            contentItem: Text {
                text: sessionCombo.currentText
                color: "#b3e5fc"
                font.family: customFont.name
                font.pixelSize: 13
                font.letterSpacing: 2
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
            }
            delegate: ItemDelegate {
                id: optionDelegate1

                width: sessionCombo.width
                height: 36
                background: Rectangle {
                    color: optionDelegate1.hovered ? "#3303a9f4" : "#111"
                }
                contentItem: Text {
                    text: model.name
                    color: "#ffffff"
                    font.family: customFont.name
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Text {
            text: "RESTART"
            color: "#b3e5fc"
            font.family: customFont.name
            font.pixelSize: 13
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ffffff";
                }
                onExited: {
                    parent.color = "#b3e5fc";
                }
                onClicked: sddm.reboot()
            }
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }

        Text {
            text: "SHUTDOWN"
            color: "#b3e5fc"
            font.family: customFont.name
            font.pixelSize: 13
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ffffff";
                }
                onExited: {
                    parent.color = "#b3e5fc";
                }
                onClicked: sddm.powerOff()
            }
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    // Injected Top-Center Clock
    Column {
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -10
        z: 10
        Text {
            id: injectedClockTime
            text: Qt.formatTime(new Date(), "hh:mm")
            font.family: customFont.name
            font.pixelSize: 84
            color: "#b3e5fc"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#b3e5fc"
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

    Common.AuthController {
        id: auth
        passwordField: p
    }
    Common.LoginStatus {
        anchors.top: parent.top
        anchors.topMargin: 160
        anchors.horizontalCenter: parent.horizontalCenter
        controller: auth
    }
}
