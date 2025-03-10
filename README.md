[![CMake on multiple platforms](https://github.com/JanSimplify/KRCMake/actions/workflows/cmake-multi-platform.yml/badge.svg)](https://github.com/JanSimplify/KRCMake/actions/workflows/cmake-multi-platform.yml)

# KRCMake

CMake跨平台开发实用脚本，功能包括：

- 获取Git信息；
- 为特定编译器设置编译与链接选项；
- 设置严格的编译器警告选项、sanitizer选项以及代码覆盖率分析选项。

测试于：

- Ubuntu：GCC，Clang；
- Windows：MSVC。

macOS&AppleClang、Windows&Clang-cl以及CUDA等编译器与平台组合暂未测试。

## 使用方法

使用FetchContent导入项目：

```cmake
include(FetchContent)

FetchContent_Declare(
    KRCMake
    GIT_REPOSITORY https://github.com/JanSimplify/KRCMake.git
    GIT_TAG main
    SYSTEM
    FIND_PACKAGE_ARGS
)

FetchContent_MakeAvailable(KRCMake)
```

根据需要引入对应的模块：

```cmake
# 获取git信息
include(KRDevGitInfo)
# 设置编译选项等
include(KRDevCompilerOption)
```

## 获取Git提交信息

### krcmake_get_git_describe

调用`git describe`获取相应的描述信息：

```cmake
krcmake_get_git_describe(
    OUTPUT_VARIABLE <outvar>
    WORKING_DIRECTORY <dir>
    [QUIET]
    [ALL]
    [DIRTY]
    [ALWAYS]
    [LONG]
)
```

其中：

- `OUTPUT_VARIABLE`：输出变量；
- `WORKING_DIRECTORY`：`git`的工作目录；
- `QUIET`：忽略错误；
- 其他选项直接对应`git describe`命令行选项，功能请查阅`git`手册。

### krcmake_get_git_hash

调用`git rev-parse HEAD`获取提交HASH：

```cmake
krcmake_get_git_hash(
    OUTPUT_VARIABLE <outvar>
    WORKING_DIRECTORY <dir>
    [QUIET]
)
```

其中：

- `OUTPUT_VARIABLE`：输出变量；
- `WORKING_DIRECTORY`：`git`的工作目录；
- `QUIET`：忽略错误。

## 编译器和链接器选项

### krcmake_target_compile_options

为特定编译器以及语言设置相应的编译选项：

```cmake
krcmake_target_compile_options(
    TARGETS [targets...]
    [<PRIVATE|PUBLIC|INTERFACE>
        [MSVC_OPTIONS <options1>...]
        [GNU_C_OPTIONS <options2>...]
        [GNU_CXX_OPTIONS <options3>...]
        [CLANG_C_OPTIONS <options4>...]
        [CLANG_CXX_OPTIONS <options5>...]
    ]...
)
```

以设置编译器诊断信息为例：

```cmake
krcmake_target_compile_options(
    TARGETS <YourTargets>
    PRIVATE
        MSVC_OPTIONS /W4
        GNU_C_OPTIONS -Wall -Wextra
        GNU_CXX_OPTIONS -Wall -Wextra
        CLANG_C_OPTIONS -Wall -Wextra
        CLANG_CXX_OPTIONS -Wall -Wextra
)
```

### krcmake_target_link_options

为特定编译器以及语言设置相应的编译选项：

```cmake
krcmake_target_link_options(
    TARGETS [targets...]
    [BEFORE]
    [<PRIVATE|PUBLIC|INTERFACE>
        [MSVC_OPTIONS <options1>...]
        [GNU_C_OPTIONS <options2>...]
        [GNU_CXX_OPTIONS <options3>...]
        [CLANG_C_OPTIONS <options4>...]
        [CLANG_CXX_OPTIONS <options5>...]
    ]...
)
```

`BEFORE`指定将新增字段添加至已有链接选项的前面。

## 辅助函数

### krcmake_target_set_develop_mode

设置严格的编译器诊断选项，包括但不限于`-Wall`和`-Wextra`：

```cmake
krcmake_target_set_develop_mode(
    TARGETS [targets...]
    [WARNING_AS_ERROR]
    [ERROR_AS_FATAL]
)
```

详细信息请查看`KRCMakeCompileOptions.cmake`文件。剩余两个参数用于提升错误级别：

- `WARNING_AS_ERROR`：将警告视为错误；
- `ERROR_AS_FATAL`：将错误视为致命错误，通常导致立即停止后续处理。

注意：`MSVC`不支持`ERROR_AS_FATAL`功能，将静默忽略。

### krcmake_target_set_sanitizer

设置sanitizer编译和链接选项：

```cmake
# krcmake_target_set_sanitizer(
#   TARGETS [targets...]
#   [ADDRESS]
#   [UNDEFINED]
# )
```

注意：`MSVC`不支持`UNDEFINED`选项，静默忽略。

### krcmake_target_set_coverage

设置coverage选项：

```cmake
krcmake_target_set_coverage(
    TARGETS [targets...]
)
```

注意：`MSVC`下静默忽略。
