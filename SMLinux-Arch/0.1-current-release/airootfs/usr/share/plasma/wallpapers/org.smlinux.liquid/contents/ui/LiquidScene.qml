pragma ComponentBehavior: Bound
// SMLinux "Liquid Dawn" - live version of the wallpaper.
// Shared by the KDE Plasma wallpaper plugin (main.qml) and the Hyprland
// background layer (/usr/share/smlinux/livewallpaper/livewall.qml).
// Everything is driven by one clock `t` that loops 0 → 2π, and every motion uses
// whole-number speeds, so the loop is seamless.
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    property bool running: true
    property real t: 0
    readonly property real sx: width / 1920
    readonly property real sy: height / 1080
    clip: true

    NumberAnimation on t {
        from: 0; to: Math.PI * 2
        duration: 90000
        loops: Animation.Infinite
        running: root.running
    }

    function wob(base, amp, speed, phase) { return base + amp * Math.sin(root.t * speed + phase) }

    // ── Sky ──
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0;  color: "#0E1628" }
            GradientStop { position: 0.55; color: "#14233A" }
            GradientStop { position: 1.0;  color: "#10202E" }
        }
    }

    // ── Glows + aurora band, drawn soft through one blur ──
    Item {
        id: glowLayer
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            // warm light behind the sun
            ShapePath {
                strokeWidth: -1
                fillGradient: RadialGradient {
                    centerX: root.wob(1460, 30, 1, 0) * root.sx
                    centerY: root.wob(300, 20, 2, 1) * root.sy
                    centerRadius: 420 * root.sx
                    focalX: centerX; focalY: centerY
                    GradientStop { position: 0.0; color: "#CCFFB347" }
                    GradientStop { position: 0.5; color: "#66FF7A3D" }
                    GradientStop { position: 1.0; color: "#00FF7A3D" }
                }
                startX: 0; startY: 0
                PathLine { x: root.width; y: 0 }
                PathLine { x: root.width; y: root.height }
                PathLine { x: 0; y: root.height }
            }

            // cool mint light, lower left
            ShapePath {
                strokeWidth: -1
                fillGradient: RadialGradient {
                    centerX: root.wob(320, 60, 1, 2) * root.sx
                    centerY: root.wob(760, 30, 1, 0.5) * root.sy
                    centerRadius: 460 * root.sx
                    focalX: centerX; focalY: centerY
                    GradientStop { position: 0.0; color: "#883DDBA8" }
                    GradientStop { position: 1.0; color: "#003DDBA8" }
                }
                startX: 0; startY: 0
                PathLine { x: root.width; y: 0 }
                PathLine { x: root.width; y: root.height }
                PathLine { x: 0; y: root.height }
            }

            // aurora band: a ribbon between two drifting curves
            ShapePath {
                strokeWidth: -1
                fillGradient: LinearGradient {
                    x1: 0; y1: 0; x2: root.width; y2: 0
                    GradientStop { position: 0.0;  color: "#B03DDBA8" }
                    GradientStop { position: 0.45; color: "#B05EE6D0" }
                    GradientStop { position: 0.7;  color: "#B0FFB347" }
                    GradientStop { position: 1.0;  color: "#B0FF5E5B" }
                }
                startX: -100 * root.sx; startY: root.wob(470, 30, 1, 0) * root.sy
                PathCubic {
                    control1X: 260 * root.sx;  control1Y: root.wob(300, 60, 1, 1) * root.sy
                    control2X: 640 * root.sx;  control2Y: root.wob(600, 60, 2, 2) * root.sy
                    x: 1040 * root.sx;         y: root.wob(420, 45, 1, 3) * root.sy
                }
                PathCubic {
                    control1X: 1400 * root.sx; control1Y: root.wob(260, 60, 1, 4) * root.sy
                    control2X: 1700 * root.sx; control2Y: root.wob(180, 45, 2, 5) * root.sy
                    x: 2020 * root.sx;         y: root.wob(300, 30, 1, 6) * root.sy
                }
                PathLine { x: 2020 * root.sx; y: root.wob(430, 30, 1, 6) * root.sy }
                PathCubic {
                    control1X: 1700 * root.sx; control1Y: root.wob(310, 45, 2, 5) * root.sy
                    control2X: 1400 * root.sx; control2Y: root.wob(390, 60, 1, 4) * root.sy
                    x: 1040 * root.sx;         y: root.wob(545, 45, 1, 3) * root.sy
                }
                PathCubic {
                    control1X: 640 * root.sx;  control1Y: root.wob(720, 60, 2, 2) * root.sy
                    control2X: 260 * root.sx;  control2Y: root.wob(420, 60, 1, 1) * root.sy
                    x: -100 * root.sx;         y: root.wob(590, 30, 1, 0) * root.sy
                }
            }
        }
    }

    MultiEffect {
        source: glowLayer
        anchors.fill: parent
        autoPaddingEnabled: false
        blurEnabled: true
        blur: 1.0
        blurMax: 64
    }

    // ── Sparkles (fade in and out, upper sky) ──
    Repeater {
        model: 42
        Rectangle {
            required property int index
            readonly property real px: ((index * 467) % 1900) + 10
            readonly property real py: ((index * 293) % 600) + 12
            x: px * root.sx; y: py * root.sy
            width: index % 5 === 0 ? 3 : 2
            height: width; radius: width / 2
            color: index % 3 === 0 ? "#FFE3B8" : "#D9FFF4"
            opacity: 0.08 + 0.45 * Math.max(0, Math.sin(root.t * (1 + index % 4) + index * 1.7))
        }
    }

    // ── Sun orb with glass rim ──
    Item {
        id: sun
        width: 236 * root.sx; height: width
        x: root.wob(1460, 30, 1, 0) * root.sx - width / 2
        y: root.wob(300, 20, 2, 1) * root.sy - height / 2
        scale: 1 + 0.03 * Math.sin(root.t * 3)

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFD08A" }
                GradientStop { position: 0.5; color: "#FFB347" }
                GradientStop { position: 1.0; color: "#FF7A3D" }
            }
            border.color: "#59FFFFFF"
            border.width: 1.5
        }
        Rectangle {   // glass highlight
            width: parent.width * 0.32; height: width; radius: width / 2
            x: parent.width * 0.18; y: parent.height * 0.14
            color: "#30FFFFFF"
        }
    }

    // ── Mint moon ──
    Rectangle {
        width: 92 * root.sx; height: width; radius: width / 2
        x: root.wob(430, 14, 1, 3) * root.sx - width / 2
        y: root.wob(250, 10, 1, 1.5) * root.sy - height / 2
        color: "#3DDBA8"
        border.color: "#66FFFFFF"; border.width: 1.2
        Rectangle {
            width: parent.width * 0.3; height: width; radius: width / 2
            x: parent.width * 0.2; y: parent.height * 0.18
            color: "#4DFFFFFF"
        }
    }

    // ── Liquid ribbons (back to front) ──
    component Ribbon: Shape {
        id: rb
        property real t: 0
        property real sx: 1
        property real sy: 1
        property real y0
        property real y1
        property real y2
        property real amp: 28
        property real phase: 0
        property color c1
        property color c2
        property color c3
        property color edge: "#47FFFFFF"
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        readonly property real a0: (y0 + amp * Math.sin(t + phase)) * sy
        readonly property real a1: (y1 + amp * Math.sin(t * 2 + phase + 1.3)) * sy
        readonly property real a2: (y2 + amp * Math.sin(t + phase + 2.6)) * sy
        readonly property real k: 110 * sy

        ShapePath {
            strokeWidth: -1
            fillGradient: LinearGradient {
                x1: 0; y1: 0; x2: rb.width; y2: 0
                GradientStop { position: 0.0; color: rb.c1 }
                GradientStop { position: 0.5; color: rb.c2 }
                GradientStop { position: 1.0; color: rb.c3 }
            }
            startX: 0; startY: rb.a0
            PathCubic { control1X: 320 * rb.sx; control1Y: rb.a0 - rb.k; control2X: 640 * rb.sx; control2Y: rb.a1 + rb.k; x: 980 * rb.sx; y: rb.a1 }
            PathCubic { control1X: 1320 * rb.sx; control1Y: rb.a1 - rb.k; control2X: 1600 * rb.sx; control2Y: rb.a2 - rb.k * 0.3; x: rb.width; y: rb.a2 }
            PathLine { x: rb.width; y: rb.height }
            PathLine { x: 0; y: rb.height }
        }
        ShapePath {   // glassy top edge
            strokeColor: rb.edge
            strokeWidth: 1.5
            fillColor: "transparent"
            startX: 0; startY: rb.a0
            PathCubic { control1X: 320 * rb.sx; control1Y: rb.a0 - rb.k; control2X: 640 * rb.sx; control2Y: rb.a1 + rb.k; x: 980 * rb.sx; y: rb.a1 }
            PathCubic { control1X: 1320 * rb.sx; control1Y: rb.a1 - rb.k; control2X: 1600 * rb.sx; control2Y: rb.a2 - rb.k * 0.3; x: rb.width; y: rb.a2 }
        }
    }

    Ribbon {
        t: root.t; sx: root.sx; sy: root.sy
        y0: 720; y1: 770; y2: 620; amp: 26; phase: 0
        c1: "#EB19B38A"; c2: "#EB3DDBA8"; c3: "#EB2A8FB8"
    }
    Ribbon {
        t: root.t; sx: root.sx; sy: root.sy
        y0: 850; y1: 880; y2: 800; amp: 22; phase: 2.1
        c1: "#F2FF5E5B"; c2: "#F2FF7A3D"; c3: "#F2FFB347"
        edge: "#52FFFFFF"
    }
    Ribbon {
        t: root.t; sx: root.sx; sy: root.sy
        y0: 965; y1: 975; y2: 945; amp: 14; phase: 4.2
        c1: "#13203A"; c2: "#0D1626"; c3: "#080E1A"
        edge: "#595EE6D0"
    }
}
