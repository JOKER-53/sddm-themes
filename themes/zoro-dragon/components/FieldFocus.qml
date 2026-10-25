import QtQuick 2.15

Rectangle {
    property var controller: null
    readonly property bool invalid: controller && controller.rejected && parent.echoMode === TextInput.Password
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 2
    color: invalid ? "#ef5c66" : parent.color
    border.color: invalid ? "#ef5c66" : parent.color
    border.width: 0
    radius: 0
    // Mouse clicks already show a text cursor; reserve extra focus chrome for keys.
    visible: invalid || (parent.activeFocus && (parent.focusReason === Qt.TabFocusReason || parent.focusReason === Qt.BacktabFocusReason || parent.focusReason === Qt.ShortcutFocusReason))
    z: 3
}
