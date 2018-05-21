# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- languages.info}

# make a recipe that logs information about a language
#  usage: language.recipes.info {language}
define language.recipes.info =
# make the recipe
$(language).info:
	${call log.sec,$(language),}
	${call log.var,extensions,$(languages.$(language).extensions)}
	${call log.var,compiled,$(languages.$(language).compiled)}
	${call log.var,interpreted,$(languages.$(language).interpreted)}
# all done
endef

# make a recipe that logs the map from extensions to languages
#  usage: language.recipes.info.suffix {language}
define language.recipes.info.suffix =
# make the recipe
suffixes.info:
	${call log.sec,"suffixes","a map of recognized file extensions for each language"}
	${foreach \
            language, \
            $(languages), \
	    ${call log.var,$(language),$(languages.$(language).extensions)}; \
        }
# all done
endef

# show me
# ${info -- done with languages.info}

# end of file
