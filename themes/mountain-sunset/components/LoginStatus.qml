import QtQuick 2.15

Rectangle {
    id: status
    objectName: "loginStatus"
    property var controller
    property bool compactMode: false
    property Item container: parent
    property color accent: "#ffffff"
    property color surface: "#ed171717"
    property color foreground: "#ffffff"
    property string fontFamily: "sans-serif"
    property string title: ""
    property real cornerRadius: 8
    visible: controller.errorMessage.length > 0 || controller.busy
    width: Math.min(parent.width - 32, compactMode ? 600 : 460)
    height: message.implicitHeight + 28
    radius: cornerRadius
    color: surface
    border.color: accent
    border.width: 2
    z: 1000

    // Keep feedback beside the active form and clear of input, clock and power controls.
    function place() {
        if (!container || !visible)
            return;
        var obstacles = [];
        var form = [];
        function visit(item) {
            if (item === status || !item.visible)
                return;
            var name = item.objectName;
            if (name === "usernameField" || name === "passwordField" || name === "loginButton" || name === "systemBar" || name === "themeClock" || name === "greeterTitle") {
                var a = item.mapToItem(container, 0, 0);
                var b = item.mapToItem(container, item.width, item.height);
                var rect = Qt.rect(a.x - 8, a.y - 8, b.x - a.x + 16, b.y - a.y + 16);
                obstacles.push(rect);
                if (name === "usernameField" || name === "passwordField" || name === "loginButton")
                    form.push(rect);
                return;
            }
            for (var i = 0; i < item.children.length; ++i)
                visit(item.children[i]);
        }
        visit(container);
        function fits(point) {
            if (point.x < 16 || point.y < 12 || point.x + status.width > container.width - 16 || point.y + status.height > container.height - 12)
                return false;
            for (var i = 0; i < obstacles.length; ++i) {
                var r = obstacles[i];
                if (point.x < r.x + r.width && point.x + status.width > r.x && point.y < r.y + r.height && point.y + status.height > r.y)
                    return false;
            }
            return true;
        }
        var candidates = [];
        if (compactMode)
            candidates.push(Qt.point((container.width - width) / 2, 12));
        if (form.length) {
            var left = form[0].x, top = form[0].y;
            var right = left + form[0].width, bottom = top + form[0].height;
            for (var i = 1; i < form.length; ++i) {
                left = Math.min(left, form[i].x);
                top = Math.min(top, form[i].y);
                right = Math.max(right, form[i].x + form[i].width);
                bottom = Math.max(bottom, form[i].y + form[i].height);
            }
            var alignedX = Math.max(16, Math.min(left, container.width - width - 16));
            candidates.push(Qt.point(alignedX, bottom + 8));
            candidates.push(Qt.point(right + 12, top));
            candidates.push(Qt.point(left - width - 12, top));
            candidates.push(Qt.point(alignedX, top - height - 8));
        }
        for (var row = 12; row + height <= container.height - 12; row += 24)
            for (var col = 16; col + width <= container.width - 16; col += 24)
                candidates.push(Qt.point(col, row));
        for (var k = 0; k < candidates.length; ++k) {
            if (fits(candidates[k])) {
                x = candidates[k].x;
                y = candidates[k].y;
                return;
            }
        }
        x = (container.width - width) / 2;
        y = 12;
    }

    onVisibleChanged: placement.restart()
    onHeightChanged: placement.restart()
    onWidthChanged: placement.restart()
    Timer {
        id: placement
        interval: 0
        onTriggered: status.place()
    }
    Connections {
        target: status.container
        function onWidthChanged() {
            placement.restart();
        }
        function onHeightChanged() {
            placement.restart();
        }
    }
    Connections {
        target: status.controller
        function onPasswordFieldChanged() {
            placement.restart();
        }
    }

    Text {
        id: message
        objectName: "loginStatusMessage"
        anchors.centerIn: parent
        width: parent.width - 32
        text: (status.title ? status.title + " · " : "") + (controller.errorMessage || qsTr("Signing in…"))
        color: status.foreground
        font.family: status.fontFamily
        font.pixelSize: 18
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        Accessible.role: Accessible.AlertMessage
        Accessible.name: text
    }
}
