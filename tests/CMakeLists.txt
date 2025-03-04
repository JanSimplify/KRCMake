# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

#=============================
# Project
#=============================

set(package_name KRCMake)

project("${package_name}Test")

#=============================
# Dependencies
#=============================

if(PROJECT_IS_TOP_LEVEL)
    include(CTest)
    find_package("${package_name}" REQUIRED)
endif()

add_subdirectory(dummy)
