#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>

class AppLauncher final : public QObject
{
    Q_OBJECT

public:
    explicit AppLauncher(QObject *parent = nullptr) : QObject(parent) {}

    // Launch one of the shell's built-in tiles (files, browser, ...).
    Q_INVOKABLE bool launch(const QString &appId);
    // True if the program behind a tile is installed (tiles hide otherwise).
    Q_INVOKABLE bool available(const QString &appId) const;
    // Real network state: any non-loopback interface that is up with a carrier.
    Q_INVOKABLE bool isOnline() const;
    // Search the installed applications (.desktop files): [{name, comment, icon, file}].
    Q_INVOKABLE QVariantList searchApps(const QString &query, int limit = 6) const;
    // Launch an application from its .desktop file.
    Q_INVOKABLE bool launchDesktopFile(const QString &path);

private:
    QString resolve(const QString &appId) const;
};
