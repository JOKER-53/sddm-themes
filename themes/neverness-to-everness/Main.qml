import QtQuick 2.15
import "components" as Common
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15

Rectangle {
    id: root
    property color themeAccent: config.brand || config.accent || "#e91e63"

    width: 1920
    height: 1080
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
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 0.6
                color: "transparent"
            }
            GradientStop {
                position: 1.0
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
                        color: optionDelegate0.hovered ? "#33ff77a9" : "#dd000000"
                        radius: 20
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
                placeholderText: "PASSWORD"
                placeholderTextColor: "#88ffffff"
                focus: true
                echoMode: TextInput.Password
                font.family: customFont.name
                font.pixelSize: 18
                color: "#ffffff"
                font.letterSpacing: 6
                horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle {
                    color: "#44000000"
                    radius: 23
                    border.color: p.activeFocus ? "#ff77a9" : "transparent"
                    border.width: 1
                }
                onAccepted: auth.login(u.currentText, p.text, sessionCombo.currentIndex)
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

    // Power Controls (Bottom Right)
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        spacing: 20
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
                    color: optionDelegate1.hovered ? "#55ffffff" : "#222"
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
            color: "#ffffff"
            font.family: customFont.name
            font.pixelSize: 13
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ff77a9";
                }
                onExited: {
                    parent.color = "#ffffff";
                }
                onClicked: sddm.reboot()
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        Text {
            text: "SHUTDOWN"
            color: "#ffffff"
            font.family: customFont.name
            font.pixelSize: 13
            font.letterSpacing: 2
            Common.ActionArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    parent.color = "#ff77a9";
                }
                onExited: {
                    parent.color = "#ffffff";
                }
                onClicked: sddm.powerOff()
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
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
