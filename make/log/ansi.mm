# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# control sequences
csi8 = "[$(1)m"
csi256 = "[$(1);5;$(2)m"
csi24bit = "[$(1);2;$(2);$(3);$(4)m"

# colors
palette.normal := ${call csi8,0}
palette.black := ${call csi8,0;30}
palette.red := ${call csi8,0;31}
palette.green := ${call csi8,0;32}
palette.brown := ${call csi8,0;33}
palette.blue := ${call csi8,0;34}
palette.purple := ${call csi8,0;35}
palette.cyan := ${call csi8,0;36}
palette.light-gray := ${call csi8,0;37}

# bright-colors
palette.dark-gray := ${call csi8,1;30}
palette.light-red := ${call csi8,1;31}
palette.light-green := ${call csi8,1;32}
palette.yellow := ${call csi8,1;33}
palette.light-blue := ${call csi8,1;34}
palette.light-purple := ${call csi8,1;35}
palette.light-cyan := ${call csi8,1;36}
palette.white := ${call csi8,1;37}

# pretty
palette.amber := ${call csi24bit,38,255,191,0}
palette.lavender := ${call csi24bit,38,192,176,224}
palette.sage := ${call csi24bit,38,176,208,176}

# purpose
palette.info := ${call csi256,38,28}
palette.warning := ${call csi256,38,214}
palette.error := ${call csi256,38,196}
palette.debug := ${call csi256,38,75}
palette.firewall := $(palette.light-red)

# end of file
