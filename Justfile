set minimum-version := '1.10.0'

# Caminhos
SRC_DIR := "src"
INCLUDE_DIR := "include"
LIB_DIR := "lib"
BIN_DIR := "bin"

# Arquivos
APP_NAME := "app"
DLL_EXT := ".so"
QT_INCLUDE := "-isystem /usr/include/x86_64-linux-gnu/qt6 -isystem /usr/include/x86_64-linux-gnu/qt6/QtCore -isystem /usr/include/x86_64-linux-gnu/qt6/QtGui -isystem /usr/include/x86_64-linux-gnu/qt6/QtWidgets"
QT_LIBS := "-lQt6Widgets -lQt6Gui -lQt6Core"
MOC_BIN := "/usr/lib/qt6/libexec/moc"

# Variáveis
CXX := "clang++"
CXX_COMPILE_FLAGS := "-I" + INCLUDE_DIR + " -std=c++23 -Wall -Wextra"
DLL_COMPILE_FLAGS := "-shared -fPIC"

# Constrói as DLL na LIB_DIR
build-dll:
    @echo "Compilando as bibliotecas..."
    @for pasta in {{SRC_DIR}}/*/; do \
    if [ -d "$pasta" ]; then \
    nome=$(basename "$pasta"); \
    echo -n "${nome}... "; \
    just moc $pasta ${nome}; \
    {{CXX}} {{DLL_COMPILE_FLAGS}} $pasta/*.cpp -o {{LIB_DIR}}/lib${nome}{{DLL_EXT}} -DCOMPILANDO_A_BIBLIOTECA {{QT_INCLUDE}} {{QT_LIBS}} {{CXX_COMPILE_FLAGS}}; \
    rm -rf $pasta/moc_${nome}.cpp; \
    echo "Sucesso"; \
    fi; \
    done
    @echo "Compiladas com sucesso"

[private]
moc pasta nome:
    @{{MOC_BIN}} {{INCLUDE_DIR}}/{{nome}}.hpp -o {{pasta}}/moc_{{nome}}.cpp

# Checa se o aplicativo compila
[default]
check:
    @echo "Iniciando checagem..."
    @{{CXX}} -fsyntax-only {{SRC_DIR}}/*.cpp {{CXX_COMPILE_FLAGS}}
    @clang-tidy {{SRC_DIR}}/*.cpp -- {{CXX_COMPILE_FLAGS}}
    @echo "Checagem sem erros"

# Constroi o aplicativo
build: init-build
    @{{CXX}} {{SRC_DIR}}/*.cpp {{LIB_DIR}}/*{{DLL_EXT}} -o {{BIN_DIR}}/{{APP_NAME}} {{CXX_COMPILE_FLAGS}} {{QT_INCLUDE}} {{QT_LIBS}} -L{{LIB_DIR}}

# Executa o aplicativo
run:
    @LD_LIBRARY_PATH={{BIN_DIR}} ./{{BIN_DIR}}/{{APP_NAME}} 

# Constroi e executa o aplicativo
br: build run

# Move a lib desejada de LIB_DIR para BIN_DIR
cp lib:
    @cp {{LIB_DIR}}/lib{{lib}}{{DLL_EXT}} {{BIN_DIR}}
    @echo "lib{{lib}}{{DLL_EXT}} copiado com sucesso"

[private]
bear:
    bear -- just build

# Apaga o executavel e as bibliotecas
clean:
    @rm -rf {{BIN_DIR}}/{{APP_NAME}} {{BIN_DIR}}/*{{DLL_EXT}} {{LIB_DIR}}/*{{DLL_EXT}}
    @echo "Binários apagados com sucesso"

[private]
init-build:
    @if [ ! -d {{BIN_DIR}} ]; then mkdir {{BIN_DIR}}; fi