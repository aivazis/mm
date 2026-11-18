# -*- makefile -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# a command line tool written in swift, for macOS. mm does not build swift by itself yet, so this
# fragment carries the rules, and reaches the compiler through the {xcode} toolchain

# the sources
greeter.swift.root := swift/greeter/
greeter.swift.sources = ${wildcard $(project.home)/$(greeter.swift.root)*.swift}
# the platform whose sdk the compiler uses, and the machine and oldest release it builds for
greeter.swift.sdk := macosx
greeter.swift.target := arm64-apple-macos26.0
# optimize unless this is a debug build, which gets symbols instead
greeter.swift.flags := ${if ${filter debug,$(target.variants)},-Onone -g,-O}

# the executable, made in the project's staging area and installed with the other tools of the
# prefix. mm sets {greeter.tmpdir} only after it reads this file, while the rules below need the
# location as they are read, so it is spelled out here the same way
greeter.staging := $(builder.staging)greeter/
greeter.executable := $(greeter.staging)greeter
greeter.installed := $(builder.dest.bin)greeter


# building the project installs the tool
greeter: $(greeter.installed)

# install the tool
$(greeter.installed): $(greeter.executable)
	$(mkdirp) $(@D)
	$(cp.f) $< $@
	@${call log.action,"install",$@}

# compile all the sources into one module and link them, once the toolchain is known to be present
$(greeter.executable): $(greeter.swift.sources) | xcode.verify $(greeter.staging)
	@${call log.action,"swiftc",$(greeter.swift.root)}
	$(toolchain.xcode.env) $(toolchain.xcode.cli) --sdk $(greeter.swift.sdk) swiftc \
	    -target $(greeter.swift.target) $(greeter.swift.flags) \
	    -module-name greeter -o $@ $(greeter.swift.sources)


# end of file
