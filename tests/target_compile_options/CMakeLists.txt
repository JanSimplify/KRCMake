# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(KRCMakeCompileOptions)

#=============================
# Variables
#=============================

set(test_name "target_compile_options")

#=============================
# Target
#=============================

add_executable(
    "${test_name}"
    "c_option.h"
    "cxx_option.hpp"
    "c_option.c"
    "cxx_option.cpp"
    "main.cpp"
)

krcmake_target_compile_options(
    TARGETS "${test_name}"
    PRIVATE
        GNU_C_OPTIONS "-DKRCMAKE_SET_GNU_C_OPTIONS"
        GNU_CXX_OPTIONS "-DKRCMAKE_SET_GNU_CXX_OPTIONS"
        CLANG_C_OPTIONS "-DKRCMAKE_SET_CLANG_C_OPTIONS"
        CLANG_CXX_OPTIONS "-DKRCMAKE_SET_CLANG_CXX_OPTIONS"
        MSVC_OPTIONS "/DKRCMAKE_SET_MSVC_OPTIONS"
)

#=============================
# Tests
#=============================

add_test(
    NAME "${test_name}"
    COMMAND "${test_name}"
)

set(pass_string "no matched compiler ID")

if(CMAKE_C_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    string(CONCAT pass_string
        "^KRCMAKE_SET_GNU_C_OPTIONS on c file\n"
        "KRCMAKE_SET_GNU_CXX_OPTIONS on cxx file\n$"
    )
endif()

if(CMAKE_C_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    string(CONCAT pass_string
        "^KRCMAKE_SET_CLANG_C_OPTIONS on c file\n"
        "KRCMAKE_SET_CLANG_CXX_OPTIONS on cxx file\n$"
    )
endif()

if(MSVC)
    string(CONCAT pass_string
        "^KRCMAKE_SET_MSVC_OPTIONS on c file\n"
        "KRCMAKE_SET_MSVC_OPTIONS on cxx file\n$"
    )
endif()

set_tests_properties(
    "${test_name}"
    PROPERTIES
        PASS_REGULAR_EXPRESSION
            "${pass_string}"
)
