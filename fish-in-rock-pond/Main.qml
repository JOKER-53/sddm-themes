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

    // Jumping Fish Animation 🐟
    Item {
        id: fishContainer
        width: 64; height: 64
        x: 400; y: 700
        z: 50
        opacity: 0

        Text {
            id: fishEmoji
            text: "🐟"
            font.pixelSize: 56
            anchors.centerIn: parent
            rotation: -45
        }

        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            
            // Wait underwater
            PauseAnimation { duration: 3000 }
            
            // Jump!
            ParallelAnimation {
                // X movement (linear arc across the pond)
                NumberAnimation { target: fishContainer; property: "x"; from: 300; to: 1000; duration: 1500 }
                
                // Y movement (arc - jump up then down due to gravity)
                SequentialAnimation {
                    NumberAnimation { target: fishContainer; property: "y"; from: 750; to: 400; duration: 750; easing.type: Easing.OutQuad }
                    NumberAnimation { target: fishContainer; property: "y"; from: 400; to: 800; duration: 750; easing.type: Easing.InQuad }
                }
                
                // Splash rotation
                SequentialAnimation {
                    NumberAnimation { target: fishEmoji; property: "rotation"; from: -60; to: 60; duration: 1500 }
                }

                // Opacity (appear instantly when jumping, disappear when hitting water)
                SequentialAnimation {
                    NumberAnimation { target: fishContainer; property: "opacity"; from: 0; to: 1; duration: 150 }
                    PauseAnimation { duration: 1200 }
                    NumberAnimation { target: fishContainer; property: "opacity"; from: 1; to: 0; duration: 150 }
                }
            }
            
            // Wait again
            PauseAnimation { duration: 5000 }
            
            // Second jump (other direction)
            ParallelAnimation {
                NumberAnimation { target: fishContainer; property: "x"; from: 1300; to: 600; duration: 1600 }
                SequentialAnimation {
                    NumberAnimation { target: fishContainer; property: "y"; from: 800; to: 450; duration: 800; easing.type: Easing.OutQuad }
                    NumberAnimation { target: fishContainer; property: "y"; from: 450; to: 850; duration: 800; easing.type: Easing.InQuad }
                }
                SequentialAnimation {
                    NumberAnimation { target: fishEmoji; property: "rotation"; from: -120; to: -240; duration: 1600 }
                }
                SequentialAnimation {
                    NumberAnimation { target: fishContainer; property: "opacity"; from: 0; to: 1; duration: 150 }
                    PauseAnimation { duration: 1300 }
                    NumberAnimation { target: fishContainer; property: "opacity"; from: 1; to: 0; duration: 150 }
                }
            }
        }
    }

    // Zen UI overlay
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.6; color: "transparent" }
            GradientStop { position: 1.0; color: "#aa001a1a" } // Deep teal overlay at the bottom
        }
    }

    // Main Login Panel (Zen Garden Style)
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 120
        width: 400; height: 360
        color: "#66002b2b" // Dark translucent teal
        radius: 12
        border.color: "#88ff9800"; border.width: 1 // subtle koi orange border
        
        Column {
            anchors.centerIn: parent; spacing: 25
            
            Text { 
                text: "KOI GARDEN"; font.family: customFont.name; font.pixelSize: 32; 
                color: "#ff9800"; font.letterSpacing: 6; font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ComboBox {
                id: u; width: 300; height: 44; model: userModel; textRole: "name"; currentIndex: userModel.lastIndex
                background: Rectangle { 
                    color: "transparent"
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 2; color: u.activeFocus ? "#ff9800" : "#66ffffff" }
                }
                contentItem: Text { 
                    text: u.currentText; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter 
                }
                delegate: ItemDelegate {
                    width: u.width; height: 40
                    background: Rectangle { color: parent.hovered ? "#33ff9800" : "transparent" }
                    contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            
            TextField {
                id: p; width: 300; height: 44; placeholderText: "ENTER PASSCODE"
                placeholderTextColor: "#88ffffff"
                echoMode: TextInput.Password; font.family: customFont.name; font.pixelSize: 20; color: "#ffffff"; font.letterSpacing: 4
                horizontalAlignment: TextInput.AlignHCenter
                background: Rectangle { 
                    color: "transparent"
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 2; color: p.activeFocus ? "#ff9800" : "#66ffffff" }
                }
                onAccepted: sddm.login(u.currentText, p.text, sessionCombo.currentIndex)
            }
            
            Rectangle {
                width: 160; height: 46; color: "transparent"; radius: 23; border.color: "#ff9800"; border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                Text { anchors.centerIn: parent; text: "ENTER"; color: "#ff9800"; font.family: customFont.name; font.pixelSize: 18; font.letterSpacing: 4 }
                MouseArea { 
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onEntered: { parent.color = "#ff9800"; parent.children[0].color = "#000" }
                    onExited: { parent.color = "transparent"; parent.children[0].color = "#ff9800" }
                    onClicked: sddm.login(u.currentText, p.text, sessionCombo.currentIndex) 
                }
                Behavior on color { ColorAnimation { duration: 250 } }
            }
        }
    }

    // Power Controls (Bottom Right)
    Row {
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 50; spacing: 20; z: 100
        
        ComboBox {
            id: sessionCombo; width: 140; height: 36; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex
            background: Rectangle { color: "transparent" }
            contentItem: Text { text: sessionCombo.currentText; color: "#aaffffff"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2; verticalAlignment: Text.AlignVCenter; anchors.right: parent.right }
            delegate: ItemDelegate {
                width: sessionCombo.width; height: 36; background: Rectangle { color: parent.hovered ? "#33ff9800" : "#111" }
                contentItem: Text { text: model.name; color: "#ffffff"; font.family: customFont.name; font.pixelSize: 13; horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter }
            }
        }
        
        Text { 
            text: "RESTART"; color: "#aaffffff"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ff9800"; parent.opacity = 1.0 }
                onExited: { parent.color = "#aaffffff"; parent.opacity = 1.0 }
                onClicked: sddm.reboot() 
            }
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        
        Text { 
            text: "SHUTDOWN"; color: "#aaffffff"; font.family: customFont.name; font.pixelSize: 13; font.letterSpacing: 2
            MouseArea { 
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                onEntered: { parent.color = "#ff3b30"; parent.opacity = 1.0 }
                onExited: { parent.color = "#aaffffff"; parent.opacity = 1.0 }
                onClicked: sddm.powerOff() 
            }
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }
}
