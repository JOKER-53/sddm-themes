import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button

    property color accent: "#ffffff"
    readonly property real luminance: 0.2126 * accent.r + 0.7152 * accent.g + 0.0722 * accent.b

    height: 48
    text: qsTr("Sign in")
    Accessible.name: text
    font.family: "sans-serif"
    font.pixelSize: 18
    font.bold: true

    contentItem: Text {
        text: button.text
        font: button.font
        color: button.luminance > 0.5 ? "#101010" : "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        color: button.down ? Qt.darker(button.accent, 1.2) : button.accent
        radius: 4
        border.width: button.activeFocus ? 3 : 1
        border.color: button.activeFocus ? "#ffffff" : button.accent
        opacity: button.enabled ? 1 : 0.6
    }

}
