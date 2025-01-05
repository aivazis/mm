# -*- cmake -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2025 all rights reserved

# cmake expectations
cmake_minimum_required(VERSION 3.24)

# adjust the include path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/.cmake)
# get support
include(simple_init)

# ask git for the simple version
simple_getVersion()

# set up the project
project(SIMPLE VERSION "${SIMPLE_VERSION}" LANGUAGES CXX)
set(MAJOR ${PROJECT_VERSION_MAJOR})
set(MINOR ${PROJECT_VERSION_MINOR})
set(MICRO ${PROJECT_VERSION_PATCH})

# hmmmmm
include(GNUInstallDirs)

# RPATH handling
# https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
# use, i.e. don't skip the full RPATH for the build tree
set(CMAKE_SKIP_BUILD_RPATH FALSE)
# when building, don't use the install RPATH already
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
# (but later on when installing)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_FULL_LIBDIR}")
# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
if(NOT (CMAKE_INSTALL_FULL_LIBDIR IN_LIST
        CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES))
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_FULL_LIBDIR}")
endif()

# load the project definitions
include(simple)

# python
find_package(Python 3.9
    COMPONENTS Interpreter Development.Module NumPy
    OPTIONAL_COMPONENTS Development.Embed)

# for building bindings
# require c++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(PYBIND11_CPP_STANDARD -std=c++17)
set(PYBIND11_PYTHON_VERSION ${Python_VERSION})
set(PYBIND11_FINDPYTHON ON) # Use new FindPython if available
find_package(pybind11)

# set up cmake
simple_cmakeInit()
# set up python
simple_pythonInit()
# initialize the variables that describe the staging directory layout
simple_stagingInit()
# initialize the variables that describe the install directory layout
simple_destinationInit()

# visit subdirectories
include(simple_packages)
include(simple_lib)
include(simple_extensions)
include(simple_bin)

# make exports available in binary dir during build
export(EXPORT simple-targets
       NAMESPACE simple::
       )


# end of file
