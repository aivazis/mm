# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


extern.info:
	@${call log.sec,"extern","support for external packages"}
	@${call log.sec,"  locations",}
	@${call log.var,"built in",$(extern.mm)}
	@${call log.var,"user",$(extern.user)}
	@${call log.var,"project",$(extern.project)}
	@${call log.sec,"  packages",}
	@${call log.var,"supported",$(extern.supported)}
	@${call log.var,"available",$(extern.available)}
	@${call log.var,"requested",$(projects.extern.requested)}
	@${call log.var,"provided",$(projects.extern.loaded)}
	@${call log.sec,"  db",}
	@${call log.var,$(mm.pkgdb),$(builder.staging)pkg-$(mm.pkgdb).db}


# package database management
define extern.workflows.pkgdb

	${eval _db := $(builder.staging)pkg-$(mm.pkgdb).db}

# attempt to load the package database
include $(_db)

# for conda, warn if the active environment differs from the one used to build the database;
# guard on {conda.environment} being set: if it's empty the db is being rebuilt and there
# is nothing to compare against yet
${if ${filter conda,$(mm.pkgdb)}, \
    ${if $(conda.environment), \
        ${if ${filter-out $(conda.environment),$(user.environment)}, \
            ${warning conda environment mismatch: database was built for '$(conda.environment)', current is '$(user.environment)'} \
        } \
    } \
}

extern.db.info:
	@${call log.sec,"extern.db","the active package database"}
	@${call log.var,"manager",$(mm.pkgdb)}
	@${call log.var,"location",$(_db)}
	@${if $(conda.prefix),${call log.sec,"  conda",},:}
	@${if $(conda.prefix),${call log.var,"prefix",$(conda.prefix)},:}
	@${if $(conda.environment),${call log.var,"environment",$(conda.environment)},:}

extern.db.clean:
	@${call log.action,"rm",$(_db)}
	$(rm.force) $(_db)

# the rule that regenerates the package database
$(builder.staging)pkg-%.db: | $(builder.staging)
	@${call log.action,"pkgdb",$$@}
	@$(mm) --pkgdb=$$* --setup


endef

# end of file
