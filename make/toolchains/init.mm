# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# the location of the built-in toolchain definitions
toolchains.mm ?= $(mm.home)/make/toolchains

# the root under which toolchains get installed; the mm driver resolves this from the
# {toolchains} trait, keyed by the active environment so the installation is shared across
# every build context while still tracking where node and python come from; the fallback
# mirrors the driver's formula from the same driver-supplied variables, covering a direct
# {make} invocation that bypasses the driver
toolchains.home ?= $(user.home)/tools/mm/$(user.environment)/toolchains


# the toolchain constructor; fills in whatever a tool definition left unset and resolves the
# installation directory under the shared root
#   usage: toolchain.init {tool}
define toolchain.init =
    # the human readable description
    ${eval toolchain.$(1).doc ?=}
    # the ecosystem the tool belongs to; drives how the pin is stored and installed
    ${eval toolchain.$(1).kind ?= node}
    # the exact version to pin
    ${eval toolchain.$(1).version ?=}
    # the directory that holds both the installation and mm's configuration for the tool
    ${eval toolchain.$(1).home := $(toolchains.home)/$(1)}
    # the artifact whose presence proves the tool is installed and intact
    ${eval toolchain.$(1).sentinel ?= $(toolchain.$(1).home)/node_modules/.bin/$(1)}
# all done
endef


# end of file
