# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Variables
#=============================

set(test_name "target_set_develop_mode")

#=============================
# Target
#=============================

add_executable(
    "${test_name}"
    "main.cpp"
    "dummy.c"
    "dummy.cpp"
)

krcmake_target_set_develop_mode(
    TARGETS "${test_name}"
    WARNING_AS_ERROR
    ERROR_AS_FATAL
)

#=============================
# Test
#=============================

add_test(
    NAME "${test_name}"
    COMMAND "${test_name}"
)
