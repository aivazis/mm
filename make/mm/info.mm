# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- mm.info}

# administrivia
mm.banner:
	$(log)
	$(log) $(palette.light-blue)"    mm $(mm.version)"$(palette.normal)
	$(log) "    Michael Aïvázis <michael.aivazis@para-sim.com>"
	$(log) "    copyright 1998-2018 all rights reserved"
	$(log)

help mm.usage: | mm.banner
	$(log) "usage:"
	$(log)
	$(log) "    mm <options...> [targets...]"
	$(log)
	$(log) "for help with command line options:"
	$(log)
	$(log) "    mm --help"
	$(log)
	$(log) "for details about the build, try one of the following targets:"
	$(log)
	${call log.help,"   projects.info","information about the known projects"}
	${call log.help,"  platform.info","platform specific options"}
	${call log.help," compilers.info","the list of active compilers"}
	${call log.help,"  suffixes.info","a map from file suffixes to compilers"}
	${call log.help,"      user.info","user information"}
	${call log.help,"      host.info","host information"}

mm.config:
	${call log.sec,"config", "the makefile search path"}
	${call log.var,user,$(user.config)}
	${call log.var,project,$(project.config)}
	${call log.var,mm,$(mm.config)}

# mm
mm.info:
	${call log.sec,"mm", "important mm variables"}
	${call log.var,exec,$(mm)}
	${call log.var,home,$(mm.home)}
	${call log.var,master,$(mm.master)}
	${call log.var,origin,$(project.origin)}
	${call log.var,anchor,$(project.anchor)}
	${call log.var,local,$(project.makefile)}

# make
make.info:
	${call log.sec,"make","important make variables"}
	${call log.var,make,$(MAKE)}
	${call log.var,level,$(MAKELEVEL)}
	${call log.var,default goal,$(.DEFAULT_GOAL)}
	${call log.var,include path,$(.INCLUDE_DIRS)}
	${call log.var,makefiles,$(MAKEFILE_LIST)}
	${call log.var,flags,$(MAKEFLAGS)}

# show me
# ${info -- done with mm.info}

# end of file