#include <QGuiApplication>
#include <QColor>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QDir>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQuickRenderControl>
#include <QElapsedTimer>
#include <QThread>
#include <QSettings>
#include <QImage>
#include <QTest>
#include <iostream>

// A real QML engine with fake SDDM models; never contacts PAM or the daemon.
static QObject *makeObject(QQmlEngine &engine, const QByteArray &source) {
    QQmlComponent component(&engine);
    component.setData(source, QUrl());
    QObject *object = component.create();
    if (!object) std::cerr << component.errorString().toStdString();
    return object;
}

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    if (argc < 2) return 2;
    const bool render = argc > 2;
    const QDir output(render ? argv[2] : "/tmp");
    if (render) QDir().mkpath(output.absolutePath());
    const QDir repo(argv[1]);
    QQmlEngine engine;
    QObject *proxy = makeObject(engine, R"(
import QtQuick 2.15
QtObject {
    signal loginFailed()
    signal loginSucceeded()
    property int loginCalls: 0
    property string submittedUser: ""
    property string submittedPassword: ""
    property int submittedSession: -1
    function login(user, password, index) {
        loginCalls++;
        submittedUser = user;
        submittedPassword = password;
        submittedSession = index;
    }
    function powerOff() {}
    function reboot() {}
    function suspend() {}
})");
    QObject *users = makeObject(engine, R"(
import QtQuick 2.15
ListModel {
    property int lastIndex: -1
    property string lastUser: ""
    ListElement { name: "alice"; realName: "Alice" }
    ListElement { name: "bob"; realName: "Bob" }
})");
    QObject *sessions = makeObject(engine, R"(
import QtQuick 2.15
ListModel {
    property int lastIndex: -1
    ListElement { name: "Plasma" }
    ListElement { name: "Hyprland" }
})");
    if (!proxy || !users || !sessions) return 1;
    engine.rootContext()->setContextProperty("sddm", proxy);
    engine.rootContext()->setContextProperty("userModel", users);
    engine.rootContext()->setContextProperty("sessionModel", sessions);
    QFile catalog(repo.filePath("theme-catalog.json"));
    if (!catalog.open(QIODevice::ReadOnly)) return 1;
    int failures = 0, count = 0;
    for (const auto &entry : QJsonDocument::fromJson(catalog.readAll()).object()["themes"].toArray()) {
        const auto theme = entry.toObject();
        const QString id = theme["id"].toString();
        QVariantMap settings;
        QSettings conf(repo.filePath("themes/" + id + "/theme.conf"), QSettings::IniFormat);
        settings["accent"] = render ? conf.value("accent").toString() : "#123456";
        settings["background"] = theme["thumbnail"].toString();
        engine.rootContext()->setContextProperty("config", settings);
        QQmlComponent component(&engine, QUrl::fromLocalFile(repo.filePath("themes/" + id + "/Main.qml")));
        QObject *object = component.create();
        ++count;
        if (!object) {
            std::cerr << id.toStdString() << ": " << component.errorString().toStdString();
            ++failures;
            continue;
        }
        if (object->property("themeAccent").value<QColor>() != QColor(settings["accent"].toString())) {
            std::cerr << id.toStdString() << ": accent setting ignored\n";
            ++failures;
        }
        QObject *auth = object->findChild<QObject *>("authController");
        if (render) {
            QQuickWindow window;
            auto *root = qobject_cast<QQuickItem *>(object);
            if (!root) return 1;
            root->setParentItem(window.contentItem());
            const QList<QSize> sizes = {QSize(1920,1080), QSize(1366,768), QSize(1024,768), QSize(800,600), QSize(3440,1440)};
            for (const QSize &size : sizes) {
                window.resize(size);
                root->setWidth(size.width()); root->setHeight(size.height());
                window.show();
                QElapsedTimer timer; timer.start();
                while (timer.elapsed() < 120) { app.processEvents(); QThread::msleep(5); }
                const QRectF screen(0, 0, size.width(), size.height());
                QList<QQuickItem *> controls;
                auto *password = qobject_cast<QQuickItem *>(auth->property("passwordField").value<QObject *>());
                if (password) controls.append(password);
                for (auto *item : root->findChildren<QQuickItem *>()) {
                    if (item->isVisible() && (item->objectName() == "usernameField" || item->objectName() == "loginButton" || item->objectName() == "systemBar")) controls.append(item);
                }
                bool loginFound = false;
                QRectF footer;
                for (auto *item : controls) if (item->objectName() == "systemBar") footer = item->mapRectToScene(QRectF(0,0,item->width(),item->height()));
                for (auto *item : controls) {
                    const QRectF rect = item->mapRectToScene(QRectF(0,0,item->width(),item->height()));
                    if (item->objectName() == "loginButton") loginFound = true;
                    if (!item->isVisible() || rect.width() < 16 || rect.height() < 16 || !screen.adjusted(-1,-1,1,1).contains(rect)) {
                        std::cerr << id.toStdString() << " " << size.width() << "x" << size.height() << ": clipped/hidden " << item->objectName().toStdString() << " at " << rect.x() << "," << rect.y() << " " << rect.width() << "x" << rect.height() << "\n"; ++failures;
                    }
                    if (item->objectName() != "systemBar" && rect.intersects(footer)) {
                        std::cerr << id.toStdString() << ": control overlaps footer\n"; ++failures;
                    }
                }
                if (!loginFound) { std::cerr << id.toStdString() << ": no visible login button\n"; ++failures; }
                // Exercise actual mouse and keyboard events, including session selection.
                QQuickItem *button = nullptr;
                for (auto *item : controls) if (item->objectName() == "loginButton") { button = item; break; }
                if (button && password) {
                    auth->setProperty("sessionIndex", 1);
                    password->setProperty("text", "layout-check");
                    int calls = proxy->property("loginCalls").toInt();
                    const QPoint point = button->mapToScene(QPointF(button->width()/2, button->height()/2)).toPoint();
                    QTest::mouseClick(&window, Qt::LeftButton, Qt::NoModifier, point);
                    app.processEvents();
                    if (proxy->property("loginCalls").toInt() != calls + 1 || proxy->property("submittedUser").toString() != "alice" || proxy->property("submittedPassword").toString() != "layout-check" || proxy->property("submittedSession").toInt() != 1) {
                        std::cerr << id.toStdString() << " " << size.width() << ": click did not submit the visible form/session\n"; ++failures;
                    }
                    QMetaObject::invokeMethod(proxy, "loginFailed");
                    if (!password->property("text").toString().isEmpty() || !password->hasActiveFocus()) {
                        std::cerr << id.toStdString() << ": visible password was not cleared/refocused\n"; ++failures;
                    }
                    password->setProperty("text", "keyboard-check");
                    calls = proxy->property("loginCalls").toInt();
                    QTest::keyClick(&window, Qt::Key_Return);
                    app.processEvents();
                    if (proxy->property("loginCalls").toInt() != calls + 1) { std::cerr << id.toStdString() << ": Enter did not submit\n"; ++failures; }
                    QMetaObject::invokeMethod(proxy, "loginFailed");
                    auth->setProperty("errorMessage", "");
                }
                QImage shot = window.grabWindow();
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
                // Qt 5's offscreen platform has no backing-store screenshot.
                // Render the same scene explicitly through its software renderer.
                if (shot.isNull()) {
                    QQuickRenderControl renderer;
                    QQuickWindow capture(&renderer);
                    capture.resize(size);
                    root->setParentItem(capture.contentItem());
                    renderer.initialize(nullptr);
                    app.processEvents();
                    renderer.polishItems();
                    renderer.sync();
                    renderer.render();
                    shot = renderer.grab();
                    root->setParentItem(window.contentItem());
                    renderer.invalidate();
                }
#endif
                if (shot.isNull() || !shot.save(output.filePath(id + "-" + QString::number(size.width()) + "x" + QString::number(size.height()) + ".png"))) { std::cerr << "Screenshot failed\n"; ++failures; }
            }
            root->setParentItem(nullptr);
            auth->setProperty("sessionIndex", 0);
        }
        if (!auth || auth->property("sessionIndex").toInt() != 0) {
            std::cerr << id.toStdString() << ": missing controller/session fallback\n";
            ++failures;
        } else {
            QObject *field = auth->property("passwordField").value<QObject *>();
            if (field) field->setProperty("text", "wrong");
            QVariant user("alice"), password("wrong"), index(0);
            QMetaObject::invokeMethod(auth, "login", Q_ARG(QVariant, user), Q_ARG(QVariant, password), Q_ARG(QVariant, index));
            int before = proxy->property("loginCalls").toInt();
            QMetaObject::invokeMethod(auth, "login", Q_ARG(QVariant, user), Q_ARG(QVariant, password), Q_ARG(QVariant, index));
            if (!auth->property("busy").toBool() || proxy->property("loginCalls").toInt() != before) ++failures;
            QMetaObject::invokeMethod(proxy, "loginFailed");
            if (auth->property("busy").toBool() || auth->property("errorMessage").toString().isEmpty()) ++failures;
            if (!field || !field->property("text").toString().isEmpty()) ++failures;
            user = "";
            QMetaObject::invokeMethod(auth, "login", Q_ARG(QVariant, user), Q_ARG(QVariant, password), Q_ARG(QVariant, index));
            if (auth->property("busy").toBool() || proxy->property("loginCalls").toInt() != before) ++failures;
        }
        delete object;
    }
    std::cout << "Qt " << qVersion() << ": instantiated " << count << " themes; failures: " << failures << std::endl;
    delete proxy;
    delete users;
    delete sessions;
    return failures ? 1 : 0;
}
