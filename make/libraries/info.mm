# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- libraries.info}


# library help
# make the recipe
libraries.info: mm.banner
	@$(log) "known libraries: "$(palette.targets)$(libraries)$(palette.normal)
	@$(log)
	@$(log) "to build one of them, use its name as a target"
	@$(log) "    mm ${firstword $(libraries)}"
	@$(log)
	@$(log) "to get more information about a specific library, use"
	@$(log) "    mm ${firstword $(libraries)}.info"
	@$(log)


# bootstrap
# make the library specific targets
#  usage: library.workflows {library}
define libraries.workflows =
    # build recipes
    ${call library.workflows.build,$(1)}
    # info recipes: show values
    ${call library.workflows.info,$(1)}
    # help recipes: show documentation
    ${call library.workflows.help,$(1)}
# all done
endef


# build targets
# target factory for building a library
#   usage: library.workflows.build {library}
define library.workflows.build =
# the main recipe
$(1): $(1).prerequisites $(1).directories $(1).assets
	@${call log.asset,"lib",$(1)}

$(1).prerequisites: $($(1).prerequisites)

$(1).directories: $($(1).libdir) $($(1).staging.incdirs) $($(1).tmpdir)

${if ${findstring $($(1).libdir),$(builder.dest.lib)},,$($(1).libdir)} \
$($(1).staging.incdirs) $($(1).tmpdir):
	$(mkdirp) $$@
	@${call log.action,"mkdir",$$@}

$(1).assets: $(1).headers.master $(1).headers ${call library.workflows.assets.archives,$(1)}

$(1).headers.master: $($(1).staging.headers.master)

$(1).headers: $($(1).staging.headers)

# make the rules that publish the master headers
${foreach header, $($(1).headers.master), \
    ${eval ${call library.workflows.header.master,$(1),$(header)}}
}

# make the rules that publish the exported headers
${foreach header, $($(1).headers), \
    ${eval ${call library.workflows.header,$(1),$(header)}}
}

# if the library has sources, make archive targets
${if $($(1).sources), \
    ${call library.workflows.archive,$(1)}, \
    ${call library.workflows.archive.empty,$(1)}, \
}

# if the library has sources and the user asked for a shared object, make the rules that build it
${if ${and $($(1).sources), $($(1).dll)},${call library.workflows.dll,$(1)},}

# make the rules that compile the archive sources
${foreach source,$($(1).sources),
    ${eval ${call library.workflows.object,$(1),$(source)}}
}

# include the dependency files
-include $($(1).staging.objects:$(builder.ext.obj)=$(builder.ext.dep))

# all done
endef


# helpers
# library master headers
#  usage: library.workflows.header.master {library} {header}
define library.workflows.header.master =
# publish public headers
${call library.staging.header.master,$(1),$(2)}: $(2) ${call library.staging.incdir,$(1),$(2)}
	$(cp) $$< $$@
	@${call log.action,"cp",${subst $($(1).home),,$(2)}}
# all done
endef


# library headers
#  usage: library.workflows.header {library} {header}
define library.workflows.header =
# publish public headers
${call library.staging.header,$(1),$(2)}: $(2) ${call library.staging.incdir,$(1),$(2)}
	$(cp) $$< $$@
	@${call log.action,"cp",${subst $($(1).home),,$(2)}}
# all done
endef


# archive assets
#   usage library.workflows.assets.archives {library}
define library.workflows.assets.archives =
${strip
    ${if $($(1).sources), $(1).archive,}
    ${if ${and $($(1).sources), $($(1).dll), ${findstring shared,$(target.variants)}}, $(1).dll,}
}
endef

# archives
#   usage: library.workflows.archive {library}
define library.workflows.archive =
$(1).archive: $($(1).staging.archive)

$($(1).staging.archive): $($(1).staging.objects)
	$(ar.create) $$@ $($(1).staging.objects)
	@${call log.action,"ar",$($(1).archive)}

# all done
endef


# archives: empty archive targets
#   usage: library.workflows.archive {library}
define library.workflows.archive.empty =
$(1).archive:

$($(1).staging.archive):

# all done
endef


# shared objects
#   usage: library.workflows.dll {library}
define library.workflows.dll =
#if we are here, the user has asked for a shared object
$(1).dll: $($(1).staging.dll)

$($(1).staging.dll): $($(1).staging.archive)
	@${call log.action,"dll",$($(1).dll)}
	${call languages.dll,c++,$($(1).staging.objects),$($(1).staging.dll),\
            $(1).c++ $($(1).extern)}

# all done
endef


