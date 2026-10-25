import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: bar
    property var controller
    property color accent: "#ffffff"
    property color surface: "#ed15171b"
    property color foreground: "#ffffff"
    property real cornerRadius: 8
    property real controlRadius: 4
    property string fontFamily: "sans-serif"
    property string treatment: "panel"
    readonly property string sessionName: session.currentText
    readonly property bool narrow: parent.width < 550
    readonly property bool flat: treatment === "line" || treatment === "stripe"
    objectName: "systemBar"
    width: controls.implicitWidth + 24
    height: 60
    radius: cornerRadius
    color: surface
    border.color: accent
    border.width: flat ? 0 : treatment === "pixel" ? 3 : 1
    z: 200

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: bar.treatment === "stripe" ? 3 : 1
        color: bar.accent
        visible: bar.flat
    }

    Row {
        id: controls
        anchors.centerIn: parent
        spacing: bar.treatment === "pill" ? 8 : 6
        SessionPicker {
            id: session
            controller: bar.controller
            width: bar.narrow ? 120 : 180
            height: 44
            accent: bar.accent
            surface: bar.surface
            foreground: bar.foreground
            cornerRadius: bar.controlRadius
            font.family: bar.fontFamily
            flat: bar.flat
        }
        Repeater {
            model: [qsTr("Restart"), qsTr("Shut down"), qsTr("Sleep")]
            delegate: Button {
                id: action
                objectName: index === 0 ? "rebootButton" : index === 1 ? "shutdownButton" : "suspendButton"
                width: bar.narrow ? 76 : 100
                height: 44
                text: modelData
                Accessible.name: text
                enabled: !bar.controller.busy && (index === 0 ? sddm.canReboot !== false : index === 1 ? sddm.canPowerOff !== false : sddm.canSuspend !== false)
                hoverEnabled: true
                onClicked: {
                    if (index === 0)
                        sddm.reboot();
                    else if (index === 1)
                        sddm.powerOff();
                    else
                        sddm.suspend();
                }
                contentItem: Text {
                    text: action.text
                    font.family: bar.fontFamily
                    font.pixelSize: bar.narrow ? 12 : 14
                    font.bold: bar.treatment === "pixel"
                    color: bar.foreground
                    opacity: action.enabled ? 1 : 0.45
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: action.down ? Qt.tint(bar.surface, Qt.rgba(bar.accent.r, bar.accent.g, bar.accent.b, 0.3)) : action.hovered || action.activeFocus ? Qt.tint(bar.surface, Qt.rgba(bar.accent.r, bar.accent.g, bar.accent.b, 0.15)) : "transparent"
                    radius: bar.controlRadius
                    border.color: action.activeFocus ? bar.foreground : bar.accent
                    border.width: action.activeFocus ? 2 : bar.flat ? 0 : 1
                    opacity: action.enabled ? 1 : 0.45
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: action.activeFocus ? 3 : 1
                        color: action.activeFocus ? bar.foreground : bar.accent
                        visible: bar.flat
                    }
                }
            }
        }
    }
}
