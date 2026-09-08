#include <QApplication>
#include <QLabel>
#include <Qt>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QLabel label("Hello Qt from ATK STM32MP257!");
    label.setWindowTitle("hello-qt");
    label.setAlignment(Qt::AlignCenter);
    label.setMinimumSize(640, 240);
    label.resize(800, 400);
    label.show();

    return app.exec();
}
