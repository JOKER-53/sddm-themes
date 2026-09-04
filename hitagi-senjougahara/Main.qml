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

    // Subtle dark gradient from the left to make the panel pop without a harsh box
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top; anchors.bottom: parent.bottom
        width: 800
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#aa000000" }
            GradientStop { position: 0.6; color: "#55000000" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Elegant Shaft-style Vertical Japanese Text
    Column {
        anchors.left: parent.left; anchors.leftMargin: 60
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Text { text: "戦"; color: "#ffffff"; font.pixelSize: 42; font.bold: true; style: Text.Outline; styleColor: "#55000000" }
        Text { text: "場"; color: "#ffffff"; font.pixelSize: 42; font.bold: true; style: Text.Outline; styleColor: "#55000000" }
        Text { text: "ヶ"; color: "#dc143c"; font.pixelSize: 42; font.bold: true; style: Text.Outline; styleColor: "#55000000" } // Crimson accent
        Text { text: "原"; color: "#ffffff"; font.pixelSize: 42; font.bold: true; style: Text.Outline; styleColor: "#55000000" }
    }

    // Main Login Panel (Left side, transparent & elegant)
    Column {
        anchors.left: parent.left; anchors.leftMargin: 160
        anchors.verticalCenter: parent.verticalCenter
        spacing: 35
        
        Text { 
            text: "SENJOUGAHARA"; font.family: customFont.name; font.pixelSize: 48; 
            color: "#ffffff"; font.letterSpacing: 12; font.bold: true
            style: Text.Outline; styleColor: "#44000000"
        }
        
        Rectangle { width: 40; height: 3; color: "#dc143c" } // Small crimson divider

        ComboBox {
            id: u; width: 320; height: 50; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
            background: Rectangle { 
                color: "#22ffffff"; radius: 4; border.color: u.activeFocus ? "#dc143c" : "#55ffffff"; border.width: 1 
            }
            contentItem: Text { 
                text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"; font.letterSpacing: 4
                verticalAlignment: Text.AlignVCenter; anchors.left: parent.left; anchors.leftMargin: 20
            }
            delegate: ItemDelegate {
                width: u.width; height: 40; background: Rectangle { color: parent.hovered ? "#33dc143c" : "#22000000" }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 18; anchors.left: parent.left; anchors.leftMargin: 20; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        TextField {
            id: p; width: 320; height: 50; placeholderText: "P A S S W O R D"
            placeholderTextColor: "#88ffffff"
            echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"; font.letterSpacing: 8
            anchors.leftMargin: 20; padding: 20
            background: Rectangle { 
                color: "#22ffffff"; radius: 4; border.color: p.activeFocus ? "#dc143c" : "#55ffffff"; border.width: 1 
            }
            onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
        }
        
        Rectangle {
            width: 180; height: 46; color: "transparent"; radius: 4; border.color: "#dc143c"; border.width: 2
            Text { anchors.centerIn: parent; text: "UNLOCK"; color: "#dc143c"; font.family: customFont.name; font.pixelSize: 16; font.letterSpacing: 6; font.bold: true }
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#dc143c"; parent.children[0].color = "#ffffff" }
                onExited: { parent.color = "transparent"; parent.children[0].color = "#dc143c" }
                onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
            }
            Behavior on color { ColorAnimation { duration: 250 } }
        }
    }

    // Power Controls (Bottom Left, below the panel)
    Row {
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.margins: 60; spacing: 25; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent" }
            contentItem: Text { text: sessionCombo.currentText; color: "#aaffffff"; font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#33dc143c" : "#111" }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#aaffffff"; font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ffffff" }
                onExited: { parent.color = "#aaffffff" }
                onClicked: sddm.reboot() 
            }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#aaffffff"; font.family: customFont.name; font.pixelSize: 12; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#dc143c" }
                onExited: { parent.color = "#aaffffff" }
                onClicked: sddm.powerOff() 
            }
        }
    }
}
