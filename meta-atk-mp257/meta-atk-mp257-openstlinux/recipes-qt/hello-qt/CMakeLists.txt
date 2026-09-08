cmake_minimum_required(VERSION 3.16)

project(hello-qt VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets)

qt_add_executable(hello-qt main.cpp)

target_link_libraries(hello-qt PRIVATE Qt6::Widgets)

install(TARGETS hello-qt
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
