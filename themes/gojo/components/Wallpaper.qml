import QtQuick 2.15

Item {
    id: wallpaper
    property url source
    property url fallbackSource
    property int fillMode: Image.PreserveAspectCrop
    property bool smooth: true
    property bool cache: false
    property real speed: 1
    readonly property bool animated: /\.gif$/i.test(source.toString())
    readonly property bool video: /\.mp4$/i.test(source.toString())
    implicitWidth: still.implicitWidth
    implicitHeight: still.implicitHeight
    Image {
        id: still
        anchors.fill: parent
        source: wallpaper.video || animation.status === Image.Error ? wallpaper.fallbackSource : wallpaper.source
        fillMode: wallpaper.fillMode
        smooth: wallpaper.smooth
        cache: wallpaper.cache
        visible: !wallpaper.animated || animation.status === Image.Error
    }
    AnimatedImage {
        id: animation
        anchors.fill: parent
        source: wallpaper.animated ? wallpaper.source : ""
        fillMode: wallpaper.fillMode
        smooth: wallpaper.smooth
        playing: wallpaper.animated && visible
        visible: wallpaper.animated && status !== Image.Error
        cache: wallpaper.cache
        Component.onCompleted: {
            if ("speed" in animation)
                animation.speed = Qt.binding(function () {
                    return wallpaper.speed;
                });
        }
    }
}
