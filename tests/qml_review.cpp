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
    if (argc != 2) return 2;
    const QDir repo(argv[1]);
    QQmlEngine engine;
    QObject *proxy = makeObject(engine, R"(
import QtQuick 2.15
QtObject {
    signal loginFailed()
    signal loginSucceeded()
    property int loginCalls: 0
    function login(user, password, index) { loginCalls++; }
    function powerOff() {}
    function reboot() {}
    function suspend() {}
})");
    QObject *users = makeObject(engine, R"(
import QtQuick 2.15
ListModel {
    property int lastIndex: -1
    property string lastUser: "alice"
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
        settings["accent"] = "#123456";
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
        if (object->property("themeAccent").value<QColor>() != QColor("#123456")) {
            std::cerr << id.toStdString() << ": accent setting ignored\n";
            ++failures;
        }
        QObject *auth = object->findChild<QObject *>("authController");
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
