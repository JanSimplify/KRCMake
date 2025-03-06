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
