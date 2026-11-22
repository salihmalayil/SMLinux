#include "AppLauncher.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QHash>
#include <QProcess>
#include <QRegularExpression>
#include <QSet>
#include <QStandardPaths>
#include <QStringList>
#include <QTextStream>
#include <QVariantMap>

namespace {

// Each tile lists candidate programs; the first one installed is used.
const QHash<QString, QStringList> &tiles()
{
    static const QHash<QString, QStringList> map = {
        {QStringLiteral("files"),     {QStringLiteral("nautilus")}},
        {QStringLiteral("browser"),   {QStringLiteral("firefox")}},
        {QStringLiteral("terminal"),  {QStringLiteral("kgx"), QStringLiteral("gnome-terminal")}},
        {QStringLiteral("settings"),  {QStringLiteral("gnome-control-center")}},
        {QStringLiteral("settings-network"), {QStringLiteral("gnome-control-center network")}},
        {QStringLiteral("settings-sound"),   {QStringLiteral("gnome-control-center sound")}},
        {QStringLiteral("settings-display"), {QStringLiteral("gnome-control-center display")}},
        {QStringLiteral("settings-power"),   {QStringLiteral("gnome-control-center power")}},
        {QStringLiteral("store"),     {QStringLiteral("gnome-software"), QStringLiteral("snap-store")}},
        {QStringLiteral("monitor"),   {QStringLiteral("gnome-system-monitor")}},
        {QStringLiteral("updates"),   {QStringLiteral("update-manager"), QStringLiteral("gnome-software")}},
        {QStringLiteral("share"),     {QStringLiteral("gnome-user-share")}},
        {QStringLiteral("windows"),   {QStringLiteral("winecfg"), QStringLiteral("bottles")}},
        {QStringLiteral("recovery"),  {QStringLiteral("timeshift-launcher"), QStringLiteral("timeshift-gtk")}},
        // Ubuntu's installer has changed name and location between releases
        {QStringLiteral("installer"), {QStringLiteral("ubuntu-desktop-bootstrap"),
                                       QStringLiteral("/snap/bin/ubuntu-desktop-bootstrap"),
                                       QStringLiteral("ubuntu-desktop-installer"),
                                       QStringLiteral("/snap/bin/ubuntu-desktop-installer"),
                                       QStringLiteral("ubiquity"),
                                       QStringLiteral("calamares")}},
    };
    return map;
}

QStringList applicationDirs()
{
    QStringList dirs = QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation);
    dirs << QStringLiteral("/var/lib/flatpak/exports/share/applications")
         << QDir::homePath() + QStringLiteral("/.local/share/flatpak/exports/share/applications")
         << QStringLiteral("/var/lib/snapd/desktop/applications");
    dirs.removeDuplicates();
    return dirs;
}

// Minimal .desktop parser: the [Desktop Entry] group only.
QHash<QString, QString> readDesktopEntry(const QString &path)
{
    QHash<QString, QString> entry;
    QFile f(path);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return entry;
    QTextStream in(&f);
    bool inEntry = false;
    while (!in.atEnd()) {
        const QString line = in.readLine().trimmed();
        if (line.startsWith(QLatin1Char('['))) {
            inEntry = (line == QLatin1String("[Desktop Entry]"));
            continue;
        }
        if (!inEntry || line.isEmpty() || line.startsWith(QLatin1Char('#')))
            continue;
        const int eq = line.indexOf(QLatin1Char('='));
        if (eq > 0)
            entry.insert(line.left(eq).trimmed(), line.mid(eq + 1).trimmed());
    }
    return entry;
}

} // namespace

QString AppLauncher::resolve(const QString &appId) const
{
    // Returns the full command line of the first installed candidate, or "".
    const auto it = tiles().constFind(appId);
    if (it == tiles().cend())
        return {};
    for (const QString &candidate : *it) {
        const QStringList parts = QProcess::splitCommand(candidate);
        if (parts.isEmpty())
            continue;
        const QString &program = parts.first();
        const bool installed = program.startsWith(QLatin1Char('/'))
            ? QFile::exists(program)
            : !QStandardPaths::findExecutable(program).isEmpty();
        if (installed)
            return candidate;
    }
    return {};
}

