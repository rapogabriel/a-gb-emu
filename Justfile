set minimum-version := '1.10.0'

# Caminhos
SRC_DIR := "src"
INCLUDE_DIR := "include"
LIB_DIR := "lib"
BIN_DIR := "bin"

# Arquivos
APP_NAME := "app"
DLL_EXT := ".so"

# Variáveis
CXX := "clang++"
CXX_COMPILE_FLAGS := "-I" + INCLUDE_DIR + " -std=c++23 -Wall -Wextra"
DLL_COMPILE_FLAGS := "-shared -fPIC"

build-dll:
    @echo "Compilando as bibliotecas..."
    @for pasta in {{SRC_DIR}}/*/; do \
    if [ -d "$pasta" ]; then \
    nome=$(basename "$pasta"); \
    echo -n "${nome}... "; \
    {{CXX}} {{DLL_COMPILE_FLAGS}} $pasta/*.cpp -o {{LIB_DIR}}/lib${nome}{{DLL_EXT}} {{CXX_COMPILE_FLAGS}}; \
    echo "Sucesso"; \
    fi; \
    done
    @echo "Compiladas com sucesso"

[default]
check:
    @echo "Iniciando checagem..."
    @{{CXX}} -fsyntax-only {{SRC_DIR}}/*.cpp {{CXX_COMPILE_FLAGS}}
    @clang-tidy {{SRC_DIR}}/*.cpp -- {{CXX_COMPILE_FLAGS}}
    @echo "Checagem sem erros"

build: init-build
    @{{CXX}} {{SRC_DIR}}/*.cpp {{LIB_DIR}}/*{{DLL_EXT}} -o {{BIN_DIR}}/{{APP_NAME}} {{CXX_COMPILE_FLAGS}} -L{{LIB_DIR}}

run:
    @LD_LIBRARY_PATH={{BIN_DIR}} ./{{BIN_DIR}}/{{APP_NAME}} 

br: build run

cp lib:
    @cp {{LIB_DIR}}/lib{{lib}}{{DLL_EXT}} {{BIN_DIR}}
    @echo "lib{{lib}}{{DLL_EXT}} copiado com sucesso"

clean:
    @rm -rf {{BIN_DIR}}/{{APP_NAME}} {{BIN_DIR}}/*{{DLL_EXT}} {{LIB_DIR}}/*{{DLL_EXT}}
    @echo "Binários apagados com sucesso"

[private]
gen-cmpcmd:
    bear -- just build

[private]
init-build:
    @if [ ! -d {{BIN_DIR}} ]; then mkdir {{BIN_DIR}}; fi