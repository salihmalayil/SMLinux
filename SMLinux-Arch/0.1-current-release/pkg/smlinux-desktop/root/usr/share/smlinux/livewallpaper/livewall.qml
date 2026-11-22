// Hyprland live wallpaper: one background-layer window per monitor
// (monitors plugged in later get one too). Started by smlinux-wallpaper.
// Pauses while $XDG_RUNTIME_DIR/smlinux-wallpaper-paused contains "1"
// (written by the Hyprland config for fullscreen apps and battery power).
import QtQuick
import QtQuick.Window
import org.kde.layershell 1.0 as LayerShell

Instantiator {
    id: screens
    model: Qt.application.screens

    property bool paused: false
    property string uid: ""

    delegate: Window {
        id: win
        required property var modelData
        screen: modelData
        visible: false            // shown only after the layer-shell settings below are applied
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
            onLoaded: item.paused = Qt.binding(function () { return screens.paused })
        }

        Component.onCompleted: win.visible = true
    }

    // Read the pause flag every 2 seconds
    property Timer poll: Timer {
        interval: 2000; repeat: true; running: true; triggeredOnStart: true
        onTriggered: {
            if (screens.uid === "") {
                // our user id, from /proc/self/status
                const s = new XMLHttpRequest();
                s.open("GET", "file:///proc/self/status", false);
                s.send();
                const m = /\nUid:\s+(\d+)/.exec(s.responseText || "");
                screens.uid = m ? m[1] : "1000";
            }
            const r = new XMLHttpRequest();
            r.open("GET", "file:///run/user/" + screens.uid + "/smlinux-wallpaper-paused", false);
            try { r.send(); screens.paused = (r.responseText || "").trim() === "1"; }
            catch (e) { screens.paused = false; }
        }
    }
}
