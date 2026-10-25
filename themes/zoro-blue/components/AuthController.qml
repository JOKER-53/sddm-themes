import QtQuick 2.15

QtObject {
    id: controller
    objectName: "authController"
    property var passwordField
    property var previousPasswordField
    property string username: userModel.lastUser || ""
    onUsernameChanged: {
        dismissError();
        if (passwordField)
            passwordField.text = "";
    }
    property bool rejected: false

    function dismissError() {
        if (!busy) {
            errorMessage = "";
            rejected = false;
        }
    }
    onPasswordFieldChanged: {
        if (previousPasswordField)
            previousPasswordField.text = "";
        if (passwordField) {
            passwordField.text = "";
            Qt.callLater(focusPassword);
        }
        previousPasswordField = passwordField;
    }

    function focusPassword() {
        if (passwordField && !busy)
            passwordField.forceActiveFocus();
    }

    property bool busy: false
    property string errorMessage: ""
    property int sessionIndex: sessionModel.lastIndex >= 0 && sessionModel.lastIndex < sessionModel.count ? sessionModel.lastIndex : (sessionModel.count ? 0 : -1)

    function login(username, password, index) {
        if (busy)
            return;
        errorMessage = "";
        rejected = false;
        if (!username || !username.trim()) {
            errorMessage = qsTr("Enter a username to continue.");
            return;
        }
        if (index < 0 || index >= sessionModel.count || index !== Math.floor(index)) {
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
            controller.rejected = true;
            controller.errorMessage = qsTr("Login failed. Check your username and password.");
            if (controller.passwordField) {
                controller.passwordField.text = "";
                controller.passwordField.forceActiveFocus();
            }
        }
        function onLoginSucceeded() {
            controller.errorMessage = "";
            controller.rejected = false;
            if (controller.passwordField)
                controller.passwordField.text = "";
        }
    }
}
