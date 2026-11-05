#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "AppLauncher.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("SMLinux");
    app.setOrganizationName("SMLinux Project");

    AppLauncher appLauncher;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appLauncher", &appLauncher);
    engine.loadFromModule("SMLinux", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
