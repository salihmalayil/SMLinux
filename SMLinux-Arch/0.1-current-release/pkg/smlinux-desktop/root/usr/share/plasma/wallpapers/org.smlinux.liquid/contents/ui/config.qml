// Settings page for the SMLinux live wallpaper (right-click desktop →
// Configure Desktop and Wallpaper)
import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_Paused: pausedBox.checked
    property alias cfg_Speed: speedSlider.value
    property int cfg_Quality: 1

    QQC2.CheckBox {
        id: pausedBox
        Kirigami.FormData.label: "Animation:"
        text: "Paused (shows a still frame)"
    }

    Row {
        Kirigami.FormData.label: "Speed:"
        spacing: Kirigami.Units.smallSpacing
        QQC2.Slider {
            id: speedSlider
            from: 0.25; to: 2.0; stepSize: 0.25
        }
        QQC2.Label { text: speedSlider.value.toFixed(2) + "×" }
    }

    QQC2.ComboBox {
        Kirigami.FormData.label: "Quality:"
        model: ["Battery saver (20 fps, softer)", "Full (30 fps)"]
        currentIndex: page.cfg_Quality
        onActivated: index => page.cfg_Quality = index
    }
}
