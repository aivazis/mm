# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- verbatim.info}


# bootstrap
define verbatim.workflows =
    # build recipes
    ${call verbatim.workflows.build,$(1)}
    # info recipes: show values
    ${call verbatim.workflows.info,$(1)}
    # help recipes: show documentation
    ${call verbatim.workflows.help,$(1)}
# all done
endef


# copy file verbatim
define verbatim.workflows.build =

# the top level target
$(1):
	@${call log.asset,"vrb",$(1)}

# all done
endef


#
define verbatim.workflows.info =
# make the recipe
$(1).info:
	@${call log.sec,$(1),"verbatim content in project '$($(1).project)'"}
	@$(log)
# all done
endef


#
define verbatim.workflows.help =
# make the recipe
$(1).help:
	@$(log)
	@${call log.sec,$(1),verbatim}
	@$(log)

# all done
endef


# show me
# ${info -- done with verbatim.info}

# end of file
