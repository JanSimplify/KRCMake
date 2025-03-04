# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Variables
#=============================

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(INSTALL_CMAKE_MODULE_DIR "${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}")

set(autogen_cmake_config_dir "${PROJECT_BINARY_DIR}/autogen/cmake")
set(install_cmake_config_dir "${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME}")

set(module_files)

#=============================
# Module files
#=============================

install(
    FILES ${module_files}
    DESTINATION "${INSTALL_CMAKE_MODULE_DIR}"
)

#=============================
# Package version
#=============================

set(package_version_file "${autogen_cmake_config_dir}/${PROJECT_NAME}ConfigVersion.cmake")

write_basic_package_version_file(
    "${package_version_file}"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY "AnyNewerVersion"
    ARCH_INDEPENDENT
)

install(
    FILES "${package_version_file}"
    DESTINATION "${install_cmake_config_dir}"
)

#=============================
# Package config
#=============================

set(package_config_file "${autogen_cmake_config_dir}/${PROJECT_NAME}Config.cmake")

configure_package_config_file(
    "ProjectConfig.cmake.in"
    "${package_config_file}"
    INSTALL_DESTINATION "${install_cmake_config_dir}"
    PATH_VARS INSTALL_CMAKE_MODULE_DIR
    NO_SET_AND_CHECK_MACRO
)

install(
    FILES "${package_config_file}"
    DESTINATION "${install_cmake_config_dir}"
)
