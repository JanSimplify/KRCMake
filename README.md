[![CMake on multiple platforms](https://github.com/JanSimplify/KRCMake/actions/workflows/cmake-multi-platform.yml/badge.svg)](https://github.com/JanSimplify/KRCMake/actions/workflows/cmake-multi-platform.yml)

# KRCMake

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
