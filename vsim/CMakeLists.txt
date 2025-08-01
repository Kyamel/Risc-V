cmake_minimum_required(VERSION 3.16)
project(vsim-gl LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Arquivos ImGui
set(IMGUI_SOURCES
    imgui/imgui.cpp
    imgui/imgui_draw.cpp
    imgui/imgui_tables.cpp
    imgui/imgui_widgets.cpp
    imgui/backends/imgui_impl_sdl2.cpp
    imgui/backends/imgui_impl_opengl3.cpp
)

add_executable(${PROJECT_NAME} vsim-gl.cpp ${IMGUI_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE
    imgui
    imgui/backends
)

if(EMSCRIPTEN)
    # Para WebAssembly (browser)
    set(CMAKE_EXECUTABLE_SUFFIX ".html")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -sUSE_SDL=2  -sFULL_ES3=1 -sASYNCIFY")
    target_link_options(${PROJECT_NAME} PRIVATE "-sUSE_SDL=2" "-sFULL_ES3=1" "-sASYNCIFY" "-sWASM=1" "--preload-file ./@/")

else()
    # Para desktop (Linux)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2 REQUIRED sdl2)

    target_include_directories(${PROJECT_NAME} PRIVATE ${SDL2_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${SDL2_LIBRARIES} GL)
endif()
