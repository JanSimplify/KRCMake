# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify
#[[
MIT License

Copyright (c) 2025 JanSimplify

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

include_guard(GLOBAL)

include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

# krcmake_target_compile_options(
#   TARGETS [targets...]
#   [<PRIVATE|PUBLIC|INTERFACE>
#       [MSVC_OPTIONS <options1>...]
#       [GNU_C_OPTIONS <options2>...]
#       [GNU_CXX_OPTIONS <options3>...]
#       [CLANG_C_OPTIONS <options4>...]
#       [CLANG_CXX_OPTIONS <options5>...]
#   ]...
# )
function(krcmake_target_compile_options)
    set(options)
    set(one_value_keywords)
    set(multi_value_keywords "TARGETS;PUBLIC;INTERFACE;PRIVATE")

    cmake_parse_arguments(
        PARSE_ARGV 0
        "arg"
        "${options}"
        "${one_value_keywords}"
        "${multi_value_keywords}"
    )

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    foreach(class IN ITEMS "PUBLIC" "INTERFACE" "PRIVATE")
        cmake_parse_arguments(
            "arg_${class}"
            ""
            ""
            "MSVC_OPTIONS;GNU_C_OPTIONS;GNU_CXX_OPTIONS;CLANG_C_OPTIONS;CLANG_CXX_OPTIONS"
            ${arg_${class}}
        )

        if(arg_${class}_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "Unparsed ${class} arguments: ${arg_${class}_UNPARSED_ARGUMENTS}")
        endif()

        if(arg_${class}_MSVC_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<OR:$<COMPILE_LANG_AND_ID:C,MSVC>,$<COMPILE_LANG_AND_ID:CXX,MSVC>>:${arg_${class}_MSVC_OPTIONS}>"
            )
        endif()

        if(arg_${class}_GNU_C_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:C,GNU>:${arg_${class}_GNU_C_OPTIONS}>"
            )
        endif()

        if(arg_${class}_GNU_CXX_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:CXX,GNU>:${arg_${class}_GNU_CXX_OPTIONS}>"
            )
        endif()

        if(arg_${class}_CLANG_C_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:C,Clang>:${arg_${class}_CLANG_C_OPTIONS}>"
            )
        endif()

        if(arg_${class}_CLANG_CXX_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:CXX,Clang>:${arg_${class}_CLANG_CXX_OPTIONS}>"
            )
        endif()
    endforeach()

    foreach(target IN LISTS arg_TARGETS)
        target_compile_options(
            "${target}"
            PUBLIC ${PUBLIC_options}
            INTERFACE ${INTERFACE_options}
            PRIVATE ${PRIVATE_options}
        )
    endforeach()
endfunction()

# krcmake_target_link_options(
#   TARGETS [targets...]
#   [BEFORE]
#   [<PRIVATE|PUBLIC|INTERFACE>
#       [MSVC_OPTIONS <options1>...]
#       [GNU_C_OPTIONS <options2>...]
#       [GNU_CXX_OPTIONS <options3>...]
#       [CLANG_C_OPTIONS <options4>...]
#       [CLANG_CXX_OPTIONS <options5>...]
#   ]...
# )
function(krcmake_target_link_options)
    set(options "BEFORE")
    set(one_value_keywords)
    set(multi_value_keywords "TARGETS;PUBLIC;INTERFACE;PRIVATE")

    cmake_parse_arguments(
        PARSE_ARGV 0
        "arg"
        "${options}"
        "${one_value_keywords}"
        "${multi_value_keywords}"
    )

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    foreach(class IN ITEMS "PUBLIC" "INTERFACE" "PRIVATE")
        cmake_parse_arguments(
            "arg_${class}"
            ""
            ""
            "MSVC_OPTIONS;GNU_C_OPTIONS;GNU_CXX_OPTIONS;CLANG_C_OPTIONS;CLANG_CXX_OPTIONS"
            ${arg_${class}}
        )

        if(arg_${class}_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "Unparsed ${class} arguments: ${arg_${class}_UNPARSED_ARGUMENTS}")
        endif()

        if(arg_${class}_MSVC_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<OR:$<COMPILE_LANG_AND_ID:C,MSVC>,$<COMPILE_LANG_AND_ID:CXX,MSVC>>:${arg_${class}_MSVC_OPTIONS}>"
            )
        endif()

        if(arg_${class}_GNU_C_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:C,GNU>:${arg_${class}_GNU_C_OPTIONS}>"
            )
        endif()

        if(arg_${class}_GNU_CXX_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:CXX,GNU>:${arg_${class}_GNU_CXX_OPTIONS}>"
            )
        endif()

        if(arg_${class}_CLANG_C_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:C,Clang>:${arg_${class}_CLANG_C_OPTIONS}>"
            )
        endif()

        if(arg_${class}_CLANG_CXX_OPTIONS)
            list(APPEND "${class}_options"
                "$<$<COMPILE_LANG_AND_ID:CXX,Clang>:${arg_${class}_CLANG_CXX_OPTIONS}>"
            )
        endif()
    endforeach()

    if(arg_BEFORE)
        set(before_option "BEFORE")
    endif()

    foreach(target IN LISTS arg_TARGETS)
        target_link_options(
            "${target}"
            ${before_option}
            PUBLIC ${PUBLIC_options}
            INTERFACE ${INTERFACE_options}
            PRIVATE ${PRIVATE_options}
        )
    endforeach()
