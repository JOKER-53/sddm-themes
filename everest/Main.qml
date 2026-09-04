import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    FontLoader { id: customFont; source: "assets/font.ttf" }

    // Subtle dark gradient at the bottom for readability
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.7; color: "transparent" }
            GradientStop { position: 1.0; color: "#aa000000" }
        }
    }

    // Alpine Explorer Dashboard (Login Panel)
    Rectangle {
        anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 80
        width: 420; height: 380
        color: "#22000000" // Extremely subtle dark glass
        radius: 20
        border.color: "#44ffffff"; border.width: 1
        
        // Inner bright border for glassy feel
        Rectangle {
            anchors.fill: parent; anchors.margins: 1; radius: 19
            color: "transparent"; border.color: "#11ffffff"; border.width: 1
        }

        Column {
            anchors.centerIn: parent; spacing: 25
            
            // Elegant Title
            Column {
                spacing: 5; anchors.horizontalCenter: parent.horizontalCenter
                Text { 
                    text: "MT. EVEREST"; font.family: customFont.name; font.pixelSize: 42; 
                    color: "#ffffff"; font.letterSpacing: 8; font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline; styleColor: "#44000000"
                }
                Text { 
                    text: "ELEVATION: 8,848 M"; font.family: "sans-serif"; font.pixelSize: 12; 
                    color: "#aaffffff"; font.letterSpacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            ComboBox {
                id: u; width: 300; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#33ffffff"; border.color: u.activeFocus ? "#fff" : "#88ffffff"; border.width: 1; radius: 25 }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"; font.letterSpacing: 2
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40
                    background: Rectangle { color: parent.hovered ? "#44ffffff" : "#22ffffff"; radius: 20 }
                    contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 300; height: 50
                placeholderText: "ENTER PASSKEY"
                placeholderTextColor: "#aaffffff"
                echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"; font.letterSpacing: 6
                horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle { color: "#33ffffff"; border.color: p.activeFocus ? "#fff" : "#88ffffff"; border.width: 1; radius: 25 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            // Minimalist ASCEND button
            Rectangle {
                width: 180; height: 50; color: "transparent"; radius: 25; border.color: "#ffffff"; border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                Text { anchors.centerIn: parent; text: "ASCEND"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 16; font.letterSpacing: 4; font.bold: true }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { parent.color = "#ffffff"; parent.children[0].color = "#000" }
                    onExited: { parent.color = "transparent"; parent.children[0].color = "#ffffff" }
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }
    }

    // Zen power controls (Bottom Right)
    Row {
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 60; spacing: 20; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#22000000"; radius: 18; border.color: "#88ffffff"; border.width: 1 }
            contentItem: Text { text: sessionCombo.currentText; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#55ffffff" : "#111"; radius: 18 }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Rectangle {
            width: 100; height: 36; color: "#22000000"; radius: 18; border.color: "#88ffffff"; border.width: 1
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffffff"; parent.children[0].color = "#000" }
                onExited: { parent.color = "#22000000"; parent.children[0].color = "#ffffff" }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        
        Rectangle {
            width: 110; height: 36; color: "#22000000"; radius: 18; border.color: "#88ffffff"; border.width: 1
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffffff"; parent.children[0].color = "#000" }
                onExited: { parent.color = "#22000000"; parent.children[0].color = "#ffffff" }
                onClicked: sddm.powerOff() 
            }
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    // Injected Top-Center Clock
    Column {
        anchors.top: parent.top; anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -10; z: 10
        Text {
            id: injectedClockTime
            text: Qt.formatTime(new Date(), "hh:mm")
            font.family: customFont.name
            font.pixelSize: 84
            color: "#ffffff"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#ffffff"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                injectedClockTime.text = Qt.formatTime(new Date(), "hh:mm")
                injectedClockDate.text = Qt.formatDate(new Date(), "dddd, MMMM d")
            }
        }
    }
}
