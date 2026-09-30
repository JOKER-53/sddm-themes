import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    anchors.margins: -2
    color: "transparent"
    border.color: parent.color
    border.width: 2
    radius: 3
    visible: parent.activeFocus
    z: 3
}
