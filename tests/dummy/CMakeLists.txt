# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

add_executable(
    dummy_test
    main.cpp
)

add_test(
    NAME dummy_test
    COMMAND dummy_test
)
