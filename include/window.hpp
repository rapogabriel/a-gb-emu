#pragma once

#if defined(COMPILANDO_A_BIBLIOTECA)
#  define MINHA_GUI_EXPORT Q_DECL_EXPORT
#else
#  define MINHA_GUI_EXPORT Q_DECL_IMPORT
#endif

#include <QWidget>
#include <QPushButton>

class Window : public QWidget {
    Q_OBJECT

public:
    explicit Window(QWidget *parent = nullptr);

private slots:
    void onButtonClicked();

private:
    QPushButton *button;
};