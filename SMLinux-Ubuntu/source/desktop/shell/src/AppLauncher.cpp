#include "AppLauncher.h"

#include <QHash>
#include <QProcess>

bool AppLauncher::launch(const QString &appId)
{
    static const QHash<QString, QString> apps = {
        {QStringLiteral("files"), QStringLiteral("nautilus")},
        {QStringLiteral("browser"), QStringLiteral("firefox")},
        {QStringLiteral("terminal"), QStringLiteral("kgx")},
        {QStringLiteral("settings"), QStringLiteral("gnome-control-center")},
        {QStringLiteral("store"), QStringLiteral("gnome-software")},
        {QStringLiteral("monitor"), QStringLiteral("gnome-system-monitor")},
        {QStringLiteral("updates"), QStringLiteral("update-manager")},
        {QStringLiteral("share"), QStringLiteral("gnome-user-share")},
        {QStringLiteral("windows"), QStringLiteral("winecfg")},
        {QStringLiteral("recovery"), QStringLiteral("timeshift-gtk")},
        {QStringLiteral("installer"), QStringLiteral("/snap/bin/ubuntu-desktop-bootstrap")}
    };

    const auto it = apps.constFind(appId);
    if (it == apps.cend())
        return false;

    return QProcess::startDetached(*it, {});
}
