# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/irrlicht)
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Firrlicht%2Ffiles%2FIrrlicht%2520SDK%2F1.8%2F1.8.4%2Firrlicht-1.8.4.zip%2Fdownload%3Fuse_mirror%3Dautoselect&ts=1548986584&use_mirror=autoselect"
    FILENAME "irrlicht-1.8.4.zip"
    SHA512 de69ddd2c6bc80a1b27b9a620e3697b1baa552f24c7d624076d471f3aecd9b15f71dce3b640811e6ece20f49b57688d428e3503936a7926b3e3b0cc696af98d1
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH ${SOURCE_PATH}
    ARCHIVE ${ARCHIVE}
    REF 1.8.4
    # [NO_REMOVE_ONE_LEVEL]
    # [WORKING_DIRECTORY <${CURRENT_BUILDTREES_DIR}/src>]
    # [PATCHES <a.patch>...]
)

# Copy CMakeLists.txt to the source, because Irrlicht does not have one.
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

set(FAST_MATH FALSE)
if("fast-fpu" IN_LIST FEATURES)
    set(FAST_MATH TRUE)
endif()
set(SHARED_LIB TRUE)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(SHARED_LIB FALSE)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    #PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS 
        -DIRR_SHARED_LIB=${SHARED_LIB} 
        -DIRR_FAST_MATH=${FAST_MATH}
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Handle copyright
file(WRITE ${CURRENT_PACKAGES_DIR}/share/irrlicht/copyright "
The Irrlicht Engine License
===========================

Copyright (C) 2002-2015 Nikolaus Gebhardt

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be clearly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.")

vcpkg_copy_pdbs()

# Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME irrlicht)
