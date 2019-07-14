# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
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
$(1): $($(1).prerequisites) $(1).testcases
	${call log.asset,"tst",$(1)}

# the testcases depend on the indivisual test targets
$(1).testcases: $($(1).staging.targets)

# clean up
$(1).clean: ${addsuffix .clean,$($(1).staging.targets)}

# make recipes for the individual test targets
${foreach target, $($(1).staging.targets), \
    ${eval
        ${if $($(target).compiled),
            ${call test.workflows.target.compiled,$(target)}, \
            ${call test.workflows.target.interpreted,$(target)} \
        }
    }
}

# all done
endef


# build targets
# target factory that builds a target for an interpreted test case
#   usage: test.workflows.target.interpreted {target}
define test.workflows.target.interpreted =

# the aggregator
$(1): $(1).cases $(1).clean

# invoking the driver for each registered test case
$(1).cases: $($($(1).suite).prerequisites)
	$(cd) $${dir $($(1).source)} ; \
        ${if $($(1).cases), \
            ${foreach argv, $($(1).cases), \
                ${call log.action,test,$($(1).source) $($(argv))}; \
                $(compiler.$($(1).language)) $($(1).source) $($(argv)); \
                }, \
	    ${call log.action,test,$($(1).source)}; \
                $(compiler.$($(1).language)) $($(1).source) \
        }

# clean up
$(1).clean: # | $(1).cases
	${call log.action,clean,$(1)}
	$(rm.force-recurse) $($(1).clean)

# just in case...
.PHONY: $(1) $(1).cases $(1).clean

# all done
endef


# target factory that builds a target for a compiled test case
#   usage: test.workflows.target.compiled {target}
define test.workflows.target.compiled =

$(1): $(1).driver $(1).cases $(1).clean

$(1).driver: $($(1).base)

$($(1).base): $($($(1).suite).prerequisites) $($(1).source)
	${call log.action,$($(1).language),$($(1).source)}
	${call \
            languages.$($(1).language).link, \
            $($(1).source), \
            $($(1).base), \
            $($(1).suite).$($(1).language) $($(1).extern) }


$(1).cases: $(1).driver
	$(cd) $${dir $($(1).source)} ; \
	${if $($(1).cases), \
            ${foreach argv, $($(1).cases), \
                ${call log.action,test,$($(1).base) $($(argv))}; \
                $($(1).base) $($(argv)); \
                }, \
	    ${call log.action,test,$($(1).base)}; \
                $($(1).base) \
        }

# clean up
$(1).clean: #| $(1).cases
	${call log.action,clean,$(1)}
	$(rm.force-recurse) $($(1).clean) $($(1).base) ${call platform.clean,$($(1).base)}

# just in case...
.PHONY: $(1) $(1).driver $(1).cases $(1).clean

# all done
endef


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
	${call log.help,$(1).info.directories,"the layout of the testsuite directories"}
	${call log.help,$(1).info.drivers,"the test case drivers"}
	${call log.help,$(1).info.targets,"the test case make targets"}
	${call log.help,$(1).info.staging.targets,"the make targets for individual test cases"}

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

# make a recipe that prints the directory layout of a test suite
$(1).info.directories:
	${call log.sec,$(1),"a testsuite in project '$($(1).project)'"}
	${call log.sec,"  test directories",}
	${foreach directory,$($(1).directories),$(log) $(log.indent)$(directory);}


# make a recipe that prints the set of drivers that comprise a testsuite
$(1).info.drivers:
	${call log.sec,$(1),"a testsuite in project '$($(1).project)'"}
	${call log.sec,"  drivers",}
	${foreach driver,$($(1).drivers),$(log) $(log.indent)$(driver);}


# make a recipe that prints the set of source languages
$(1).info.languages:
	${call log.sec,$(1),"a testsuite in project '$($(1).project)'"}
	${call log.var,"languages",$($(1).languages)}
	${foreach language,$($(1).languages),\
            ${call log.sec,"  $(language)","flags and options"}; \
            ${foreach category,$(languages.$(language).categories), \
                ${call log.var,$(category),$($(1).$(language).$(category))}; \
            } \
        }

# make a recipe that prints the set of make targets for individual test cases
$(1).info.staging.targets:
	${call log.sec,$(1),"a testsuite in project '$($(1).project)'"}
	${call log.sec,"  individual testcase targets",}
	${foreach target,$($(1).staging.targets), \
            ${call log.sec,$(log.indent)$(target),}; \
            ${call log.var,$(log.indent)"source",$($(target).source)}; \
            ${call log.var,$(log.indent)"language",$($(target).language)}; \
            ${call log.var,$(log.indent)"extern",$($(target).extern)}; \
            ${call log.var,$(log.indent)"compiled",$($(target).compiled)}; \
            ${call log.var,$(log.indent)"interpreted",$($(target).interpreted)}; \
            ${call log.var,$(log.indent)"doc",$($(target).doc)}; \
            ${call log.var,$(log.indent)"cases",$($(target).cases)}; \
            ${call log.var,$(log.indent)"clean",$($(target).clean)}; \
        }


# all done
endef


# show me
# ${info -- done with tests.info}

# end of file
