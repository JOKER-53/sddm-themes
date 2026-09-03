import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#000"

    property color neonPink: config.neonPink || "#ff2a6d"
    property color neonCyan: config.neonCyan || "#05d9e8"

    AnimatedImage {
        id: bg
        anchors.fill: parent
        source: "assets/wallpaper.gif"
        fillMode: Image.PreserveAspectCrop
        playing: true
    }

    // Vignette overlay
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: root.neonCyan
        border.width: 1
        opacity: 0.15
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa000000" }
            GradientStop { position: 0.5; color: "#00000000" }
            GradientStop { position: 1.0; color: "#dd000000" }
        }
    }

    // High-tech slanted HUD container
    Rectangle {
        anchors.bottom: parent.bottom; anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        width: 700; height: 280
        color: "#88000000"
        border.color: root.neonPink
        border.width: 2
        radius: 8

        // Glowing border effect
        Rectangle {
            anchors.fill: parent; anchors.margins: -4
            color: "transparent"; border.color: root.neonPink; border.width: 1
            opacity: 0.5; radius: 10
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
                    font.family: "Monospace"; font.pixelSize: 14; font.letterSpacing: 4
                }
                Text {
                    id: clockText
                    text: Qt.formatDateTime(new Date(), "HH:mm")
                    color: "#fff"
                    font.family: "Impact"; font.pixelSize: 80; font.letterSpacing: 4
                    style: Text.Outline; styleColor: root.neonPink
                }
                Text {
                    id: dateText
                    text: Qt.formatDateTime(new Date(), "yyyy-MM-dd")
                    color: root.neonCyan
                    font.family: "Monospace"; font.pixelSize: 16; font.letterSpacing: 2
                }
            }

            Rectangle { width: 2; height: parent.height; color: root.neonPink; opacity: 0.5 }

            // Right side: Inputs
            Column {
                width: 300
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                // USERNAME DROPDOWN
                ComboBox {
                    id: userCombo
                    width: parent.width; height: 44
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex

                    background: Rectangle {
                        color: "#33000000"
                        border.color: root.neonCyan; border.width: 1
                    }
                    contentItem: Text {
                        text: userCombo.currentText + " ▾"
                        color: root.neonCyan
                        font.family: "Monospace"; font.pixelSize: 16; font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left; anchors.leftMargin: 12
                    }
                    delegate: ItemDelegate {
                        width: userCombo.width; height: 40
                        contentItem: Text {
                            text: model.name
                            color: root.neonCyan
                            font.family: "Monospace"; font.pixelSize: 16
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.hovered ? "#3305d9e8" : "#cc000000"
                            border.color: root.neonCyan; border.width: parent.hovered ? 1 : 0
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
                            ScrollIndicator.vertical: ScrollIndicator { }
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
                    width: parent.width; height: 44
                    placeholderText: "PASSWORD"
                    echoMode: TextInput.Password
                    color: "#fff"
                    font.family: "Monospace"; font.pixelSize: 16; font.letterSpacing: 4
                    background: Rectangle {
                        color: "#33000000"
                        border.color: root.neonPink; border.width: 1
                    }
                    onAccepted: sddm.login(userCombo.currentText, passField.text, sessionModel.lastIndex)
                }

                // LOGIN BUTTON
                Rectangle {
                    width: parent.width; height: 44
                    color: root.neonPink
                    Text {
                        anchors.centerIn: parent
                        text: "INITIALIZE //"
                        color: "#000"
                        font.family: "Impact"; font.pixelSize: 20; font.letterSpacing: 2
                    }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: sddm.login(userCombo.currentText, passField.text, sessionModel.lastIndex)
                    }
                }
            }
        }
    }

    // Power Options
    Row {
        anchors.top: parent.top; anchors.right: parent.right
        anchors.margins: 30; spacing: 20
        Repeater {
            model: [{l:"SYS.SHUTDOWN", fn:function(){sddm.powerOff()}}, {l:"SYS.REBOOT", fn:function(){sddm.reboot()}}]
            delegate: Text {
                text: modelData.l; color: root.neonCyan
                font.family: "Monospace"; font.pixelSize: 12; font.letterSpacing: 2
                MouseArea {
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onEntered: parent.color = "#fff"
                    onExited: parent.color = root.neonCyan
                    onClicked: modelData.fn()
                }
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
            dateText.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd")
        }
    }

    Connections { target: sddm; function onLoginFailed() { passField.text = "" } }
    Component.onCompleted: passField.forceActiveFocus()
}
