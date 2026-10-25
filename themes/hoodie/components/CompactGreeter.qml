import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: compact

    property var controller
    property color accent
    property string title
    property url wallpaperSource
    property url fallbackSource
    property alias passwordField: password
    readonly property string defaultUsername: controller.username

    onVisibleChanged: {
        if (visible)
            password.forceActiveFocus();
    }
    Component.onCompleted: {
        if (visible)
            password.forceActiveFocus();
    }

    Wallpaper {
        anchors.fill: parent
        source: compact.wallpaperSource
        fallbackSource: compact.fallbackSource
    }

    Rectangle {
        anchors.fill: parent
        color: "#66000000"
    }

    Rectangle {
        id: panel

        objectName: "compactPanel"
        width: Math.min(460, parent.width - 40)
        height: Math.min(420, parent.height - 180)
        anchors.horizontalCenter: parent.horizontalCenter
        y: Math.max(72, (parent.height - 100 - height) / 2)
        color: "#f015171b"
        radius: 10
        border.color: compact.accent

        Column {
            anchors.centerIn: parent
            width: parent.width - 48
            spacing: panel.height < 380 ? 12 : 20

            Text {
                width: parent.width
                objectName: "greeterTitle"
                text: compact.title
                font.family: "sans-serif"
                font.pixelSize: 26
                font.bold: true
                color: "#ffffff"
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: Qt.formatTime(new Date(), "hh:mm") + "   " + Qt.formatDate(new Date(), "ddd, MMM d")
                color: "#d4dbe2"
                font.pixelSize: 16

                Timer {
                    interval: 1000
                    running: compact.visible
                    repeat: true
                    onTriggered: parent.text = Qt.formatTime(new Date(), "hh:mm") + "   " + Qt.formatDate(new Date(), "ddd, MMM d")
                }
            }

            UsernamePicker {
                id: user

                objectName: "usernameField"
                width: parent.width
                height: 48
                controller: compact.controller
                foreground: "#ffffff"
                Accessible.name: qsTr("Username")
                font.pixelSize: 18
                palette.text: "#ffffff"
                palette.buttonText: "#ffffff"
                palette.base: "#242c35"
                palette.button: "#242c35"

                indicator: Text {
                    x: user.width - 24
                    anchors.verticalCenter: parent.verticalCenter
                    text: "▾"
                    color: "#ffffff"
                    font.pixelSize: 18
                }

                delegate: ItemDelegate {
                    width: user.width
                    height: 44
                    text: model.name
                    highlighted: user.highlightedIndex === index
                    palette.text: "#ffffff"
                    font.pixelSize: 18

                    background: Rectangle {
                        color: parent.highlighted ? "#47525d" : "#242c35"
                    }
                }

                background: Rectangle {
                    color: "#242c35"
                    border.color: user.activeFocus ? "#ffffff" : "#7e8996"
                    radius: 4
                }
            }

            TextField {
                id: password

                objectName: "passwordField"
                onTextEdited: compact.controller.dismissError()
                Accessible.description: compact.controller.rejected ? compact.controller.errorMessage : ""
                width: parent.width
                height: 48
                placeholderText: qsTr("Password")
                placeholderTextColor: "#c2cbd4"
                color: "#ffffff"
                font.pixelSize: 18
                echoMode: TextInput.Password
                enabled: !compact.controller.busy
                Accessible.name: qsTr("Password")
                onAccepted: submit.clicked()

                background: Rectangle {
                    color: "#242c35"
                    border.color: compact.controller.rejected ? "#ef5c66" : (password.activeFocus ? "#ffffff" : "#7e8996")
                    radius: 4
                }
            }

            LoginSubmit {
                id: submit

                objectName: "loginButton"
                width: parent.width
                accent: compact.accent
                enabled: !compact.controller.busy
                onClicked: compact.controller.login(compact.controller.username, password.text, compact.controller.sessionIndex)
            }
        }
    }
}
