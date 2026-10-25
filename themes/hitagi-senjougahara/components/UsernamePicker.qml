import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: picker
    property bool ready: false
    property int horizontalAlignment: Text.AlignLeft
    property var controller
    property color foreground: "#ffffff"
    readonly property real textLuminance: 0.2126 * foreground.r + 0.7152 * foreground.g + 0.0722 * foreground.b
    property color popupSurface: background && background.color !== undefined && background.color.a >= 0.5 ? background.color : (textLuminance > 0.5 ? "#252c35" : "#f5f5f5")
    editable: false
    model: userModel
    textRole: "name"
    currentIndex: -1
    enabled: !controller.busy && count > 0
    Accessible.name: qsTr("Username")
    displayText: count ? currentText : qsTr("No user accounts")
    font.family: "sans-serif"
    font.pixelSize: 20
    leftPadding: 12
    rightPadding: 32
    palette.text: foreground
    palette.buttonText: foreground
    palette.base: popupSurface
    palette.button: popupSurface
    palette.highlightedText: foreground

    function syncSelection() {
        if (!controller)
            return;
        // SDDM's saved account name takes priority over a stale model index.
        var selected = -1;
        for (var i = 0; i < count; ++i) {
            if (textAt(i) === controller.username) {
                selected = i;
                break;
            }
        }
        if (selected < 0 && count)
            selected = userModel.lastIndex >= 0 && userModel.lastIndex < count ? userModel.lastIndex : 0;
        currentIndex = selected;
        if (controller.username !== currentText)
            controller.username = currentText;
    }

    onActivated: controller.username = currentText
    onCountChanged: {
        if (ready)
            Qt.callLater(syncSelection);
    }
    Component.onCompleted: {
        ready = true;
        Qt.callLater(syncSelection);
    }

    Connections {
        target: picker.controller
        function onUsernameChanged() {
            if (picker.ready)
                Qt.callLater(picker.syncSelection);
        }
    }

    contentItem: Text {
        text: picker.displayText
        font: picker.font
        color: picker.foreground
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: picker.horizontalAlignment
        elide: Text.ElideRight
    }
    indicator: Text {
        x: picker.width - width - 10
        anchors.verticalCenter: parent.verticalCenter
        text: "▾"
        color: picker.foreground
        font.pixelSize: 18
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: picker.foreground
        border.width: picker.background && picker.background.color !== undefined && picker.background.color.a > 0.5 ? 2 : 0
        radius: picker.background && picker.background.radius !== undefined ? picker.background.radius : 0
        visible: picker.activeFocus && (picker.focusReason === Qt.TabFocusReason || picker.focusReason === Qt.BacktabFocusReason || picker.focusReason === Qt.ShortcutFocusReason)
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 2
            color: picker.foreground
            visible: parent.border.width === 0
        }
    }

    delegate: ItemDelegate {
        width: picker.width
        height: 44
        text: model.name
        font: picker.font
        highlighted: picker.highlightedIndex === index
        palette.text: picker.foreground
        background: Rectangle {
            color: parent.highlighted ? Qt.lighter(picker.popupSurface, 1.3) : picker.popupSurface
            border.color: parent.highlighted ? picker.foreground : "transparent"
        }
    }
}
