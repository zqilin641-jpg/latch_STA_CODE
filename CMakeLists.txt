# ============================================================
# LatchSTA CMakeLists.txt — WSL Ubuntu 适配版
# 基于原始 CMakeLists.txt，移除所有 /home/kxzhu/ 硬编码路径
# 使用系统 apt 安装的库（find_package / pkg-config）
# LEDA 仅头文件引用（p_queue 是模板类），不链接 libleda.so
# ============================================================

cmake_minimum_required(VERSION 3.16)
project(EllCpp LANGUAGES CXX Fortran)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ---- Options ----
option(BP_BUILD_TESTS "Enable tests" ON)
option(ENABLE_COVERAGE "Coverage build" OFF)
option(ENABLE_DOCTESTS "Include doctests" OFF)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# ---- Custom modules ----
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(Colors)
include(Doctest)
include(LTO)
include(Warnings)
include(CopyDllsForDebug)
include(ConfigSafeGuards)
include(CMakeFindDependencyMacro)

# ---- Compiler Flags ----
if(MSVC)
    add_compile_options(/std:c++latest /Wv:18 /W3 /WX /wd4819 /wd4146 /D_SILENCE_CXX17_OLD_ALLOCATOR_MEMBERS_DEPRECATION_WARNING)
else()
    add_compile_options(-std=c++17 -Wall -Wnon-virtual-dtor -Wunused -pedantic)
endif()

# ---- Dependencies ----

# Threads
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

# OpenBLAS (also provides LAPACK/BLAS)
find_package(OpenBLAS REQUIRED)
if(OpenBLAS_FOUND)
    message(STATUS "Found OpenBLAS: ${OpenBLAS_LIBRARIES}")
    include_directories(BEFORE ${OpenBLAS_INCLUDE_DIRS})
endif()

# LAPACK
find_package(LAPACK REQUIRED)
if(LAPACK_FOUND)
    message(STATUS "Found LAPACK: ${LAPACK_LIBRARIES}")
endif()

# BLAS
find_package(BLAS REQUIRED)
if(BLAS_FOUND)
    message(STATUS "Found BLAS: ${BLAS_LIBRARIES}")
endif()

# xtensor (header-only, from apt)
find_package(xtensor REQUIRED)
if(xtensor_FOUND)
    message(STATUS "Found xtensor: ${xtensor_INCLUDE_DIRS}")
endif()

# xtensor-blas
find_package(xtensor-blas REQUIRED)
if(xtensor-blas_FOUND)
    message(STATUS "Found xtensor-blas: ${xtensor-blas_INCLUDE_DIRS}")
endif()

# GLPK — no cmake config in apt package, use find_library/find_path
find_path(GLPK_INCLUDE_DIR glpk.h)
find_library(GLPK_LIBRARY glpk)
if(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)
    message(STATUS "Found GLPK: ${GLPK_INCLUDE_DIR} -> ${GLPK_LIBRARY}")
    include_directories(${GLPK_INCLUDE_DIR})
else()
    message(FATAL_ERROR "GLPK not found. Install: sudo apt install libglpk-dev")
endif()

# Boost — only need graph, NOT context/coroutine (not used in code)
find_package(Boost REQUIRED COMPONENTS graph)
if(Boost_FOUND)
    message(STATUS "Found Boost: ${Boost_INCLUDE_DIRS}")
    include_directories(${Boost_INCLUDE_DIRS})
endif()

# ---- REMOVED dependencies (not actually used by source code) ----
# - fmt: not #included anywhere in user code
# - xtensor-fftw: not used
# - FFTW: not used
# - boost::context / boost::coroutine: not used
# - spdlog: not used
# - X11: only in LEDA graphics headers (not used by this project)
# - LEDA .so linking: p_queue is template/header-only

# ---- Include & Sources ----
include_directories(include)
# LEDA headers are in include/LEDA/, already covered by include_directories(include)
aux_source_directory(src SRC_LIST)

# LEDA
find_library(LEDA_LIBRARY leda HINTS ${CMAKE_SOURCE_DIR})
if(LEDA_LIBRARY)
    message(STATUS "Found LEDA: ${LEDA_LIBRARY}")
else()
    message(FATAL_ERROR "LEDA not found. Place libleda.so in project root.")
endif()

# ---- Executable ----
add_executable(main ${SRC_LIST})

add_executable(pds_howard tools/pds_howard.cpp src/howard.cpp)

# ---- Link ----
target_link_libraries(main
    ${OpenBLAS_LIBRARIES}
    ${LAPACK_LIBRARIES}
    ${BLAS_LIBRARIES}
    ${GLPK_LIBRARY}
    ${Boost_LIBRARIES}
    ${LEDA_LIBRARY}
    X11 Xft
    ${CMAKE_THREAD_LIBS_INIT}
    gfortran
)

# ---- Build Type ----
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g2 -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")

enable_testing()
if(BP_BUILD_TESTS)
    add_subdirectory(tests)
endif()

# ---- Coverage (optional) ----
if(ENABLE_COVERAGE)
    set(CMAKE_BUILD_TYPE "Coverage")
    include(CodeCoverage)
    setup_target_for_coverage(${PROJECT_NAME}_coverage ${PROJECT_NAME}_test coverage)
endif()
