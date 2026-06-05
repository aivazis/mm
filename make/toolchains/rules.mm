# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# the toolchain registry summary
toolchains.info:
	@${call log.sec,"toolchains","environment-level developer tools installed once per environment"}
	@${call log.sec,"  location",}
	@${call log.var,"root",$(toolchains.home)}
	@${call log.sec,"  available tools",}
	@${foreach tool,$(toolchains),${call log.var,$(tool),$(toolchain.$(tool).doc)};}
	@${call log.sec,"  actions",}
	@${call log.help,"<tool>.install","fetch and install it (a deliberate online action)"}
	@${call log.help,"<tool>.verify","check it is present; fails a build if it is missing"}
	@${call log.help,"<tool>.update","reinstall it against the pinned version"}
	@${call log.help,"<tool>.info","show its settings"}
	@${call log.help,"<tool>.clean","remove the installation"}


# make the universal recipes every toolchain provides: info, verify, clean; the install and
# update recipes are ecosystem specific and live in each tool's own definition
#  usage: toolchain.workflows {tool}
define toolchain.workflows =

# report this tool's settings
$(1).info:
	@${call log.sec,$(1),$(toolchain.$(1).doc)}
	@${call log.var,kind,$(toolchain.$(1).kind)}
	@${call log.var,version,$(toolchain.$(1).version)}
	@${call log.var,home,$(toolchain.$(1).home)}
	@${call log.var,sentinel,$(toolchain.$(1).sentinel)}

# confirm the tool is installed; if it isn't, fail with a one-line instruction so a build that
# depends on it stops with an actionable message instead of a cryptic error further downstream
$(1).verify:
	@test -e "$(toolchain.$(1).sentinel)" || ( \
	    ${call log.error,"the '$(1)' toolchain is not installed"} ; \
	    ${call log.info,"expected it under $(toolchain.$(1).home)"} ; \
	    ${call log.info,"install it with: mm $(1).install"} ; \
	    exit 1 \
	)
	@${call log.action,"verify","$(1) $(toolchain.$(1).version) is available"}

# remove the entire installation so the next install starts from a clean slate
$(1).clean:
	@${call log.action,"rm",$(toolchain.$(1).home)}
	$(rm.force-recurse) $(toolchain.$(1).home)

# all done
endef


# end of file