endfunction()

# krcmake_target_set_develop_mode(
#   TARGETS [targets...]
#   [WARNING_AS_ERROR]
#   [ERROR_AS_FATAL]
# )
function(krcmake_target_set_develop_mode)
    set(options "WARNING_AS_ERROR;ERROR_AS_FATAL")
    set(one_value_keywords)
    set(multi_value_keywords "TARGETS")

    cmake_parse_arguments(
        PARSE_ARGV 0
        "arg"
        "${options}"
        "${one_value_keywords}"
        "${multi_value_keywords}"
    )

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    # https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
    # https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Dialect-Options.html#C_002b_002b-Dialect-Options
    set(gnu_common_options
        # base
        -Wall
        -Wextra
        # iso
        -pedantic
        -Wdeprecated
        # declaration
        -Wshadow
        -Wundef
        -Wunused-const-variable
        -Wmissing-declarations
        # conversion
        -Wconversion
        -Wsign-conversion
        -Warith-conversion
        -Wcast-qual
        -Wcast-align=strict
        # float
        -Wdouble-promotion
        -Wfloat-equal
        # format
        -Wformat=2
        -Wformat-overflow=2
        -Wformat-truncation=2
        -Wformat-signedness
        # switch case
        -Wimplicit-fallthrough=5
        # flow control statement
        -Wduplicated-cond
        -Wduplicated-branches
        -Wlogical-op
        # others
        -Wmissing-include-dirs
        -Wreturn-type
        -Wnull-dereference
    )

    set(gcc_c_options
        ${gnu_common_options}
        -Wnested-externs
        -Wbad-function-cast
        -Wmissing-prototypes
        -Wstrict-prototypes
    )

    if(CMAKE_C_COMPILER_ID MATCHES "GNU")
        check_c_compiler_flag("-Wmissing-variable-declarations" KRCMAKE_GNU_C_SUPPORT_MISSING_VARIABLE_DECLARATIONS)
        if(KRCMAKE_GNU_C_SUPPORT_MISSING_VARIABLE_DECLARATIONS)
            list(APPEND gcc_c_options "-Wmissing-variable-declarations")
        endif()
    endif()

    set(gcc_cxx_options
        ${gnu_common_options}
        -Wuseless-cast
        -Wold-style-cast
        -Wstrict-null-sentinel
        -Wnon-virtual-dtor
        -Wextra-semi
        -Wcatch-value=3
        -Wplacement-new=2
        -Waligned-new=all
        -Wredundant-tags
        -Wmismatched-tags
        -Wsuggest-final-types
        -Wsuggest-final-methods
        -Wsuggest-override
    )

    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        check_cxx_compiler_flag("-Wnrvo" KRCMAKE_GNU_CXX_SUPPORT_NRVO)
        if(KRCMAKE_GNU_CXX_SUPPORT_NRVO)
            list(APPEND gcc_cxx_options "-Wnrvo")
        endif()
    endif()

    # https://clang.llvm.org/docs/DiagnosticsReference.html
    set(clang_common_options
        # base
        -Wall
        -Wextra
        # iso
        -pedantic
        -Wdeprecated
        # declaration
        -Wshadow-all
        -Wunused-const-variable
        -Wunused-exception-parameter
        -Wundef
        -Wundefined-internal-type
        -Wmissing-prototypes
        # conversion
        -Wconversion
        -Wcast-qual
        -Wcast-align
        # float
        -Wdouble-promotion
        -Wfloat-equal
        # format
        -Wformat=2
        -Wformat-non-iso
        # -Wformat-signedness
        -Wformat-pedantic
        -Wformat-type-confusion
        # switch case
        -Wimplicit-fallthrough
        # flow control statement
        -Wlogical-op-parentheses
        # others
        -Wmissing-include-dirs
        -Wnewline-eof
        -Wundefined-reinterpret-cast
    )

    set(clang_c_develop_options
        ${clang_common_options}
        -Wmissing-prototypes
        -Wmissing-variable-declarations
    )

    set(clang_cxx_options
        ${clang_common_options}
        -Wold-style-cast
        -Woverloaded-virtual
        -Wnon-virtual-dtor
        -Wextra-semi
        -Wextra-semi-stmt
        -Wsuggest-override
    )

    # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level
    # https://learn.microsoft.com/en-us/cpp/preprocessor/compiler-warnings-that-are-off-by-default
    # https://github.com/dotnet/project-system/issues/5352
    set(msvc_options
        # base
        /W4
        # iso
        /permissive-
        /we4289
        # declaration
        /w44668
        # conversion
        /w44242 # narrow cast
        /w44254 # narrowly cast field bits
        /w44365 # conversion from signed to unsigned
        /w44287 # unsigned/negative constant mismatch
        /w44800 # other type to bool
        /w44388
        /w44296 # test unsigned less 0, or greater equal 0
        /w44165 # test HRESULT
        /w44905 # LPSTR
        /w44906 # LPWSTR
        /w44191 # bad function ptr cast
        # /w44311 # pointer truncation
        /w44946
        # switch case
        /w44062 # missing case label and no default
        # other
        /w44255 # strict prototypes, C only
        /w44464 # include <../xx.h>
        /w44746 # a volatile variable is accessed directly
        /w44555
        /w44768
        /w44545
        /w44546
        /w44547
        /w44549
        /w44608
        # C++
        /w44263 # function hide virtual functions from base class
        /w44265 # has virtual member function with non-virtual dtor
        /w44355 # using this in initializer list
        /w44471 # enum forward declaration without underlying type
    )

    krcmake_target_compile_options(
        TARGETS ${arg_TARGETS}
        PRIVATE
            GNU_C_OPTIONS ${gcc_c_options}
            GNU_CXX_OPTIONS ${gcc_cxx_options}
            CLANG_C_OPTIONS ${clang_c_develop_options}
            CLANG_CXX_OPTIONS ${clang_cxx_options}
            MSVC_OPTIONS ${msvc_options}
    )

    if(arg_WARNING_AS_ERROR)
        krcmake_target_compile_options(
            TARGETS ${arg_TARGETS}
            PRIVATE
                GNU_C_OPTIONS -Werror
                GNU_CXX_OPTIONS -Werror
                CLANG_C_OPTIONS -Werror
                CLANG_CXX_OPTIONS -Werror
                MSVC_OPTIONS /WX
        )
        krcmake_target_link_options(
            TARGETS ${arg_TARGETS}
            PUBLIC
                MSVC_OPTIONS /WX
        )
    endif()

    if(arg_ERROR_AS_FATAL)
        krcmake_target_compile_options(
            TARGETS ${arg_TARGETS}
            PRIVATE
                GNU_C_OPTIONS -Wfatal-errors
                GNU_CXX_OPTIONS -Wfatal-errors
                CLANG_C_OPTIONS -Wfatal-errors
                CLANG_CXX_OPTIONS -Wfatal-errors
        )
    endif()
endfunction()
