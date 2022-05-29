cmake_minimum_required(VERSION 3.18.0)

find_package(OpenCV REQUIRED)


# Set the target name from the project name.
set(TARGET_NAME_EXECUTABLE ${LOCAL_PROJECT_NAME})


set(TARGET_SOURCES_EXECUTABLE
  main.cpp
)

# Create executable target for the project.
add_executable(${TARGET_NAME_EXECUTABLE} ${TARGET_SOURCES_EXECUTABLE})


# Add include directories.
target_include_directories(${TARGET_NAME_EXECUTABLE} PRIVATE ${OpenCV_INCLUDE_DIRS})


# Link external libraries to the executable target.
target_link_libraries(${TARGET_NAME_EXECUTABLE} PRIVATE ${OpenCV_LIBS})
