# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(KRCMakeCompileOptions)

#=============================
# Variables
#=============================

set(test_name "target_set_sanitizer")

#=============================
# Target
#=============================

add_executable(
    "${test_name}"
    "main.cpp"
)

krcmake_target_set_sanitizer(
    TARGETS "${test_name}"
    ADDRESS
    UNDEFINED
)

#=============================
# Test
#=============================

add_test(
    NAME "${test_name}"
    COMMAND "${test_name}"
)

set_tests_properties(
    "${test_name}"
    PROPERTIES
        PASS_REGULAR_EXPRESSION
            "AddressSanitizer"
        LABELS "sanitizer"
)
