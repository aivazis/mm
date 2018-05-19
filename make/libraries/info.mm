# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- libraries.info}

# library help
# usage: libraries.info.header {library names}
define libraries.info.header =
# make the recipe
libraries.info: mm.banner
	$(log) "known libraries: "$(palette.purple)$(1)$(palette.normal)
	$(log) "to build one of them, use its name as a target"
	$(log)
	$(log) "    mm ${firstword $(1)}"
	$(log)
	$(log) "to get more information about a specific library, use"
	$(log)
	$(log) "    mm ${firstword $(1)}.info"
	$(log)
# all done
endef

# make a recipe to log the metadata of a specific library
# usage: library.recipes.info {library}
define library.recipes.info =
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
# usage: library.recipes.info.directories
define library.recipes.info.directories =
# make the recipe
$(1).info.directories:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  source directories",}
	${foreach directory,$($(1).directories),$(log) $(log.indent)$(directory);}
# all done
endef

# make a recipe that prints the set of sources that comprise a library
# usage: library.recipes.info.sources
define library.recipes.info.sources =
# make the recipe
$(1).info.sources:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  sources",}
	${foreach source,$($(1).sources),$(log) $(log.indent)$(source);}
# all done
endef

# make a recipe that prints the set of public headers of a library
# usage: library.recipes.info.headers
define library.recipes.info.headers =
# make the recipe
$(1).info.headers:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  headers",}
	${foreach header,$($(1).headers),$(log) $(log.indent)$(header);}
# all done
endef

# make a recipe that prints the set of objects of a library
# usage: library.recipes.info.objects
define library.recipes.info.objects =
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
# usage: library.recipes.info.includes
define library.recipes.info.incdirs =
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
# usage: library.recipes.info {library}
define library.recipes.help =
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

# make the library specific info and help targets
# isage library.recipes {libraries}
define library.recipes =
    # make the header
    ${call libraries.info.header,$(1)}
    # make indvidual library targets
    ${foreach library, $(1),
        # info recipes: show values
        ${call library.recipes.info,$(library)}
        ${call library.recipes.info.directories,$(library)}
        ${call library.recipes.info.sources,$(library)}
        ${call library.recipes.info.headers,$(library)}
        ${call library.recipes.info.incdirs,$(library)}
        ${call library.recipes.info.objects,$(library)}
        # help recipes: show documentation
        ${call library.recipes.help,$(library)}
    }
# all done
endef

# show me
# ${info -- done with libraries.info}

# end of file