bool AppLauncher::available(const QString &appId) const
{
    return !resolve(appId).isEmpty();
}

bool AppLauncher::launch(const QString &appId)
{
    QStringList args = QProcess::splitCommand(resolve(appId));
    if (args.isEmpty())
        return false;
    const QString program = args.takeFirst();
    return QProcess::startDetached(program, args);
}

bool AppLauncher::isOnline() const
{
    QDir net(QStringLiteral("/sys/class/net"));
    const QStringList ifaces = net.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString &iface : ifaces) {
        if (iface == QLatin1String("lo"))
            continue;
        QFile state(net.filePath(iface + QStringLiteral("/operstate")));
        QFile carrier(net.filePath(iface + QStringLiteral("/carrier")));
        if (state.open(QIODevice::ReadOnly) && state.readAll().trimmed() == "up"
            && carrier.open(QIODevice::ReadOnly) && carrier.readAll().trimmed() == "1")
            return true;
    }
    return false;
}

QVariantList AppLauncher::searchApps(const QString &query, int limit) const
{
    QVariantList results;
    const QString q = query.trimmed();
    if (q.isEmpty())
        return results;

    QSet<QString> seen;   // the same app can exist in several directories
    QVariantList prefixMatches, otherMatches;
    for (const QString &dir : applicationDirs()) {
        QDirIterator it(dir, {QStringLiteral("*.desktop")}, QDir::Files, QDirIterator::Subdirectories);
        while (it.hasNext()) {
            const QString path = it.next();
            const QString id = QFileInfo(path).fileName();
            if (seen.contains(id))
                continue;
            seen.insert(id);

            const auto e = readDesktopEntry(path);
            if (e.value(QStringLiteral("Type")) != QLatin1String("Application")
                || e.value(QStringLiteral("NoDisplay")) == QLatin1String("true")
                || e.value(QStringLiteral("Hidden")) == QLatin1String("true")
                || e.value(QStringLiteral("Exec")).isEmpty())
                continue;

            const QString name = e.value(QStringLiteral("Name"));
            const QString haystack = name + QLatin1Char(' ')
                + e.value(QStringLiteral("GenericName")) + QLatin1Char(' ')
                + e.value(QStringLiteral("Keywords")) + QLatin1Char(' ')
                + e.value(QStringLiteral("Comment"));
            if (!haystack.contains(q, Qt::CaseInsensitive))
                continue;

            QVariantMap app;
            app.insert(QStringLiteral("name"), name);
            app.insert(QStringLiteral("comment"), e.value(QStringLiteral("Comment")));
            app.insert(QStringLiteral("icon"), e.value(QStringLiteral("Icon")));
            app.insert(QStringLiteral("file"), path);
            (name.startsWith(q, Qt::CaseInsensitive) ? prefixMatches : otherMatches).append(app);
        }
    }
    results = prefixMatches + otherMatches;     // names starting with the query first
    if (limit > 0 && results.size() > limit)
        results = results.mid(0, limit);
    return results;
}

bool AppLauncher::launchDesktopFile(const QString &path)
{
    // Prefer GLib's launcher (handles all .desktop features), else parse Exec ourselves
    const QString gio = QStandardPaths::findExecutable(QStringLiteral("gio"));
    if (!gio.isEmpty())
        return QProcess::startDetached(gio, {QStringLiteral("launch"), path});

    QString exec = readDesktopEntry(path).value(QStringLiteral("Exec"));
    exec.remove(QRegularExpression(QStringLiteral("%[fFuUdDnNickvm]")));   // field codes
    QStringList args = QProcess::splitCommand(exec);
    if (args.isEmpty())
        return false;
    const QString program = args.takeFirst();
    return QProcess::startDetached(program, args);
}
