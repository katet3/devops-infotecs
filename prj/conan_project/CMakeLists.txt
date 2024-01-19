cmake_minimum_required(VERSION 3.12)
project(MyProject)

# Включить поддержку пакетов Conan в CMake
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

add_executable(my_project main.cpp)
target_link_libraries(my_project PRIVATE CONAN_PKG::fmt)
