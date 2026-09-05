import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Rectangle {
    id: root
    width: 1920; height: 1080; color: "#000"
    FontLoader { id: customFont; source: "assets/font.ttf" }
    
    // Background Image
    AnimatedImage { 
        anchors.fill: parent; source: "assets/wallpaper.gif"; 
        fillMode: Image.PreserveAspectCrop; playing: true 
    }
    
    // Sleek bottom panel with a top border only
    Rectangle { 
        anchors.bottom: parent.bottom; width: parent.width; height: 150
        color: "#d9000000" // rgba(0,0,0,0.85)
        
        // Top border line
        Rectangle {
            anchors.top: parent.top; width: parent.width; height: 1; color: "#1c69d4"
        }
        
        Row {
            anchors.centerIn: parent; spacing: 40
            
            // User ComboBox
            ComboBox {
                id: u; width: 250; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { color: "transparent"; border.color: "#1c69d4"; border.width: 2; radius: 25 }
                contentItem: Text { 
                    text: u.currentText; color: "#fff"; font.family: customFont.name; font.pixelSize: 18; 
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40
                    background: Rectangle { color: parent.hovered ? "#1c69d4" : "#000" }
                    contentItem: Text { text: model.name; color: "#fff"; font.family: customFont.name; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            // Password Field
            TextField {
                id: p; width: 300; height: 50; placeholderText: "PIN CODE"
                placeholderTextColor: "#88ffffff"
                focus: true; echoMode: TextInput.Password
                color: "#fff"; font.family: customFont.name; font.pixelSize: 22; horizontalAlignment: TextInput.AlignHCenter; font.letterSpacing: 4
                background: Rectangle { color: "transparent"; border.color: "#1c69d4"; border.width: 2; radius: 25 }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            // Login Button
            Rectangle {
                width: 200; height: 50; color: "#1c69d4"; radius: 25
                Text { 
                    anchors.centerIn: parent; text: "START ENGINE"; color: "#fff"; 
                    font.family: customFont.name; font.pixelSize: 16; font.bold: true 
                }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: parent.color = "#2b7de0"
                    onExited: parent.color = "#1c69d4"
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
            }
        }
    }

    // Top-left power buttons (styled elegantly)
    Row {
        anchors.top: parent.top; anchors.left: parent.left
        anchors.margins: 20; spacing: 15; z: 100
        
        ComboBox {
            id: sessionCombo
            width: 140; height: 32; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "#99000000"; border.color: "#4dffffff"; radius: 6 }
            contentItem: Text { text: sessionCombo.currentText; color: "#fff"; font.family: customFont.name; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 12 }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 32
                background: Rectangle { color: parent.hovered ? "#4dffffff" : "#000" }
                contentItem: Text { text: model.name; color: "#fff"; font.family: customFont.name; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 12 }
            }
        }
        Rectangle {
            width: 100; height: 32; color: "#99000000"; border.color: "#4dffffff"; radius: 6
            Text { anchors.centerIn: parent; text: "REBOOT"; color: "#fff"; font.family: customFont.name; font.pixelSize: 12 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color = "#33ffffff"; onExited: parent.color = "#99000000"; onClicked: sddm.reboot() }
        }
        Rectangle {
            width: 100; height: 32; color: "#99000000"; border.color: "#ff2e63"; radius: 6
            Text { anchors.centerIn: parent; text: "SHUTDOWN"; color: "#ff2e63"; font.family: customFont.name; font.pixelSize: 12 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color = "#33ff2e63"; onExited: parent.color = "#99000000"; onClicked: sddm.powerOff() }
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
            color: "#1c69d4"
            style: Text.Outline; styleColor: "#66000000"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: injectedClockDate
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.family: customFont.name
            font.pixelSize: 24
            color: "#1c69d4"
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
