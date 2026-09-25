# Versão mínima do CMake
cmake_minimum_required(VERSION 3.28)

# Nome do projeto e versão padrão do C++
project(A_GBA_EMU CXX)
set(CMAKE_CXX_STANDARD 23)

# Define algumas configurações
include_directories(include)
set(SRC_DIR src/)
set(EXECUTAVEL programa)
set(FONTES_EXECUTAVEL main)

# Define que a versão do C++ é obrigatória e desativa extensões específicas do compilador
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Transforma os itens em FONTES_EXECUTAVEL para o padrão ${SRC_DIR}item.cpp
list(TRANSFORM FONTES_EXECUTAVEL PREPEND ${SRC_DIR})
list(TRANSFORM FONTES_EXECUTAVEL APPEND .cpp)

# Permite a exportação dos comandos de compilação para o clangd funcionar direito
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Define o executavel
add_executable(${EXECUTAVEL} ${FONTES_EXECUTAVEL})

add_library(lib_teste SHARED IMPORTED)
set_target_properties(lib_teste PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/dll/teste.so")
target_link_libraries(${EXECUTAVEL} PRIVATE lib_teste)

# Algumas flags para a compilação do executável
target_compile_options(${EXECUTAVEL} PRIVATE 
-Wall -Wextra -Werror -Wpedantic -Wshadow 
-Wconversion -Wsign-conversion)

# Regra pro comando extra 'just run'
add_custom_target(run
    COMMAND $<TARGET_FILE:${EXECUTAVEL}>
    DEPENDS ${EXECUTAVEL}
)