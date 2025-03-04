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

find_package(Git QUIET)

# krcmake_get_git_describe(
#   OUTPUT_VARIABLE <outvar>
#   WORKING_DIRECTORY <dir>
#   [QUIET]
#   [ALL]
#   [DIRTY]
#   [ALWAYS]
#   [LONG]
# )
function(krcmake_get_git_describe)
    set(options "QUIET;ALL;DIRTY;ALWAYS;LONG")
    set(one_value_keywords "OUTPUT_VARIABLE;WORKING_DIRECTORY")
    set(multi_value_keywords)

    cmake_parse_arguments(
        PARSE_ARGV 0
        "arg"
        "${options}"
        "${one_value_keywords}"
        "${multi_value_keywords}"
    )

    if(NOT arg_OUTPUT_VARIABLE)
        message(FATAL_ERROR "Missing required value: OUTPUT_VARIABLE")
    endif()

    if(arg_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Missing required value: ${arg_KEYWORDS_MISSING_VALUES}")
    endif()

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT Git_FOUND)
        if(NOT arg_QUIET)
            message(
                FATAL_ERROR
                "Could not find \"Git\" package configuration file."
            )
        endif()
        return()
    endif()

    set(command_options)

    if(arg_ALL)
        list(APPEND command_options "--all")
    endif()

    if(arg_DIRTY)
        list(APPEND command_options "--dirty")
    endif()

    if(arg_ALWAYS)
        list(APPEND command_options "--always")
    endif()

    if(arg_LONG)
        list(APPEND command_options "--long")
    endif()

    set(cmd_args
        COMMAND "${GIT_EXECUTABLE}" describe ${command_options}
        WORKING_DIRECTORY "${arg_WORKING_DIRECTORY}"
        RESULT_VARIABLE result
        OUTPUT_VARIABLE git_describe
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(arg_QUIET)
        list(APPEND cmd_args "ERROR_QUIET")
    endif()

    execute_process(${cmd_args})

    if(result AND NOT arg_QUIET)
        message(FATAL_ERROR "Failed to get git description: ${result}")
    endif()

    set("${arg_OUTPUT_VARIABLE}" "${git_describe}" PARENT_SCOPE)
endfunction()

# krcmake_get_git_hash(
#   OUTPUT_VARIABLE <outvar>
#   WORKING_DIRECTORY <dir>
#   [QUIET]
# )
function(krcmake_get_git_hash)
    set(options "QUIET")
    set(one_value_keywords "OUTPUT_VARIABLE;WORKING_DIRECTORY")
    set(multi_value_keywords)

    cmake_parse_arguments(
        PARSE_ARGV 0
        "arg"
        "${options}"
        "${one_value_keywords}"
        "${multi_value_keywords}"
    )

    if(NOT arg_OUTPUT_VARIABLE)
        message(FATAL_ERROR "Missing required value: OUTPUT_VARIABLE")
    endif()

    if(arg_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Missing required value: ${arg_KEYWORDS_MISSING_VALUES}")
    endif()

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unparsed arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT Git_FOUND)
        if(NOT arg_QUIET)
            message(
                FATAL_ERROR
                "Could not find \"Git\" package configuration file."
            )
        endif()
        return()
    endif()

    set(cmd_args
        COMMAND "${GIT_EXECUTABLE}" rev-parse HEAD
        WORKING_DIRECTORY "${arg_WORKING_DIRECTORY}"
        RESULT_VARIABLE result
        OUTPUT_VARIABLE git_hash
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(arg_QUIET)
        list(APPEND cmd_args "ERROR_QUIET")
    endif()

    execute_process(${cmd_args})

    if(result AND NOT arg_QUIET)
        message(FATAL_ERROR "Failed to get git hash: ${result}")
    endif()

    set("${arg_OUTPUT_VARIABLE}" "${git_hash}" PARENT_SCOPE)
endfunction()
