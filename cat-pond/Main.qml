import QtQuick 2.15
import QtQuick.Controls 2.15


Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    
    AnimatedImage { anchors.fill: parent; source: "assets/wallpaper.gif"; fillMode: Image.PreserveAspectFit; playing: true }
    FontLoader { id: customFont; source: "assets/font.ttf" }


    // Fake Drop shadow
    Rectangle {
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 55
        width: 380; height: 380; color: "#33000000"; radius: 190
    }

    // Main Login Card (Lily Pad inspired)
    Rectangle {
        id: loginCard
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 60
        width: 380; height: 380; color: "#992e7d32"; radius: 190
        border.color: "#a8e6cf"; border.width: 4
        
        // Inner subtle glow
        Rectangle {
            anchors.fill: parent; anchors.margins: 4; radius: 186
            color: "transparent"; border.color: "#33ffffff"; border.width: 2
        }

        Column {
            anchors.centerIn: parent; spacing: 18
            
            Text { 
                text: "CAT POND"; font.family: customFont.name; font.pixelSize: 48; 
                color: "#fff"; font.bold: true; style: Text.Outline; styleColor: "#1b5e20"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text { 
                text: "~ just keep floating ~"; font.family: customFont.name; font.pixelSize: 18; 
                color: "#dcedc1"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            ComboBox {
                id: u; width: 260; height: 48; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "#e8f5e9"; border.color: "#81c784"; border.width: 3; radius: 24 }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 22; color: "#2e7d32"
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40
                    background: Rectangle { color: parent.hovered ? "#c8e6c9" : "#e8f5e9"; radius: 20 }
                    contentItem: Text { text: model.name; color: "#2e7d32"; font.family: customFont.name; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 260; height: 48; placeholderText: "password..."
                placeholderTextColor: "#a5d6a7"
                focus: true; echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 24; color: "#1b5e20"
                horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle { color: "#e8f5e9"; border.color: "#81c784"; border.width: 3; radius: 24 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            Rectangle {
                width: 140; height: 46; color: "#4caf50"; radius: 23; border.color: "#a8e6cf"; border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                Text { anchors.centerIn: parent; text: "DIVE IN"; color: "#fff"; font.family: customFont.name; font.pixelSize: 18 }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: parent.color = "#66bb6a"
                    onExited: parent.color = "#4caf50"
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
            }
        }
    }
    
    // Drop shadow for the lily pad

    // Power Buttons (Floating Bubbles)
    Row {
        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 30; spacing: 20; z: 100
        
        ComboBox {
            id: sessionCombo; width: 130; height: 40; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#66ffffff"; radius: 20; border.color: "#fff"; border.width: 2 }
            contentItem: Text { text: sessionCombo.currentText; color: "#1b5e20"; font.family: customFont.name; font.pixelSize: 16; verticalAlignment: Text.AlignVCenter; anchors.centerIn: parent }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 40
                background: Rectangle { color: parent.hovered ? "#fff" : "#e8f5e9"; radius: 20 }
                contentItem: Text { text: model.name; color: "#1b5e20"; font.family: customFont.name; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Rectangle {
            width: 90; height: 40; color: "#66ffffff"; radius: 20; border.color: "#fff"; border.width: 2
            Text { anchors.centerIn: parent; text: "RESTART"; color: "#1b5e20"; font.family: customFont.name; font.pixelSize: 14 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: parent.color = "#aaffffff"
                onExited: parent.color = "#66ffffff"
                onClicked: sddm.reboot() 
            }
        }
        
        Rectangle {
            width: 100; height: 40; color: "#66ffffff"; radius: 20; border.color: "#ff8a80"; border.width: 2
            Text { anchors.centerIn: parent; text: "SLEEP"; color: "#c62828"; font.family: customFont.name; font.pixelSize: 14 }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#aaff8a80"; parent.border.color = "#c62828" }
                onExited: { parent.color = "#66ffffff"; parent.border.color = "#ff8a80" }
                onClicked: sddm.powerOff() 
            }
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
            color: "#1b5e20"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#1b5e20"
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
