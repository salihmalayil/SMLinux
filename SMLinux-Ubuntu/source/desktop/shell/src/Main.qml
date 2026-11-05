import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true
    visibility: Window.FullScreen
    flags: Qt.FramelessWindowHint
    title: "SMLinux"
    color: "#0a0d13"
    property string activeApp: "Desktop"
    property bool quickOpen: false

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#1b2432" }
            GradientStop { position: 0.55; color: "#101722" }
            GradientStop { position: 1; color: "#080b10" }
        }
    }

    Image {
        anchors.fill: parent
        source: "file:///usr/share/backgrounds/smlinux-wallpaper.svg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.48
        asynchronous: true
    }

    Rectangle {
        id: top
        anchors.top: parent.top
        width: parent.width
        height: 46
        color: "#111925"
        border.color: "#2c394c"
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 20
            Label { text: "◆  SM"; color: "#f2f5fa"; font.pixelSize: 15; font.bold: true }
            Label { text: "Overview"; color: "#b0bdce"; font.pixelSize: 13 }
            Label { text: root.activeApp; color: "#7889a0"; font.pixelSize: 12 }
            Item { Layout.fillWidth: true }
            Label { text: "● Online"; color: "#9ab9a5"; font.pixelSize: 11 }
            Label {
                text: Qt.formatDateTime(new Date(), "ddd, dd MMM") + "   " + Qt.formatDateTime(new Date(), "hh:mm")
                color: "#e6ebf3"
                font.pixelSize: 12
            }
            ToolButton {
                text: "☷"
                onClicked: root.quickOpen = !root.quickOpen
                contentItem: Label { text: parent.text; color: "#e6ebf3"; font.pixelSize: 20 }
            }
        }
    }

    Column {
        anchors.centerIn: parent
        width: Math.min(parent.width - 90, 900)
        spacing: 20
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Good day."
            color: "#f3f6fb"
            font.pixelSize: 43
            font.weight: Font.Light
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "A calmer space to get things done."
            color: "#8e9db2"
            font.pixelSize: 15
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 650)
            height: 54
            radius: 17
            color: "#172130"
            border.color: "#35465d"
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                Label { text: "⌕"; color: "#91a6c3"; font.pixelSize: 23 }
                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Search apps and settings"
                    color: "#edf2fa"
                    placeholderTextColor: "#75869d"
                    background: Item {}
                    onAccepted: {
                        const q = text.toLowerCase()
                        if (q.includes("file")) appLauncher.launch("files")
                        else if (q.includes("web") || q.includes("fire")) appLauncher.launch("browser")
                        else if (q.includes("terminal")) appLauncher.launch("terminal")
                        else if (q.includes("setting")) appLauncher.launch("settings")
                        else if (q.includes("monitor")) appLauncher.launch("monitor")
                        else if (q.includes("store") || q.includes("software")) appLauncher.launch("store")
                        else if (q.includes("update")) appLauncher.launch("updates")
                        else if (q.includes("share")) appLauncher.launch("share")
                        else if (q.includes("wine") || q.includes("windows")) appLauncher.launch("windows")
                        else if (q.includes("recover")) appLauncher.launch("recovery")
                        else if (q.includes("install")) appLauncher.launch("installer")
                        text = ""
                    }
                }
                Label { text: "ENTER"; color: "#71839b"; font.pixelSize: 10 }
            }
        }

        GridLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            rowSpacing: 12
            columnSpacing: 12
            Repeater {
                model: [
                    {t:"Files",s:"Your workspace",i:"▤",id:"files"},
                    {t:"Browser",s:"Explore the web",i:"◉",id:"browser"},
                    {t:"Terminal",s:"Command line",i:"⌘",id:"terminal"},
                    {t:"Settings",s:"Make it yours",i:"⚙",id:"settings"},
                    {t:"Software",s:"Discover apps",i:"▦",id:"store"},
                    {t:"Monitor",s:"System activity",i:"⌁",id:"monitor"},
                    {t:"Updates",s:"Keep SMLinux current",i:"↻",id:"updates"},
                    {t:"Share",s:"Send files nearby",i:"⇧",id:"share"},
                    {t:"Windows Apps",s:"Compatibility tools",i:"▣",id:"windows"},
                    {t:"Recovery",s:"Restore your system",i:"⟲",id:"recovery"},
                    {t:"Install SMLinux",s:"Set up this computer",i:"⬇",id:"installer"}
                ]
                delegate: Rectangle {
                    Layout.preferredWidth: 205
                    Layout.preferredHeight: 82
                    radius: 15
                    color: tile.containsMouse ? "#29394f" : "#172130"
                    border.color: tile.containsMouse ? "#6a83a4" : "#2d3c50"
                    Behavior on color { ColorAnimation { duration: 140 } }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        spacing: 13
                        Rectangle {
                            Layout.preferredWidth: 43
                            Layout.preferredHeight: 43
                            radius: 12
                            color: "#2b3b52"
                            Label {
                                anchors.centerIn: parent
                                text: modelData.i
                                color: "#e7eef8"
                                font.pixelSize: 21
                            }
                        }
                        Column {
                            spacing: 4
                            Label { text: modelData.t; color: "#eef2f8"; font.pixelSize: 13; font.bold: true }
                            Label { text: modelData.s; color: "#8797ac"; font.pixelSize: 10 }
                        }
                    }
                    MouseArea {
                        id: tile
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeApp = modelData.t
                            appLauncher.launch(modelData.id)
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: dock.implicitWidth + 30
        height: 72
        radius: 22
        color: "#171f2c"
        border.color: "#3b4b61"
        Row {
            id: dock
            anchors.centerIn: parent
            spacing: 8
            Repeater {
                model: [
                    {i:"▤",id:"files",n:"Files"},
                    {i:"◉",id:"browser",n:"Browser"},
                    {i:"⌘",id:"terminal",n:"Terminal"},
                    {i:"⚙",id:"settings",n:"Settings"},
                    {i:"▦",id:"store",n:"Software"},
                    {i:"⌁",id:"monitor",n:"Monitor"}
                ]
                delegate: Rectangle {
                    width: 52
                    height: 52
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 15
                    color: dm.containsMouse ? "#40536e" : "#29384e"
                    scale: dm.containsMouse ? 1.12 : 1
                    Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutBack } }
                    Label {
                        anchors.centerIn: parent
                        text: modelData.i
                        color: "#f0f4fa"
                        font.pixelSize: 23
                    }
                    MouseArea {
                        id: dm
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeApp = modelData.n
                            appLauncher.launch(modelData.id)
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.top: top.bottom
        anchors.right: parent.right
        anchors.rightMargin: 18
        width: 270
        height: qc.implicitHeight + 34
        radius: 18
        color: "#1a2433"
        border.color: "#43546c"
        visible: root.quickOpen
        Column {
            id: qc
            anchors.fill: parent
            anchors.margins: 17
            spacing: 12
            Label { text: "Control Center"; color: "#f0f3f8"; font.pixelSize: 15; font.bold: true }
            Label { text: "System controls"; color: "#8e9db2"; font.pixelSize: 11 }
            Repeater {
                model: [
                    "Network · Ubuntu services",
                    "Sound · system audio",
                    "Display · system settings",
                    "Power · balanced"
                ]
                delegate: Rectangle {
                    width: 236
                    height: 38
                    radius: 10
                    color: "#29394e"
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: 11
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData
                        color: "#dbe4f0"
                        font.pixelSize: 11
                    }
                }
            }
            Button { text: "Open Settings"; onClicked: appLauncher.launch("settings") }
        }
    }
}
