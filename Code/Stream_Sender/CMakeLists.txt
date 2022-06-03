cmake_minimum_required(VERSION 3.22)
project(Stream_Sender)

set(CMAKE_CXX_STANDARD 17)
find_package(OpenCV REQUIRED)
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_executable(Stream_Sender main.cpp)
target_link_libraries(Stream_Sender ${OpenCV_LIBS} )