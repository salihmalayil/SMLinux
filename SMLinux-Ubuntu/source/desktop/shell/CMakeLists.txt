cmake_minimum_required(VERSION 3.21)

project(SMLinuxShell LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(smlinux-shell
    src/main.cpp
    src/AppLauncher.cpp
    src/AppLauncher.h
)

qt_add_qml_module(smlinux-shell
    URI SMLinux
    VERSION 1.0
    QML_FILES
        src/Main.qml
)

target_link_libraries(smlinux-shell PRIVATE Qt6::Quick)
