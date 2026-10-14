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
    font.family: "sans-serif"
    font.pixelSize: 16

    contentItem: Text {
        text: picker.currentText
        color: "#ffffff"
        font: picker.font
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        leftPadding: 12
        rightPadding: 24
    }

    indicator: Text {
        x: picker.width - 22
        anchors.verticalCenter: parent.verticalCenter
        text: "▾"
        color: "#ffffff"
        font.pixelSize: 16
    }

    background: Rectangle {
        color: "#252c34"
        radius: 4
        border.color: picker.activeFocus ? "#ffffff" : "#56616b"
        border.width: picker.activeFocus ? 2 : 1
    }

    delegate: ItemDelegate {
        width: picker.width
        height: 44
        text: model.name
        font: picker.font
        highlighted: picker.highlightedIndex === index
        palette.text: "#ffffff"

        background: Rectangle {
            color: parent.highlighted ? "#47525d" : "#252c34"
        }

    }

}
