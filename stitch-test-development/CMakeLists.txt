cmake_minimum_required(VERSION 3.18.0)


# Set used languages.
set(USED_LANGUAGES CXX C ASM)

# Load cmake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

# Include tools.
include(Config)
include(Options)
include(VersionFromGit)
include(IncludeSymlinks)

# Include global packages.
find_package(PkgConfig)

# Set C++20 standard.
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set C11 standard.
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)



# Select default toolchain file.
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE OR CMAKE_TOOLCHAIN_FILE STREQUAL "")
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/toolchains/clang/native.cmake)
  include(${CMAKE_TOOLCHAIN_FILE})
endif()

# Inform of the toolchain file used
message(STATUS "Toolchain file: ${CMAKE_TOOLCHAIN_FILE}")

# Set build types.
set(CMAKE_CONFIGURATION_TYPES Debug Release)

# Default to Debug build type if none is set.
if(NOT DEFINED CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL "")
  set(CMAKE_BUILD_TYPE Debug)
endif()

# Set build type compile definitions
string(TOUPPER ${CMAKE_BUILD_TYPE} PRJ_BUILD_TYPE_CAPS)
add_compile_definitions(PRJ_BUILD_TYPE=${CMAKE_BUILD_TYPE} "PRJ_BUILD_TYPE_${PRJ_BUILD_TYPE_CAPS}")
unset(PRJ_BUILD_TYPE_CAPS)
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

# Set name definitions.
add_compile_definitions(
  PRJ_LOCAL_PROJECT_NAME="${LOCAL_PROJECT_NAME}"
  PRJ_LOCAL_PROJECT_DESCRIPTION="${LOCAL_PROJECT_DESCRIPTION}"
)


# Get a version string from git.
prj_version_from_git()

# Set version definitions.
add_compile_definitions(
  GIT_VERSION_MAJOR=${GIT_VERSION_MAJOR}
  GIT_VERSION_MINOR=${GIT_VERSION_MINOR}
  GIT_VERSION_PATCH=${GIT_VERSION_PATCH}
  GIT_SEMVER="${GIT_SEMVER}"
  GIT_VERSION="${GIT_VERSION}"
  GIT_TAG="${GIT_TAG}"
  GIT_HASH="${GIT_HASH}"
  GIT_HASH_SHORT="${GIT_HASH_SHORT}"
  GIT_BRANCH="${GIT_BRANCH}"
)


# Create the root project.
project(${LOCAL_PROJECT_NAME} VERSION ${GIT_VERSION} DESCRIPTION ${LOCAL_PROJECT_DESCRIPTION} LANGUAGES ${USED_LANGUAGES})


# Define variables and options here.
prj_register_option(FATAL_WARNINGS "Treat warnings as errors" OFF)

# Print enabled variables and options.
list(JOIN PRJ_CUSTOM_VARIABLES ", " PRJ_PRJ_CUSTOM_VARIABLES_STRING)
list(JOIN PRJ_ENABLED_OPTIONS ", " PRJ_ENABLED_OPTIONS_STRING)
message(STATUS "Custom variables: " ${PRJ_PRJ_CUSTOM_VARIABLES_STRING})
message(STATUS "Enabled options: " ${PRJ_ENABLED_OPTIONS_STRING})


# Handle fatal warnings option.
if(${PRJ_OPT_FATAL_WARNINGS})
  list(APPEND PRJ_C_FLAGS "-Werror")
  list(APPEND PRJ_CXX_FLAGS "-Werror")
  list(APPEND PRJ_ASM_FLAGS "-Werror")
endif()


# Apply all set compiler flags to the CMAKE variable.
list(JOIN PRJ_C_FLAGS " " PRJ_C_FLAGS)
list(JOIN PRJ_CXX_FLAGS " " PRJ_CXX_FLAGS)
list(JOIN PRJ_ASM_FLAGS " " PRJ_ASM_FLAGS)
if(CMAKE_BUILD_TYPE MATCHES Debug)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS_DEBUG} ${PRJ_C_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_DEBUG} ${PRJ_CXX_FLAGS}")
  set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS_DEBUG} ${PRJ_ASM_FLAGS}")
else(CMAKE_BUILD_TYPE MATCHES Release)
  set(CMAKE_C_FLAGS "${CMAKE_C_RELEASE} ${PRJ_C_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_RELEASE} ${PRJ_CXX_FLAGS}")
  set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS_RELEASE} ${PRJ_ASM_FLAGS}")
endif()

# Save the command line compile commands in the build output.
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)


# TODO: add description
prj_add_include_symlink(TARGET ${LOCAL_PROJECT_NAME} NAME ${LOCAL_PROJECT_NAME} NAMESPACE ${LOCAL_PROJECT_NAMESPACE})

# Add the project root directory to the include path.
include_directories(BEFORE ${CMAKE_CURRENT_LIST_DIR}/include)

# Add header libraries to the include path.
include_directories(BEFORE ${CMAKE_CURRENT_LIST_DIR}/submodules/cpp-utils)

# Add main source directory.
add_subdirectory(${LOCAL_PROJECT_NAME})
