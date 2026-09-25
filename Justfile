set minimum-version := '1.10.0'
compilador := "clang++"
flags_comp := "-Iinclude -std=c++23 -Wall -Wextra"


default: build-dll

build-dll:
    @echo "Compilando as bibliotecas..."
    @{{compilador}} -shared -fPIC src/lib/*.cpp -o lib/libteste.so {{flags_comp}}
    @echo "Compiladas com sucesso"

check:
    @echo "Iniciando checagem..."
    @{{compilador}} -fsyntax-only src/*.cpp {{flags_comp}}
    @echo "Checagem completa"

build: init-build
    @{{compilador}} src/*.cpp -o bin/app {{flags_comp}} -Llib -lteste

cp lib:
    cp lib/lib{{lib}}.so bin/

clean:
    rm -rf bin/app bin/*.so lib/*.so

[private]
init-build:
    @if [ ! -d "bin/" ]; then mkdir bin; fi