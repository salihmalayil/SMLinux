// Hyprland live wallpaper: shows LiquidScene on the Wayland background layer.
// Started by smlinux-wallpaper with QT_WAYLAND_SHELL_INTEGRATION=layer-shell.
import QtQuick
import QtQuick.Window
import org.kde.layershell 1.0 as LayerShell

Window {
    visible: true
    color: "#0E1628"
    title: "smlinux-wallpaper"

    LayerShell.Window.scope: "smlinux-wallpaper"
    LayerShell.Window.layer: LayerShell.Window.LayerBackground
    LayerShell.Window.anchors: LayerShell.Window.AnchorTop | LayerShell.Window.AnchorBottom
                             | LayerShell.Window.AnchorLeft | LayerShell.Window.AnchorRight
    LayerShell.Window.exclusionZone: -1
    LayerShell.Window.keyboardInteractivity: LayerShell.Window.KeyboardInteractivityNone

    Loader {
        anchors.fill: parent
        source: "file:///usr/share/plasma/wallpapers/org.smlinux.liquid/contents/ui/LiquidScene.qml"
    }
}
