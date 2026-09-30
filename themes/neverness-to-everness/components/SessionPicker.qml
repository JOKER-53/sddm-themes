import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: picker
    property var controller
    width: 180
    height: 36
    model: sessionModel
    textRole: "name"
    currentIndex: controller.sessionIndex
    onActivated: controller.sessionIndex = currentIndex
    Accessible.name: qsTr("Desktop session")
    enabled: !controller.busy
}
