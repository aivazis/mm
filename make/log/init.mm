# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# rendering functions
log ?= echo
# indentation
log.halfdent = "  "
log.indent = "    "

# sections
log.sec = \
    $(log) \
    $(palette.amber)$(1)$(palette.normal): $(2)

# variables
log.var = \
    $(log) \
    $(palette.sage)$(log.indent)$(1)$(palette.normal) \
    = \
    $(palette.normal)$(2)$(palette.normal)

# commands and targets
log.help = \
    $(log) \
    $(palette.lavender)$(log.indent)$(1)$(palette.normal) \
    : \
    $(palette.normal)$(2)$(palette.normal)

# text
log.info = \
    $(log) \
    $(palette.info)"  [info]"$(palette.normal) \
    $(palette.info)$(1)$(palette.normal) \

log.warning = \
    $(log) \
    $(palette.warning)"  [warning]"$(palette.normal) \
    $(palette.warning)$(1)$(palette.normal) \

log.error = \
    $(log) \
    $(palette.error)"  [error]"$(palette.normal) \
    $(palette.error)$(1)$(palette.normal) \

log.debug = \
    $(log) \
    $(palette.debug)"  [debug]"$(palette.normal) \
    $(palette.debug)$(1)$(palette.normal) \

log.firewall = \
    $(log) \
    $(palette.firewall)"  [firewall]"$(palette.normal) \
    $(palette.firewall)$(1)$(palette.normal) \

# render a build action
log.asset = \
    $(log) \
    $(palette.amber)"  [$(1)]"$(palette.normal) \
    $(2)

log.action = \
    $(log) \
    $(palette.lavender)"  [$(1)]"$(palette.normal) \
    $(2)

log.action.attn = \
    $(log) \
    $(palette.purple)"  [$(1)]"$(palette.normal) \
    $(2)

# terminals that support the ansi color commands
terminals.ansi = ansi vt100 vt102 xterm xterm-color xterm-256color

# colors
ifeq ($(TERM),${findstring $(TERM),$(terminals.ansi)})
include make/log/ansi.mm
else
include make/log/dumb.mm
endif

# end of file
