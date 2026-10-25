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

// Repeater delegates have visual parents that can differ from QObject ownership.
static QQuickItem *findVisual(QQuickItem *root, const QString &name) {
    if (root->objectName() == name) return root;
    for (auto *child : root->childItems())
        if (auto *found = findVisual(child, name)) return found;
    return nullptr;
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
    property bool canReboot: true
    property bool canPowerOff: true
    property bool canSuspend: true
    property int rebootCalls: 0
    property int powerOffCalls: 0
    property int suspendCalls: 0
    function powerOff() { powerOffCalls++; }
    function reboot() { rebootCalls++; }
    function suspend() { suspendCalls++; }
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
        app.processEvents();
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
                if (password) {
                    controls.append(password);
                    if (!password->property("text").toString().isEmpty()) {
                        std::cerr << id.toStdString() << ": password was prefilled\n"; ++failures;
                    }
                }
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
                // Login controls must not cover one another (Deadpool's old overlay).
                for (int i = 0; i < controls.size(); ++i) {
                    if (controls[i]->objectName() == "systemBar") continue;
                    const QRectF first = controls[i]->mapRectToScene(QRectF(0,0,controls[i]->width(),controls[i]->height()));
                    for (int j = i + 1; j < controls.size(); ++j) {
                        if (controls[j]->objectName() == "systemBar") continue;
                        if (first.intersects(controls[j]->mapRectToScene(QRectF(0,0,controls[j]->width(),controls[j]->height())))) {
                            std::cerr << id.toStdString() << ": login controls overlap\n"; ++failures;
                        }
                    }
                }
                if (!loginFound) { std::cerr << id.toStdString() << ": no visible login button\n"; ++failures; }
                // Exercise the themed session dropdown and power controls with fake actions.
                auto *sessionPicker = root->findChild<QQuickItem *>("sessionPicker");
                if (sessionPicker) {
                    sessionPicker->forceActiveFocus();
                    QTest::keyClick(&window, Qt::Key_Space);
                    QTest::keyClick(&window, Qt::Key_End);
                    QTest::keyClick(&window, Qt::Key_Return);
                    app.processEvents();
                    if (auth->property("sessionIndex").toInt() != 1) {
                        std::cerr << id.toStdString() << ": session dropdown failed\n"; ++failures;
                    }
                } else { std::cerr << id.toStdString() << ": session dropdown missing\n"; ++failures; }
                const QStringList powerNames = {"rebootButton", "shutdownButton", "suspendButton"};
                const QStringList counterNames = {"rebootCalls", "powerOffCalls", "suspendCalls"};
                for (int action = 0; action < powerNames.size(); ++action) {
                    auto *item = findVisual(root, powerNames[action]);
                    if (!item || !item->isVisible()) { std::cerr << id.toStdString() << ": power control missing\n"; ++failures; continue; }
                    int before = proxy->property(counterNames[action].toUtf8()).toInt();
                    QTest::mouseClick(&window, Qt::LeftButton, Qt::NoModifier, item->mapToScene(QPointF(item->width()/2,item->height()/2)).toPoint());
                    app.processEvents();
                    if (proxy->property(counterNames[action].toUtf8()).toInt() != before + 1) {
                        std::cerr << id.toStdString() << ": power action failed\n"; ++failures;
                    }
                }
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
                    for (const auto &name : powerNames) {
                        auto *item = findVisual(root, name);
                        if (item && item->isEnabled()) { std::cerr << id.toStdString() << ": power action enabled while signing in\n"; ++failures; }
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
                    auto *status = root->findChild<QQuickItem *>("loginStatus");
                    app.processEvents();
                    if (!status || !status->isVisible() || !screen.contains(status->mapRectToScene(QRectF(0, 0, status->width(), status->height())))) {
                        std::cerr << id.toStdString() << ": failure feedback hidden/clipped\n"; ++failures;
                    }
                    if (status) {
                        const QRectF banner = status->mapRectToScene(QRectF(0, 0, status->width(), status->height()));
                        for (auto *item : root->findChildren<QQuickItem *>()) {
                            if (!item->isVisible()) continue;
                            const QString name = item->objectName();
                            if (name != "usernameField" && name != "passwordField" && name != "loginButton" && name != "systemBar" && name != "themeClock") continue;
                            if (banner.intersects(item->mapRectToScene(QRectF(0, 0, item->width(), item->height())))) {
                                std::cerr << id.toStdString() << " " << size.width() << ": feedback overlaps " << name.toStdString() << "\n"; ++failures;
                            }
                        }
                    }
                    QImage failureShot = window.grabWindow();
                    if (!failureShot.isNull()) failureShot.save(output.filePath(id + "-" + QString::number(size.width()) + "x" + QString::number(size.height()) + "-failure.png"));
                    // Longer localized feedback must remain readable and avoid controls too.
                    auth->setProperty("errorMessage", QString::fromUtf8("Die Anmeldung ist fehlgeschlagen. Überprüfen Sie Ihren Benutzernamen und Ihr Passwort und versuchen Sie es erneut. Bitte beachten Sie die Groß- und Kleinschreibung."));
                    QTest::qWait(10);
                    if (status) {
                        const QRectF banner = status->mapRectToScene(QRectF(0, 0, status->width(), status->height()));
                        if (!screen.contains(banner)) { std::cerr << id.toStdString() << ": long feedback clipped\n"; ++failures; }
                        for (auto *item : controls)
                            if (banner.intersects(item->mapRectToScene(QRectF(0,0,item->width(),item->height())))) {
                                std::cerr << id.toStdString() << ": long feedback overlaps control\n"; ++failures;
                            }
                    }
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
            // Select another account with the actual dropdown, then switch layouts.
            window.resize(1920, 1080); root->setWidth(1920); root->setHeight(1080);
            QTest::qWait(20);
            QQuickItem *username = nullptr;
            for (auto *item : root->findChildren<QQuickItem *>())
                if (item->isVisible() && item->objectName() == "usernameField") { username = item; break; }
            if (username && username->property("editable").isValid() && !username->property("editable").toBool()) {
                auto *accountPassword = auth->property("passwordField").value<QObject *>();
                accountPassword->setProperty("text", "old-account-password");
                username->forceActiveFocus();
                QTest::keyClick(&window, Qt::Key_Space);
                QTest::keyClick(&window, Qt::Key_End);
                QTest::keyClick(&window, Qt::Key_Return);
                app.processEvents();
                if (auth->property("username").toString() != "bob" || !accountPassword->property("text").toString().isEmpty()) {
                    std::cerr << id.toStdString() << ": dropdown did not select bob\n"; ++failures;
                }
                auto *oldPassword = auth->property("passwordField").value<QObject *>();
                oldPassword->setProperty("text", "must-not-survive-resize");
                window.resize(800,600); root->setWidth(800); root->setHeight(600);
                QTest::qWait(20);
                auto *newPassword = auth->property("passwordField").value<QObject *>();
                if (auth->property("username").toString() != "bob" || !oldPassword->property("text").toString().isEmpty() || !newPassword->property("text").toString().isEmpty()) {
                    std::cerr << id.toStdString() << ": resize lost account or retained password\n"; ++failures;
                }
                for (auto *item : root->findChildren<QQuickItem *>()) {
                    if (item->isVisible() && item->objectName() == "usernameField" && item->property("currentText").toString() != "bob") {
                        std::cerr << id.toStdString() << ": compact account out of sync\n"; ++failures;
                    }
                }
                newPassword->setProperty("text", "retry");
                qobject_cast<QQuickItem *>(newPassword)->forceActiveFocus();
                int calls = proxy->property("loginCalls").toInt();
                QTest::keyClick(&window, Qt::Key_Return);
                app.processEvents();
                if (proxy->property("loginCalls").toInt() != calls + 1 || proxy->property("submittedUser").toString() != "bob") {
                    std::cerr << id.toStdString() << ": compact form submitted wrong account\n"; ++failures;
                }
                QMetaObject::invokeMethod(proxy, "loginFailed");
                QTest::keyClick(&window, Qt::Key_R);
                if (!auth->property("errorMessage").toString().isEmpty() || auth->property("rejected").toBool()) {
                    std::cerr << id.toStdString() << ": error did not clear on correction\n"; ++failures;
                }
                newPassword->setProperty("text", "");
                window.resize(1920,1080); root->setWidth(1920); root->setHeight(1080);
                QTest::qWait(20);
                if (username->property("currentText").toString() != "bob") {
                    std::cerr << id.toStdString() << ": native account out of sync\n"; ++failures;
                }
                auth->setProperty("username", "alice");
            } else { std::cerr << id.toStdString() << ": missing account dropdown\n"; ++failures; }
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
            for (double invalid : {-1.0, 2.0, 99.0, 0.5}) {
                QVariant invalidIndex(invalid);
                QMetaObject::invokeMethod(auth, "login", Q_ARG(QVariant, user), Q_ARG(QVariant, password), Q_ARG(QVariant, invalidIndex));
                if (auth->property("busy").toBool() || proxy->property("loginCalls").toInt() != before || auth->property("errorMessage").toString().isEmpty()) {
                    std::cerr << id.toStdString() << ": invalid session accepted\n"; ++failures;
                }
            }
            user = "";
            QMetaObject::invokeMethod(auth, "login", Q_ARG(QVariant, user), Q_ARG(QVariant, password), Q_ARG(QVariant, index));
            if (auth->property("busy").toBool() || proxy->property("loginCalls").toInt() != before) ++failures;
        }
        if (auth) {
            auto *field = auth->property("passwordField").value<QObject *>();
            if (field) field->setProperty("text", "success-check");
            QVariant user("alice"), password("success-check"), index(0);
            QMetaObject::invokeMethod(auth, "login", Q_ARG(QVariant, user), Q_ARG(QVariant, password), Q_ARG(QVariant, index));
            QMetaObject::invokeMethod(proxy, "loginSucceeded");
            if (!auth->property("busy").toBool() || auth->property("rejected").toBool() || !auth->property("errorMessage").toString().isEmpty() || !field || !field->property("text").toString().isEmpty()) {
                std::cerr << id.toStdString() << ": success did not clear password/state\n"; ++failures;
            }
        }
        delete object;
        users->setProperty("lastUser", "bob");
        users->setProperty("lastIndex", 0);
        sessions->setProperty("lastIndex", 99);
        QObject *nextLogin = component.create();
        app.processEvents();
        QObject *nextAuth = nextLogin ? nextLogin->findChild<QObject *>("authController") : nullptr;
        if (!nextAuth || nextAuth->property("username").toString() != "bob" || nextAuth->property("sessionIndex").toInt() != 0) {
            std::cerr << id.toStdString() << ": saved account/session fallback failed\n"; ++failures;
        }
        if (nextLogin) {
            for (auto *item : nextLogin->findChildren<QQuickItem *>())
                if (item->objectName() == "usernameField" && item->property("currentText").toString() != "bob") {
                    std::cerr << id.toStdString() << ": saved account not displayed\n"; ++failures;
                }
        }
        delete nextLogin;
        users->setProperty("lastUser", "");
        users->setProperty("lastIndex", -1);
        sessions->setProperty("lastIndex", -1);
    }
    // No users/sessions must render safely, rather than selecting a phantom index.
    QObject *emptyUsers = makeObject(engine, R"(
import QtQuick 2.15
ListModel { property int lastIndex: 99; property string lastUser: "" }
)");
    QObject *emptySessions = makeObject(engine, R"(
import QtQuick 2.15
ListModel { property int lastIndex: 99 }
)");
    engine.rootContext()->setContextProperty("userModel", emptyUsers);
    engine.rootContext()->setContextProperty("sessionModel", emptySessions);
    catalog.seek(0);
    for (const auto &entry : QJsonDocument::fromJson(catalog.readAll()).object()["themes"].toArray()) {
        const QString id = entry.toObject()["id"].toString();
        QQmlComponent component(&engine, QUrl::fromLocalFile(repo.filePath("themes/" + id + "/Main.qml")));
        QObject *object = component.create();
        app.processEvents();
        QObject *auth = object ? object->findChild<QObject *>("authController") : nullptr;
        if (!auth || !auth->property("username").toString().isEmpty() || auth->property("sessionIndex").toInt() != -1) {
            std::cerr << id.toStdString() << ": empty model fallback failed\n"; ++failures;
        }
        if (object) {
            for (auto *item : object->findChildren<QQuickItem *>())
                if (item->objectName() == "usernameField" && (item->property("currentIndex").toInt() != -1 || item->property("displayText").toString().isEmpty() || item->isEnabled())) {
                    std::cerr << id.toStdString() << ": empty account dropdown failed\n"; ++failures;
                }
        }
        delete object;
    }
    delete emptyUsers;
    delete emptySessions;
    std::cout << "Qt " << qVersion() << ": instantiated " << count << " themes; failures: " << failures << std::endl;
    delete proxy;
    delete users;
    delete sessions;
    return failures ? 1 : 0;
}