# library objects
#  usage: library.workflows.object {library} {source}
define library.workflows.object =

    # compute the absolute path of the source
    ${eval source.path := $(2)}
    # compute the path of the source relative to the project home
    ${eval source.relpath := ${subst $($(1).home),,$(source)}}
    # the path to the object module
    ${eval source.object := ${call library.staging.object,$(1),$(2)}}
    # and the path to the generated dependency fil
    ${eval source.dep := $(source.object:$(builder.ext.obj)=$(builder.ext.dep))}
    # figure out the source language
    ${eval source.language := $(ext${suffix $(2)})}
    # and if its cuda, we have some extra work to do
    ${eval source.device := ${strip \
        ${if ${findstring cuda,$(source.language)}, \
            ${call library.staging.object.dlink,$(1),$(source.path)}, \
        } \
    }}

# compile source files
$(source.object): $(source.path) \
    | ${foreach pre,$($(1).prerequisites),$(pre).headers $(pre).archive} $($(1).tmpdir)
	@${call log.action,"$(source.language)",$(source.relpath)}
	${call \
            languages.compile,$(source.language),$(source.path),$(source.object),\
                 $(1).$(source.language) $($(1).extern) \
        }
	${call \
            languages.makedep,$(source.language),$(source.path),$(source.dep),\
                 $(1).$(source.language) $($(1).extern) \
        }

${if $(source.device), \
    $(source.device) : $(source.object) ; \
	@${call log.action,"dlink",$(source.relpath)} ; \
	${call \
            languages.dlink,cuda,$(source.object),$(source.device),\
                 $(1).cuda $($(1).extern) \
        }
}

# all done
endef


# make a recipe to log the metadata of a specific library
# usage: library.workflows.info {library}
define library.workflows.info =
# make the recipe
$(1).info:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@$(log)
	@${call log.var,source root,$($(1).prefix)}
	@${call log.var,headers,$($(1).incdir)}
	@${call log.var,archive,$($(1).staging.archive)}
	@${call log.var,source languages,$($(1).languages)}
	@${call log.var,requested packages,$($(1).extern.requested)}
	@${call log.var,supported packages,$($(1).extern.supported)}
	@${call log.var,available packages,$($(1).extern.available)}
	@$(log)
	@$(log) "for an explanation of their purpose, try"
	@$(log)
	@$(log) "    mm $(1).help"
	@$(log)
	@$(log) "related targets:"
	@$(log)
	@${call log.help,$(1).info.directories,"the layout of the source directories"}
	@${call log.help,$(1).info.sources,"the source files"}
	@${call log.help,$(1).info.headers,"the header files"}
	@${call log.help,$(1).info.incdirs,"the include directories in the staging area"}
	@${call log.help,$(1).info.api,"the exported public headers"}
	@${call log.help,$(1).info.objects,"the object files in the staging area"}


# make a recipe that prints the directory layout of the sources of a library
$(1).info.directories:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.sec,"  source directories",}
	@${foreach directory,$($(1).directories),$(log) $(log.indent)$(directory);}


# make a recipe that prints the set of sources that comprise a library
$(1).info.sources:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.sec,"  sources",}
	@${foreach source,$($(1).sources),$(log) $(log.indent)$(source);}


# make a recipe that prints the set of public headers of a library
$(1).info.headers:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.sec,"  headers",}
	@${foreach header,$($(1).headers),$(log) $(log.indent)$(header);}
# all done

# make a recipe that prints the set of objects of a library
$(1).info.objects:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.var,"tmpdir",$($(1).tmpdir)}
	@${call log.sec,"  objects",}
	@${foreach object,$($(1).staging.objects),$(log) $(log.indent)$(object);}


# make a recipe that prints the set of includes of a library
$(1).info.incdirs:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.var,"incdir",$($(1).incdir)}
	@${call log.sec,"  include directory structure",}
	@${foreach directory,$($(1).staging.incdirs),$(log) $(log.indent)$(directory);}

# make a recipe that prints the set of exported public headers
$(1).info.api:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.var,"incdir",$($(1).incdir)}
	@${call log.sec,"  exported public headers",}
	@${foreach header,$($(1).staging.headers),$(log) $(log.indent)$(header);}

# make a recipe that prints the set of source languages
$(1).info.languages:
	@${call log.sec,$(1),"a library in project '$($(1).project)'"}
	@${call log.var,"languages",$($(1).languages)}
	@${foreach language,$($(1).languages),\
            ${call log.sec,"  $(language)","flags and options"}; \
            ${foreach category,$(languages.$(language).categories), \
                ${call log.var,$(category),$($(1).$(language).$(category))}; \
            } \
        }

# all done
endef


# make a recipe to show the metadata documentation of a specific library
# usage: library.workflows.help {library}
define library.workflows.help =
# make the recipe
$(1).help:
	@$(log)
	@${call log.sec,$(1),library attributes}
	@$(log)
	@${foreach category,$($(1).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.help,$(1).$(var),$($(1).metadoc.$(var))}; \
             } \
        }
	@$(log)
	@$(log) "for a listing of their values, try"
	@$(log)
	@$(log) "    mm $(1).info"
	@$(log)
# all done
endef


# show me
# ${info -- done with libraries.info}

# end of file
