import QtQuick 2.15

MouseArea {
    id: action

    activeFocusOnTab: true
    anchors.margins: -Math.max(0, (44 - parent.height) / 2)
    Accessible.role: Accessible.Button
    Accessible.name: {
        if (parent.text !== undefined)
            return parent.text;

        for (var i = 0; i < parent.children.length; i++) {
            if (parent.children[i].text !== undefined)
                return parent.children[i].text;

        }
        return qsTr("Action");
    }
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            action.clicked(null);
            event.accepted = true;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#ffffff"
        border.width: 2
        visible: action.activeFocus
    }

}
