# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- builder.info}

builder.info: mm.banner
	@${call log.sec,"builder directory layout",}
	@${call log.sec,"  staging layout",}
	@${call log.var,"       tmp",$(builder.dest.staging)}
	@${call log.sec,"  install layout",}
	@${call log.var,"    prefix",$(builder.dest.prefix)}
	@${call log.var,"       bin",$(builder.dest.bin)}
	@${call log.var,"       doc",$(builder.dest.doc)}
	@${call log.var,"       inc",$(builder.dest.inc)}
	@${call log.var,"       lib",$(builder.dest.lib)}
	@${call log.var,"       pyc",$(builder.dest.pyc)}


# create the builder targets
#   usage: builder.workflows
define builder.workflows

# rule to create the builder directories
$(builder.directories):
	$(mkdirp) $$@
	@${call log.action,"mkdir",$$@}

# all done
endef


# show me
# ${info -- done with builder.info}

# end of file
