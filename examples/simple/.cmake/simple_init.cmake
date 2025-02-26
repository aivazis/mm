# -*- cmake -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2025 all rights reserved


# setup cmake
function(simple_cmakeInit)
  # get the source directory
  get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
  # get the staging directory
  get_filename_component(stgdir "${CMAKE_BINARY_DIR}" REALPATH)
  # if we are building within the source directory
  if ("${srcdir}" STREQUAL "${stgdir}")
    # complain and bail
    message(FATAL_ERROR "in-source build detected; please run cmake in a build directory")
  endif()

  # host info
  # get
  string(TOLOWER ${CMAKE_HOST_SYSTEM_NAME} HOST_OS)
  string(TOLOWER ${CMAKE_HOST_SYSTEM_PROCESSOR} HOST_ARCH)
  # export
  set(HOST_OS ${HOST_OS} PARENT_SCOPE)
  set(HOST_ARCH ${HOST_ARCH} PARENT_SCOPE)
  set(HOST_PLATFORM ${HOST_OS}_${HOST_ARCH} PARENT_SCOPE)

  # quiet install
  set(CMAKE_INSTALL_MESSAGE LAZY PARENT_SCOPE)

  # all done
endfunction(simple_cmakeInit)


# setup python
function(simple_pythonInit)
  # save the module suffix
  set(PYTHON3_SUFFIX ".${Python_SOABI}${CMAKE_SHARED_MODULE_SUFFIX}" PARENT_SCOPE)
  # all done
endfunction(simple_pythonInit)


# describe the layout of the staging area
function(simple_stagingInit)
  # the layout
  set(SIMPLE_STAGING_PACKAGES ${CMAKE_BINARY_DIR}/packages PARENT_SCOPE)
  # all done
endfunction(simple_stagingInit)


# describe the installation layout
function(simple_destinationInit)
  # create variables to hold the roots in the install directory
  set(SIMPLE_DEST_INCLUDE ${CMAKE_INSTALL_INCLUDEDIR} PARENT_SCOPE)
  set(SIMPLE_DEST_SHARE ${CMAKE_INSTALL_PREFIX}/share PARENT_SCOPE)
  if(NOT DEFINED SIMPLE_DEST_PACKAGES)
      set(SIMPLE_DEST_PACKAGES ${Python_SITEARCH} CACHE STRING
          "Python package install location, absolute or relative to install prefix")
  endif()
  # Translate to unconditional absolute path
  get_filename_component(SIMPLE_DEST_FULL_PACKAGES ${SIMPLE_DEST_PACKAGES} ABSOLUTE
                         BASE_DIR ${CMAKE_INSTALL_PREFIX})
  set(SIMPLE_DEST_FULL_PACKAGES ${SIMPLE_DEST_FULL_PACKAGES} PARENT_SCOPE)
  # all done
  endfunction(simple_destinationInit)


# ask git for the most recent tag and use it to build the version
function(simple_getVersion)
  # git
  find_package(Git REQUIRED)
  # get tag info
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --tags --long --always
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    RESULT_VARIABLE GIT_DESCRIBE_STATUS
    OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if(NOT "${GIT_DESCRIBE_STATUS}" STREQUAL "0")
    message(FATAL_ERROR "git describe --tags --long --always failed")
  endif()

  set(GIT_DESCRIBE "v([0-9]+)\\.([0-9]+)\\.([0-9]+)-([0-9]+)-g(.+)" )
  if(NOT GIT_DESCRIBE_VERSION MATCHES ${GIT_DESCRIBE})
    message(FATAL_ERROR "Invalid version string: ${GIT_DESCRIBE_VERSION}")
  endif()

  # parse the bits
  string(REGEX REPLACE ${GIT_DESCRIBE} "\\1" REPO_MAJOR ${GIT_DESCRIBE_VERSION} )
  string(REGEX REPLACE ${GIT_DESCRIBE} "\\2" REPO_MINOR ${GIT_DESCRIBE_VERSION})
  string(REGEX REPLACE ${GIT_DESCRIBE} "\\3" REPO_MICRO ${GIT_DESCRIBE_VERSION})
  string(REGEX REPLACE ${GIT_DESCRIBE} "\\5" REPO_COMMIT ${GIT_DESCRIBE_VERSION})

  set(SIMPLE_VERSION "${REPO_MAJOR}.${REPO_MINOR}.${REPO_MICRO}" PARENT_SCOPE)
  set(REVISION ${REPO_COMMIT} PARENT_SCOPE)
  string(TIMESTAMP TODAY PARENT_SCOPE)

  # all done
endfunction(simple_getVersion)


# end of file
