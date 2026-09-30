import QtQuick 2.15

Rectangle {
    property var controller
    visible: controller.errorMessage.length > 0 || controller.busy
    width: Math.min(parent.width - 32, 600)
    height: message.implicitHeight + 24
    radius: 8
    color: "#ed171717"
    border.color: controller.errorMessage.length ? "#ff7272" : "#ffffff"
    z: 1000
    Text {
        id: message
        anchors.fill: parent
        anchors.margins: 12
        text: controller.errorMessage || qsTr("Signing in…")
        color: "#ffffff"
        font.pixelSize: 18
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        Accessible.role: Accessible.AlertMessage
        Accessible.name: text
    }
}
