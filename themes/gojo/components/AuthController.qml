import QtQuick 2.15

QtObject {
    id: controller
    objectName: "authController"
    property var passwordField
    property bool busy: false
    property string errorMessage: ""
    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0

    function login(username, password, index) {
        if (busy)
            return;
        errorMessage = "";
        if (!username || !username.trim()) {
            errorMessage = qsTr("Enter a username to continue.");
            return;
        }
        if (index < 0) {
            errorMessage = qsTr("Choose a desktop session to continue.");
            return;
        }
        busy = true;
        sddm.login(username.trim(), password, index);
    }

    property Connections proxySignals: Connections {
        target: sddm
        function onLoginFailed() {
            controller.busy = false;
            controller.errorMessage = qsTr("Login failed. Check your username and password.");
            if (controller.passwordField) {
                controller.passwordField.text = "";
                controller.passwordField.forceActiveFocus();
            }
        }
        function onLoginSucceeded() {
            controller.errorMessage = "";
        }
    }
}
