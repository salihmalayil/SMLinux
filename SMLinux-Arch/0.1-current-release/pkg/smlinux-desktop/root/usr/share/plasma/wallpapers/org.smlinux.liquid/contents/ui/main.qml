// KDE Plasma wallpaper plugin: SMLinux Liquid Dawn (live)
import QtQuick
import org.kde.plasma.plasmoid

WallpaperItem {
    id: wallpaper

    LiquidScene {
        anchors.fill: parent
        paused:  wallpaper.configuration.Paused
        speed:   wallpaper.configuration.Speed
        quality: wallpaper.configuration.Quality
    }
}
