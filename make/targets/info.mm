# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- object.info}

# target info
target.info:
	${call log.sec,"target", "target info"}
	${call log.var,variants,$(target.variants)}

# make a rule to show taret specific info
#  usage: target.info.flags
define target.info.flags
#
targets.$(1).info:
	${call log.sec,$(1),$(targets.$(1).description)}
	${foreach language,$(languages),\
            ${call log.sec,"  $(language)",$(compiler.$(language))}; \
            ${foreach \
                category,  \
                $(languages.$(language).categories), \
                ${call log.var,$(category),$(targets.$(1).$(language).$(category))}; \
            } \
        }
#
endef

# show me
# ${info -- done with object.info}

# end of file
