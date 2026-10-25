import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: picker

    property color accent: "#ffffff"
    property color surface: "#252c34"
    property color foreground: "#ffffff"
    property real cornerRadius: 4
    flat: false
    objectName: "sessionPicker"
    property var controller

    width: 180
    height: 36
    model: sessionModel
    textRole: "name"
    currentIndex: controller.sessionIndex
    onActivated: controller.sessionIndex = currentIndex
    Accessible.name: qsTr("Desktop session")
    enabled: !controller.busy && count > 0
    font.family: "sans-serif"
    font.pixelSize: 16

    contentItem: Text {
        text: picker.currentText
        color: picker.foreground
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
        color: picker.foreground
        font.pixelSize: 16
    }

    background: Rectangle {
        color: "transparent"
        radius: picker.cornerRadius
        border.color: picker.activeFocus ? picker.foreground : picker.accent
        border.width: picker.activeFocus ? 2 : picker.flat ? 0 : 1
    }

    delegate: ItemDelegate {
        width: picker.width
        height: 44
        text: model.name
        font: picker.font
        highlighted: picker.highlightedIndex === index
        palette.text: picker.foreground

        background: Rectangle {
            color: parent.highlighted ? Qt.tint(picker.surface, Qt.rgba(picker.accent.r, picker.accent.g, picker.accent.b, 0.25)) : picker.surface
        }
    }
}
