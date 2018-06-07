# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- tests.info}

# testsuite help
tests.info: mm.banner
	$(log) "known testsuites: "$(palette.purple)$(testsuites)$(palette.normal)
	$(log)
	$(log) "to build one of them, use its name as a target"
	$(log) "    mm ${firstword $(testsuites)}"
	$(log)
	$(log) "to get more information about a specific library, use"
	$(log) "    mm ${firstword $(testsuites)}.info"
	$(log)


# bootstrap
# make the testsuite specific targets
#  usage: test.workflows {library}
define tests.workflows =
    # build recipes
    ${call test.workflows.build,$(1)}
    # info recipes: show values
    ${call test.workflows.info,$(1)}
    # help recipes: show documentation
    ${call test.workflows.help,$(1)}
# all done
endef


# build targets
# target factory for building a testsuite
define test.workflows.build =

# the main recipe
$(1): $($(1).prerequisites) $(1).drivers
	${call log.asset,"tst",$(1)}

$(1).drivers:

# all done
endef


# build targets
# target factory to log the metadata of a specific testsuite
define test.workflows.info =

# the main recipe
$(1).info:
	${call log.sec,$(1),"a testsuite in project '$($(1).project)'"}
	$(log)
	${foreach category,$($(1).meta.categories),\
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

# all done
endef


# make targets that display meta-data documentation for a specifc testsuite
#   usage: test.workflows.build {testsuite}
# target factory for building a testsuite
define test.workflows.help =

# the main recipe
$(1).help:
	$(log)
	${call log.sec,$(1),library attributes}
	$(log)
	${foreach category,$($(1).meta.categories),\
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
# ${info -- done with tests.info}

# end of file
