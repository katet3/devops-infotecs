cmake_minimum_required(VERSION 3.12)
project(SQLiteCompile)

set(CMAKE_C_STANDARD 11)

# Исходные файлы SQLite
set(SQLITE_SOURCE_DIR "./sqlite-amalgamation-3260000")

set(SQLITE_SOURCE_FILES
    ${SQLITE_SOURCE_DIR}/sqlite3.c
    ${SQLITE_SOURCE_DIR}/sqlite3.h
)

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    # Для Windows (x86/x86_64) с использованием MSVC
    add_library(sqlite3 SHARED ${SQLITE_SOURCE_FILES})
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Для Linux (x86/x86_64) с использованием GCC
    set(CMAKE_C_COMPILER gcc)
    set(CMAKE_CXX_COMPILER gcc)
    add_library(sqlite3 SHARED ${SQLITE_SOURCE_FILES})
    target_link_libraries(sqlite3 dl pthread)
endif()

# Настройка выходных путей и имени библиотеки
set_target_properties(sqlite3 PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    OUTPUT_NAME sqlite3
)

# Настройка опций компилятора для MSVC
if(MSVC)
    target_compile_options(sqlite3 PRIVATE /W4)
endif()
