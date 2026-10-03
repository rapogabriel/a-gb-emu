#include "window.hpp"

#include <QVBoxLayout>
#include <QMessageBox>

Window::Window(QWidget *parent) : QWidget(parent) {
    button = new QPushButton("Clique Aqui", this);
    
    QVBoxLayout *layout = new QVBoxLayout(this);
    layout->addWidget(button);
    
    connect(button, &QPushButton::clicked, this, &Window::onButtonClicked);
}

void Window::onButtonClicked() {
    QMessageBox::information(this, "Ação", "Funciona!");
}