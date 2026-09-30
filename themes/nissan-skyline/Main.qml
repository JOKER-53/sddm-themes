import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#f44336"

    width: 1920
    height: 1080
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
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 0.5
                color: "transparent"
            }
            GradientStop {
                position: 1.0
                color: "#aa000000"
            }
        }
    }

    // Sakura / Blocky UI Panel
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 80
        width: 450
        height: 200
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
                        font.family: customFont.name
                        font.pixelSize: 18
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
                    width: 180
                    height: 46
                    placeholderText: "PASSWORD"
                    placeholderTextColor: "#aaffffff"
                    focus: true
                    echoMode: TextInput.Password
                    font.family: customFont.name
                    font.pixelSize: 18
                    color: "#ffffff"
                    font.letterSpacing: 4
                    horizontalAlignment: TextInput.AlignHCenter
                    background: Rectangle {
                        color: "#33000000"
                        radius: 8
                        border.color: p.activeFocus ? "#ffffff" : "#ffb7c5"
                        border.width: 2
                    }
                    onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
                }
            }
        }
    }

    // Minimalist Power Controls
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
                color: "#ffffff"
                font.family: customFont.name
                font.pixelSize: 14
                font.letterSpacing: 2
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
            }
            delegate: ItemDelegate {
                id: optionDelegate1

                width: sessionCombo.width
                height: 36
                background: Rectangle {
                    color: optionDelegate1.hovered ? "#ffb7c5" : "#111"
                }
                contentItem: Text {
                    text: model.name
                    color: "#ffffff"
                    font.family: customFont.name
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Text {
            text: "RESTART"
            color: "#ffffff"
            font.family: customFont.name
            font.pixelSize: 14
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ffb7c5";
                }
                onExited: {
                    parent.color = "#ffffff";
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
            color: "#ffffff"
            font.family: customFont.name
            font.pixelSize: 14
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ffb7c5";
                }
                onExited: {
                    parent.color = "#ffffff";
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
            color: "#ffb7c5"
            style: Text.Outline
            styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ffb7c5"
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
