# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- compilers.info}

# compiler info
compilers.info:
	@${call log.sec,"compilers", "map of languages to compilers"}
	@${foreach language,$(languages),\
            ${call log.var,$(language),${call compiler.available,$(language)}} ;\
        }


# show me
# ${info -- done with compilers.info}

# end of file
