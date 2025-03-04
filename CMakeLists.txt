# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

#=============================
# Project
#=============================

project(KRCMake VERSION 1.0.0)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds not allowed. "
        "Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

#=============================
# Options
#=============================

include(CMakeDependentOption)

cmake_dependent_option(
    ${PROJECT_NAME}_ENABLE_TEST
    "Enalbe test"
    ON
    "PROJECT_IS_TOP_LEVEL"
    OFF
)

option(
    ${PROJECT_NAME}_ENABLE_INSTALL
    "Enalbe install"
    "${PROJECT_IS_TOP_LEVEL}"
)

#=============================
# Variables
#=============================

set(enable_test "${${PROJECT_NAME}_ENABLE_TEST}")
set(enable_install "${${PROJECT_NAME}_ENABLE_INSTALL}")

#=============================
# Module path
#=============================

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
if(NOT PROJECT_IS_TOP_LEVEL)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()

#=============================
# Testing
#=============================

if(enable_test)
    include(CTest)
    add_subdirectory(tests)
endif()

#=============================
# Packaging
#=============================

if(enable_install)
    add_subdirectory(packaging)
endif()
