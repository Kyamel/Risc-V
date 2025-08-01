QT += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TEMPLATE = app
TARGET = simulador

SOURCES += vsim-gui.cpp

# Diretórios de build customizados
DESTDIR = qtbuild/bin        # Binário final
OBJECTS_DIR = qtbuild/out    # .o files
MOC_DIR = qtbuild/out        # arquivos gerados por moc
RCC_DIR = qtbuild/out        # recursos compilados
UI_DIR = qtbuild/out         # arquivos UI compilados
