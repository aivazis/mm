# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- libraries.info}


# bootstrap
# make the library specific targets
#  usage: library.workflows {libraries}
define library.workflows =
    # build recipes
    ${call library.workflow,$(library)}
    # info recipes: show values
    ${call library.workflows.info,$(library)}
    ${call library.workflows.info.directories,$(library)}
    ${call library.workflows.info.sources,$(library)}
    ${call library.workflows.info.headers,$(library)}
    ${call library.workflows.info.incdirs,$(library)}
    ${call library.workflows.info.objects,$(library)}
    # help recipes: show documentation
    ${call library.workflows.help,$(library)}
# all done
endef


# build targets
# targetfactory for building a library
define library.workflow =
# the main recipe
$(library): $(library).directories $(library).assets
	${call log.asset,"library",$(library)}

$(library).directories: $($(library).libdir) $($(library).staging.incdirs) $($(library).tmpdir)

$($(library).libdir) $($(library).staging.incdirs) $($(library).tmpdir):
	$(mkdirp) $$@
	${call log.action,"mkdir",$$@}

$(library).assets: $(library).headers $(library).archive

$(library).headers: $($(library).staging.headers)

# make the rules that publish the exported headers
${foreach header, $($(library).headers), \
    ${eval ${call library.workflow.header $(library),$(header)}}
}

$(library).archive: $($(library).staging.archive)

$($(library).staging.archive): $($(library).staging.objects)
	$(ar.create) $$@ $($(library).staging.objects)
	${call log.action,"ar",archive}

# make the rules that compile the archive sources
${foreach source,$($(library).sources), \
    ${eval ${call library.workflow.object,$(library),$(source)}}
}

# all done
endef


# helpers
# library headers
define library.workflow.header =
# publish public headers
$($(library).incdir)/$(header): $($(library).prefix)/$(header) \
                                ${dir $($(library).incdir)/$(header)}
	$(cp) $$< $$@
	${call log.action,"publish",$(header)}
# all done
endef


# library objects
define library.workflow.object =

    # compute the absolute path of the source
    ${eval source.path := $($(library).prefix)/$(source)}
    # and the path to the object module
    ${eval source.object := $($(library).tmpdir)/${call library.object,$(source)}}
    # figure out the source language
    ${eval source.language := $(ext${suffix $(source)})}

# compile source files
$(source.object): $(source.path)
	${call log.action,"$(source.language)","$(source)"}
	${call $(source.language).compile,$(source.object),$(source.path)}

# all done
endef


# library help
# make the recipe
libraries.info: mm.banner
	$(log) "known libraries: "$(palette.purple)$(libraries)$(palette.normal)
	$(log)
	$(log) "to build one of them, use its name as a target"
	$(log) "    mm ${firstword $(libraries)}"
	$(log)
	$(log) "to get more information about a specific library, use"
	$(log) "    mm ${firstword $(libraries)}.info"
	$(log)


# make a recipe to log the metadata of a specific library
# usage: library.workflows.info {library}
define library.workflows.info =
# make the recipe
$(1).info:
	${call log.sec,$(1),"a library in project '$($(library).project)'"}
	$(log)
	${foreach category,$($(library).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.var,$(1).$(var),$$($(1).$(var))}; \
             } \
        } \
	$(log)
	$(log) "for an explanation of their purpose, try"
	$(log)
	$(log) "    mm $(1).help"
	$(log)
	$(log) "related targets:"
	$(log)
	${call log.help,$(1).info.directories,"the layout of the source directories"}
	${call log.help,$(1).info.sources,"the source files"}
	${call log.help,$(1).info.headers,"the header files"}
	${call log.help,$(1).info.incdirs,"the include directories in the staging area"}
	${call log.help,$(1).info.objects,"the object files in the staging area"}
# all done
endef


# make a recipe that prints the directory layout of the sources of a library
# usage: library.workflows.info.directories
define library.workflows.info.directories =
# make the recipe
$(1).info.directories:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  source directories",}
	${foreach directory,$($(1).directories),$(log) $(log.indent)$(directory);}
# all done
endef


# make a recipe that prints the set of sources that comprise a library
# usage: library.workflows.info.sources
define library.workflows.info.sources =
# make the recipe
$(1).info.sources:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  sources",}
	${foreach source,$($(1).sources),$(log) $(log.indent)$(source);}
# all done
endef


# make a recipe that prints the set of public headers of a library
# usage: library.workflows.info.headers
define library.workflows.info.headers =
# make the recipe
$(1).info.headers:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  headers",}
	${foreach header,$($(1).headers),$(log) $(log.indent)$(header);}
# all done
endef


# make a recipe that prints the set of objects of a library
# usage: library.workflows.info.objects
define library.workflows.info.objects =
# make the recipe
$(1).info.objects:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.var,"tmpdir",$($(1).tmpdir)}
	${call log.sec,"  objects",}
	${foreach object,$($(1).staging.objects), \
           $(log) $(log.indent)${subst $($(1).tmpdir)/,,$(object)} ; }
# all done
endef


# make a recipe that prints the set of includes of a library
# usage: library.workflows.info.includes
define library.workflows.info.incdirs =
# make the recipe
$(1).info.incdirs:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.var,"incdir",$($(1).incdir)}
	${call log.sec,"  include directory structure",}
	${foreach directory,$($(1).staging.incdirs), \
           $(log) $(log.indent)${subst $($(1).incdir)/,,$(directory)} ; }
# all done
endef


# make a recipe to show the metadata documentation of a specific library
# usage: library.workflows.info {library}
define library.workflows.help =
# make the recipe
$(1).help:
	$(log)
	${call log.sec,$(1),library attributes}
	$(log)
	${foreach category,$($(library).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.help,$(1).$(var),$($(1).metadoc.$(var))}; \
             } \
        } \
	$(log)
	$(log) "for a listing of their values, try"
	$(log)
	$(log) "    mm $(1).info"
	$(log)
# all done
endef


# show me
# ${info -- done with libraries.info}

# end of file
