#pragma once

#include <QObject>
#include <QString>

class AppLauncher final : public QObject
{
    Q_OBJECT

public:
    explicit AppLauncher(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE bool launch(const QString &appId);
};
