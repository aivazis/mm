# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- libraries.init}

# the list of libraries encountered
libraries ?=

# the libraries constructor
#  usage: libraries.init {project instance} {library name}
define libraries.init =
    # local assignments
    ${eval project := $(1)}
    ${eval library := $(2)}

    # add it to the pile
    ${eval libraries += $(library)}
    # save the project
    ${eval $(library).project := $(project)}
    # the stem for generating library specific names; it can get used to build the archive
    # name and the include directory with the public headers
    ${eval $(library).stem ?=}
    # form the name
    ${eval $(library).name := lib$($(library).stem)}
    # the name of the archive
    ${eval $(library).archive = $($(library).name)$(builder.ext.lib)}

    # the list of dependencies as requested by the user
    ${eval $(library).extern ?=}
    # initialize the list of requested project dependencies
    ${eval $(library).extern.requested := ${call library.extern.requested,$(library)}}
    # the list of external dependencies that we have support for
    ${eval $(library).extern.supported ?= ${call library.extern.supported,$(library)}}
    # the list of dependecies in the order they affect the compiler command lines
    ${eval $(library).extern.available ?= ${call library.extern.available,$(library)}}

    # build locations
    # the destination for the archive
    ${eval $(library).libdir = $(builder.libdir)}
    # the destination for the public headers
    ${eval $(library).incdir = $(builder.incdir)/$($(library).stem)}
    # the location of the build transients
    ${eval $(library).tmpdir = $(builder.tmpdir)/$(project)/$($(library).name)}

    # artifacts
    # the root of the library source tree relative to the project home
    ${eval $(library).root ?= lib/lib$($(library).stem)}
    # the absolute path to the library source tree
    ${eval $(library).prefix ?= $($($(library).project).home)/$($(library).root)}

    # the directory structure
    ${eval $(library).directories ?= ${call library.directories,$(library)}}
    # the list of sources
    ${eval $(library).sources ?= ${call library.sources,$(library)}}
    # the public headers
    ${eval $(library).headers ?=${call library.headers,$(library)}}

    # derived artifacts
    # the compile products
    $(library).staging.objects = ${call library.objects,$(library)}
    # the archive
    $(library).staging.archive = $($(library).libdir)/$($(library).archive)
    # the include directories in the staging area
    $(library).staging.incdirs = ${call library.staging.incdirs,$(library)}
    # the public headers in the staging area
    $(library).staging.headers = ${call library.staging.headers,$(library)}

    # implement the external protocol
    $(library).dir ?= $(builder.root)
    # compile time
    $(library).flags ?=
    $(library).defines ?=
    $(library).incpath ?= $(builder.incdir) # note: NOT ($(library).incdir)
    # link time
    $(library).ldflags ?=
    $(library).libpath ?= $(builder.libdir) # that's where we put it
    $(library).libraries ?= $($(library).stem) # that's what we call it

    # documentation
    $(library).meta.categories := general extern locations artifacts derived external

    # category documentation
    $(library).metadoc.general := "general information"
    $(library).metadoc.extern := "dependencies to external packages"
    $(library).metadoc.locations := "the locations of the build products"
    $(library).metadoc.artifacts := "information about the sources"
    $(library).metadoc.derived := "the compiled products"
    $(library).metadoc.external := "how to compile and link against this library"

    # build a list of all project attributes by category
    $(library).meta.general := name stem
    $(library).meta.extern := extern.requested extern.supported extern.available
    $(library).meta.locations := incdir libdir tmpdir
    $(library).meta.artifacts := root prefix directories sources headers
    $(library).meta.derived := staging.archive staging.objects staging.incdirs staging.headers
    $(library).meta.external := flags defines incpath ldflags libpath libraries

    # document each one
    # general
    $(library).metadoc.name := "the name of the library"
    $(library).metadoc.stem := "the stem for generating product names"
    # dependencies
    $(library).metadoc.extern.requested := "requested dependencies"
    $(library).metadoc.extern.supported := "the dependencies for which there is mm support"
    $(library).metadoc.extern.available := "dependencies that were actually found and used"
    # locations
    $(library).metadoc.libdir := "the destination of the archive"
    $(library).metadoc.incdir := "the destination of the public headers"
    $(library).metadoc.tmpdir = "the staging area for object modules"
    # artifacts
    $(library).metadoc.root := "the path to the library sources relative to the project directory"
    $(library).metadoc.prefix := "the absolute path to the root of the library source tree"
    $(library).metadoc.directories := "the source directory structure"
    $(library).metadoc.sources := "the archive sources"
    $(library).metadoc.headers := "the public headers"
    # derived
    $(library).metadoc.staging.archive = "the archive"
    $(library).metadoc.staging.objects = "the object modules"
    $(library).metadoc.staging.incdirs = "the header directory structure"
    $(library).metadoc.staging.headers = "the public headers files"
    # external
    $(library).metadoc.flags := "compiler flags"
    $(library).metadoc.defines := "preprocessor macros"
    $(library).metadoc.incpath := "tell the compiler where the headers are"
    $(library).metadoc.ldflags := "link time flags"
    $(library).metadoc.libpath := "the path to the archives"
    $(library).metadoc.libraries := "the list of archives to place on the link line"

