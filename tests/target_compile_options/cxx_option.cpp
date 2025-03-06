/* SPDX-License-Identifier: MIT */
/* SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify */

#include "cxx_option.hpp"

#include <cstdio>

void print_test_define_of_cxx_file()
{
#ifdef KRCMAKE_SET_GNU_C_OPTIONS
    printf("KRCMAKE_SET_GNU_C_OPTIONS on cxx file\n");
#endif

#ifdef KRCMAKE_SET_GNU_CXX_OPTIONS
    printf("KRCMAKE_SET_GNU_CXX_OPTIONS on cxx file\n");
#endif

#ifdef KRCMAKE_SET_CLANG_C_OPTIONS
    printf("KRCMAKE_SET_CLANG_C_OPTIONS on cxx file\n");
#endif

#ifdef KRCMAKE_SET_CLANG_CXX_OPTIONS
    printf("KRCMAKE_SET_CLANG_CXX_OPTIONS on cxx file\n");
#endif

#ifdef KRCMAKE_SET_MSVC_OPTIONS
    printf("KRCMAKE_SET_MSVC_OPTIONS on cxx file\n");
#endif
}
