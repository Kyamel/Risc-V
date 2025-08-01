#include <QApplication>
#include <QMainWindow>
#include <QLabel>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);         // Inicializa a aplicação Qt

    QMainWindow window;                   // Cria uma janela principal
    window.setWindowTitle("Simulador Verilog");
    window.resize(600, 400);              // Define tamanho da janela

    QLabel *label = new QLabel("Olá, Verilog!", &window);  // Adiciona um texto
    label->move(100, 100);                // Posição do label dentro da janela

    window.show();                        // Mostra a janela

    return app.exec();                    // Loop principal do Qt
}
