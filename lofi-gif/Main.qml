import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#000"

    AnimatedImage {
        id: bg
        anchors.fill: parent
        source: "assets/wallpaper.gif"
        fillMode: Image.PreserveAspectCrop
        playing: true
    }

    // chill lofi music player style overlay
    Rectangle {
        anchors.left: parent.left; anchors.bottom: parent.bottom
        anchors.margins: 48
        width: 320; height: 220
        color: "#ccffffff"
        radius: 16
        
        Column {
            anchors.centerIn: parent
            spacing: 16
            
            Text {
                id: clockText
                text: Qt.formatDateTime(new Date(), "hh:mm ap")
                color: "#222"
                font.family: "sans-serif"; font.pixelSize: 36; font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            TextField {
                id: p
                width: 240
                placeholderText: "password..."
                echoMode: TextInput.Password
                color: "#222"; font.family: "sans-serif"; font.pixelSize: 14
                background: Rectangle { color: "#fff"; radius: 8; border.color: "#ddd"; border.width: 1 }
                onAccepted: sddm.login(userModel ? userModel.lastUser : "", p.text, sessionModel.lastIndex)
            }
            
            Row {
                spacing: 24
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: [{l:"⏸ sleep", fn:function(){sddm.suspend()}}, {l:"⏹ power", fn:function(){sddm.powerOff()}}]
                    delegate: Text {
                        text: modelData.l; color: "#666"; font.pixelSize: 12; font.bold: true
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: modelData.fn() }
                    }
                }
            }
        }
    }

    Timer { interval: 1000; running: true; repeat: true; onTriggered: clockText.text = Qt.formatDateTime(new Date(), "hh:mm ap") }
    Connections { target: sddm; function onLoginFailed() { p.text = "" } }
    Component.onCompleted: p.forceActiveFocus()
}
