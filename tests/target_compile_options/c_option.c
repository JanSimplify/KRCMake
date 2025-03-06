/* SPDX-License-Identifier: MIT */
/* SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify */

#include "c_option.h"

#include <stdio.h>

void print_test_define_of_c_file(void)
{
#ifdef KRCMAKE_SET_GNU_C_OPTIONS
    printf("KRCMAKE_SET_GNU_C_OPTIONS on c file\n");
#endif

#ifdef KRCMAKE_SET_GNU_CXX_OPTIONS
    printf("KRCMAKE_SET_GNU_CXX_OPTIONS on c file\n");
#endif

#ifdef KRCMAKE_SET_CLANG_C_OPTIONS
    printf("KRCMAKE_SET_CLANG_C_OPTIONS on c file\n");
#endif

#ifdef KRCMAKE_SET_CLANG_CXX_OPTIONS
    printf("KRCMAKE_SET_CLANG_CXX_OPTIONS on c file\n");
#endif

#ifdef KRCMAKE_SET_MSVC_OPTIONS
    printf("KRCMAKE_SET_MSVC_OPTIONS on c file\n");
#endif
}
