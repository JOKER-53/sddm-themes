import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: bar

    property var controller
    readonly property string sessionName: session.currentText

    objectName: "systemBar"
    width: controls.implicitWidth + 24
    height: 60
    radius: 8
    color: "#ed15171b"
    border.color: "#66717a"
    z: 200

    Row {
        id: controls

        anchors.centerIn: parent
        spacing: 6

        SessionPicker {
            id: session

            controller: bar.controller
            width: bar.parent.width < 550 ? 120 : 180
            height: 44
        }

        Repeater {
            model: [qsTr("Restart"), qsTr("Shut down"), qsTr("Sleep")]

            delegate: Button {
                width: bar.parent.width < 550 ? 76 : 100
                height: 44
                text: modelData
                Accessible.name: text
                enabled: !bar.controller.busy && (index === 0 ? sddm.canReboot !== false : index === 1 ? sddm.canPowerOff !== false : sddm.canSuspend !== false)
                onClicked: {
                    if (index === 0)
                        sddm.reboot();
                    else if (index === 1)
                        sddm.powerOff();
                    else
                        sddm.suspend();
                }

                contentItem: Text {
                    text: modelData
                    font.family: "sans-serif"
                    font.pixelSize: bar.parent.width < 550 ? 12 : 14
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.down ? "#47525d" : parent.hovered ? "#333d47" : "#252c34"
                    radius: 4
                    border.color: parent.activeFocus ? "#ffffff" : "#56616b"
                    border.width: parent.activeFocus ? 2 : 1
                    opacity: parent.enabled ? 1 : 0.5
                }

            }

        }

    }

}
