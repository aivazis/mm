# -*- cmake -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# build the simple package
function(simple_simplePackage)
  # install the sources straight from the source directory
  install(
    DIRECTORY pkg/simple
    DESTINATION ${SIMPLE_DEST_PACKAGES}
    FILES_MATCHING PATTERN *.py
    )
  # build the package meta-data
  configure_file(
    pkg/simple/meta.py.in pkg/simple/meta.py
    @ONLY
    )
  # install the generated package meta-data file
  install(
    DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/pkg/simple
    DESTINATION ${SIMPLE_DEST_PACKAGES}
    FILES_MATCHING PATTERN *.py
    )
  # all done
endfunction(simple_simplePackage)


# build the simple libraries
function(simple_simpleLib)
  # build the libsimple version file
  configure_file(
    lib/simple/version.h.in lib/simple/version.h
    @ONLY
    )
  # build the libsimple version file
  configure_file(
    lib/simple/version.cc lib/simple/version.cc
    COPYONLY
    )
  # copy the simple headers over to the staging area
  file(GLOB_RECURSE files
       RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/lib/simple
       CONFIGURE_DEPENDS
       lib/simple/*.h lib/simple/*.icc
       )
  foreach(file ${files})
    configure_file(lib/simple/${file} lib/simple/${file} COPYONLY)
  endforeach()

  # the libsimple target
  add_library(simple SHARED)
  # specify the directory for the library compilation products
  simple_library_directory(simple lib)
  # set the include directories
  target_include_directories(
    simple PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/lib>
    $<INSTALL_INTERFACE:${SIMPLE_DEST_INCLUDE}>
    )
  # add the sources
  target_sources(simple
    PRIVATE
    # files
    ${CMAKE_CURRENT_BINARY_DIR}/lib/simple/version.cc
    )
  # and the link dependencies
  target_link_libraries(
    simple
    )

  # install the simple headers
  install(
    DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib/simple
    DESTINATION ${SIMPLE_DEST_INCLUDE}
    FILES_MATCHING PATTERN *.h PATTERN *.icc
    )

  # libsimple
  install(
    TARGETS simple
    EXPORT simple-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )

  # all done
endfunction(simple_simpleLib)


# build the simple extension modules
function(simple_simpleModule)
  # the simple bindings
  Python_add_library(simplemodule MODULE)
  # adjust the name to match what python expects
  set_target_properties(simplemodule PROPERTIES LIBRARY_OUTPUT_NAME simple)
  set_target_properties(simplemodule PROPERTIES SUFFIX ${PYTHON3_SUFFIX})
  # specify the directory for the module compilation products
  simple_library_directory(simplemodule extensions)
  # set the libraries to link against
  target_link_libraries(simplemodule PRIVATE simple pybind11::module)
  # add the sources
  target_sources(simplemodule PRIVATE
    ext/simple/__init__.cc
    ext/simple/api.cc
  )

  # install the simple extensions
  install(
    TARGETS simplemodule
    LIBRARY
    DESTINATION ${SIMPLE_DEST_PACKAGES}/simple/ext
    )
endfunction(simple_simpleModule)


# the scripts
function(simple_simpleBin)
  # install the scripts
  install(
    PROGRAMS bin/simple
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
  # all done
endfunction(simple_simpleBin)


# generate a unique target name
function(simple_target target testfile)
  # split
  get_filename_component(path ${testfile} DIRECTORY)
  get_filename_component(base ${testfile} NAME_WE)

  # replace path separators with dors
  string(REPLACE "/" "." stem ${path})

  # build the target and return it
  set(${target} "${stem}.${base}" PARENT_SCOPE)

  # all done
endfunction()


# specify the directory for the target compilation products
function(simple_target_directory target directory)
  # set output directory for this target to subdirectory {directory} of the build directory
  set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}/${directory}
  )
# all done
endfunction()


# specify the directory for the module
function(simple_library_directory library directory)
  # set output directory for this library to subdirectory {directory} of the build directory
  set_target_properties(${library} PROPERTIES LIBRARY_OUTPUT_DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}/${directory}
  )
# all done
endfunction()


# add definitions to compilation of file
function(simple_add_definitions driverfile)

  # the argument list is the list of definitions
  set(definitions ${ARGN})

  # generate the name of the target
  simple_target(target ${driverfile})

  # for each definition requested
  foreach(definition IN LISTS definitions)
    # apply the definition to the target
    target_compile_definitions(${target} PRIVATE ${definition})
  endforeach()

# all done
endfunction()


# end of file
