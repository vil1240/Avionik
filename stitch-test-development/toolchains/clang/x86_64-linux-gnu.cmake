cmake_minimum_required(VERSION 3.18.0)

# Set system information.
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86)

# Set compiler target architecture.
set(TRIPLE x86_64-linux-gnu)

# Set the binary output paths.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${TRIPLE})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/lib)

# Set compiler to use.
set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER_TARGET ${TRIPLE})
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_CXX_COMPILER_TARGET ${TRIPLE})
set(CMAKE_ASM_COMPILER clang)
set(CMAKE_ASM_COMPILER_TARGET ${TRIPLE})
set(CMAKE_LINKER lld-link)
set(CMAKE_OBJCOPY llvm-objcopy)
set(CMAKE_SIZE_UTIL llvm-size)

# Default C compiler flags.

# Enable most warnings, treat warnings as errors and set highest optimization.
set(CMAKE_C_FLAGS_RELEASE "-Wall -Wextra -Werror -O3" CACHE STRING "" FORCE)
# Enable most warnings, enable debug symbols and disable optimization.
set(CMAKE_C_FLAGS_DEBUG "-Wall -Wextra -g -O0 -fstandalone-debug" CACHE STRING "" FORCE)

# Default C++ compiler flags.

# Enable most warnings, treat warnings as errors and set highest optimization.
set(CMAKE_CXX_FLAGS_RELEASE "-Wall -Wextra -Werror -O3" CACHE STRING "" FORCE)
# Enable most warnings, enable debug symbols and disable optimization.
set(CMAKE_CXX_FLAGS_DEBUG "-Wall -Wextra -g -O0 -fstandalone-debug" CACHE STRING "" FORCE)

# Default ASM compiler flags.

# Enable most warnings, treat warnings as errors and set highest optimization.
set(CMAKE_ASM_FLAGS_RELEASE "-Wall -Wextra -Werror -O3" CACHE STRING "" FORCE)
# Enable most warnings, enable debug symbols and disable optimization.
set(CMAKE_ASM_FLAGS_DEBUG "-Wall -Wextra -g -O0 -fstandalone-debug" CACHE STRING "" FORCE)

# Linker flags.
set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld" CACHE STRING "" FORCE)
set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld" CACHE STRING "" FORCE)

# Add library locations.
link_directories("/usr/local/lib")