# all done
endef

# methods

# build the set of library directories
#   usage: library.directories {library}
define library.directories
    ${strip
        ${shell find $($(library).prefix) -type d}
    }
endef

# build the set of archive sources
#   usage: library.sources {library}
define library.sources
    ${strip
        ${foreach directory, $($(library).directories),
            ${wildcard
                ${addprefix $(directory)/*.,$(languages.sources)}
            }
        }
    }
endef

# build the set of archive headers
#   usage: library.headers {library}
define library.headers
    ${strip
        ${foreach directory, $($(library).directories),
            ${wildcard
                ${addprefix $(directory)/*.,$(languages.headers)}
            }
        }
    }
endef


# build the set of archive objects
#   usage: library.objects {library}
define library.objects =
    ${addprefix $($(library).tmpdir)/,
        ${addsuffix $(builder.ext.obj),
            ${subst /,~,
                ${basename
                    ${subst $($(library).prefix)/,,$($(library).sources)}
                }
            }
        }
    }
endef


# build the name of an object given the name of a source
#   usage library.staging.object: {library} {source}
library.staging.object = \
    $($(1).tmpdir)/${subst /,~,${basename ${subst $($(1).prefix)/,,$(2)}}}$(builder.ext.obj)


# build the list of staging directories for the public headers
#   usage: library.staging.incdirs {library}
define library.staging.incdirs
    ${subst $($(library).prefix),$($(library).incdir),$($(library).directories)}
endef


# build the path of the staging directory for a public header
#   usage: library.staging.incdir {library} {header}
define library.staging.incdir
    ${dir
        ${subst $($(library).prefix),$($(library).incdir),$(header)}
    }
endef


# build the list of the paths of the library public headers
#   usage: library.staging.headers {library}
define library.staging.headers
    ${subst $($(library).prefix),$($(library).incdir),$($(library).headers)}
endef


# build the path to the library public header
#   usage: library.staging.header {library} {header}
define library.staging.header
    ${subst $($(library).prefix),$($(library).incdir),$(header)}
endef


# build the set of library external dependencies requested by the user
#  usage library.extern.requested {library}
define library.extern.requested =
    ${strip $($(library).extern)}
endef


# build the set of library external dependencies that are supported
#  usage library.extern.requested {library}
define library.extern.supported =
    ${call extern.is.supported,$($(library).extern.requested)}
endef


# build the set of library external dependencies that are available
#  usage library.extern.requested {library}
define library.extern.available =
    ${call extern.is.available,$($(library).extern.supported)}
endef


# show me
# ${info -- done with libraries.init}

# end of file
