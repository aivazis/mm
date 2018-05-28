# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- builder.info}

builder.info: mm.banner
	${call log.sec,"builder directory layout",}
	${call log.var,"root",$(builder.root)}
	${call log.var,"bindir",$(builder.bindir)}
	${call log.var,"docdir",$(builder.docdir)}
	${call log.var,"incdir",$(builder.incdir)}
	${call log.var,"libdir",$(builder.libdir)}
	${call log.var,"tmpdir",$(builder.tmpdir)}


define builder.workflows

$(builder.incdir) $(builder.libdir) $(builder.tmpdir):
	$(mkdirp) $$@
	${call log.action,"mkdir",$$@}

endef


# show me
# ${info -- done with builder.info}

# end of file
