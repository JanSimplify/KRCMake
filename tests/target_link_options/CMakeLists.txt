# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(KRCMakeCompileOptions)

#=============================
# Variables
#=============================

set(test_name_c "target_link_c_options")
set(test_name_cxx "target_link_cxx_options")

#=============================
# Target
#=============================

add_library(
    "${test_name_c}"
    SHARED
    "c_lib.c"
)

add_library(
    "${test_name_cxx}"
    SHARED
    "cxx_lib.cpp"
)

krcmake_target_link_options(
    TARGETS "${test_name_c}" "${test_name_cxx}"
    PUBLIC
        GNU_C_OPTIONS "-Wl,-soname,GNU_C_OPTIONS"
        GNU_CXX_OPTIONS "-Wl,-soname,GNU_CXX_OPTIONS"
        CLANG_C_OPTIONS "-Wl,-soname,CLANG_C_OPTIONS"
        CLANG_CXX_OPTIONS "-Wl,-soname,CLANG_CXX_OPTIONS"
        MSVC_OPTIONS "/VERSION:9876.54321"
)

set_target_properties(
    "${test_name_c}"
    PROPERTIES
        NO_SONAME ON
)

set_target_properties(
    "${test_name_cxx}"
    PROPERTIES
        NO_SONAME ON
)

#=============================
# Test
#=============================

if(CMAKE_C_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    set(use_gnu ON)
    set(pass_string_c "GNU_C_OPTIONS")
    set(pass_string_cxx "GNU_CXX_OPTIONS")
endif()

if(CMAKE_C_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(use_clang ON)
    set(pass_string_c "CLANG_C_OPTIONS")
    set(pass_string_cxx "CLANG_CXX_OPTIONS")
endif()

if(MSVC)
    set(use_msvc ON)
    set(pass_string_c "9876.54321")
    set(pass_string_cxx "9876.54321")
endif()

if(use_gnu OR use_clang)
    find_program(READELF_EXE NAMES readelf REQUIRED)
    add_test(
        NAME "${test_name_c}"
        COMMAND "${READELF_EXE}" --dynamic "$<TARGET_LINKER_FILE:${test_name_c}>"
    )
    set_tests_properties(
        "${test_name_c}"
        PROPERTIES
            PASS_REGULAR_EXPRESSION
                "${pass_string_c}"
    )

    add_test(
        NAME "${test_name_cxx}"
        COMMAND "${READELF_EXE}" --dynamic "$<TARGET_LINKER_FILE:${test_name_cxx}>"
    )
    set_tests_properties(
        "${test_name_cxx}"
        PROPERTIES
            PASS_REGULAR_EXPRESSION
                "${pass_string_cxx}"
    )
endif()

if(use_msvc)
    find_program(DUMPBIN_EXE NAMES dumpbin)
    if(DUMPBIN_EXE)
        add_test(
            NAME "${test_name_c}"
            COMMAND "${DUMPBIN_EXE}" "/HEADERS" "$<TARGET_FILE:${test_name_c}>"
        )
        set_tests_properties(
            "${test_name_c}"
            PROPERTIES
                PASS_REGULAR_EXPRESSION
                    "${pass_string_c}"
        )

        add_test(
            NAME "${test_name_cxx}"
            COMMAND "${DUMPBIN_EXE}" "/HEADERS" "$<TARGET_FILE:${test_name_cxx}>"
        )
        set_tests_properties(
            "${test_name_cxx}"
            PROPERTIES
                PASS_REGULAR_EXPRESSION
                    "${pass_string_cxx}"
        )
    else()
        message(WARNING "${PROJECT_NAME}: dumpbin not found, test skipped")
    endif()
endif()
