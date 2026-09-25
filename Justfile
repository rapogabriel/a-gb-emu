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
    @{{CXX}} {{DLL_COMPILE_FLAGS}} {{SRC_DIR}}/{{LIB_DIR}}/*.cpp -o {{LIB_DIR}}/libteste{{DLL_EXT}} {{CXX_COMPILE_FLAGS}}
    @echo "Compiladas com sucesso"

[default]
check:
    @echo "Iniciando checagem..."
    @{{CXX}} -fsyntax-only {{SRC_DIR}}/*.cpp {{CXX_COMPILE_FLAGS}}
    @clang-tidy {{SRC_DIR}}/*.cpp -- {{CXX_COMPILE_FLAGS}}
    @echo "Checagem sem erros"

build: init-build
    @{{CXX}} {{SRC_DIR}}/*.cpp -o {{BIN_DIR}}/{{APP_NAME}} {{CXX_COMPILE_FLAGS}} -L{{LIB_DIR}} -lteste

run:
    @LD_LIBRARY_PATH={{BIN_DIR}} ./{{BIN_DIR}}/{{APP_NAME}} 

br: build run

cp lib:
    @cp lib/lib{{lib}}{{DLL_EXT}} {{BIN_DIR}}
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