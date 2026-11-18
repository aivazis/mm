# -*- makefile -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# an iPad app written in swift with SwiftUI, built for the simulator. mm does not build apps by
# itself yet, so this fragment carries the rules: compile the sources, lay out the bundle, describe
# it to iOS, and sign it. every apple tool is reached through the {xcode} toolchain

# the sources
tiles.swift.root := swift/tiles/
tiles.swift.sources = ${wildcard $(project.home)/$(tiles.swift.root)*.swift}
# the platform whose sdk the compiler uses, the oldest release the app runs on, and the target
# built for; the simulator is a platform of its own, with its own sdk and target
tiles.swift.sdk := iphonesimulator
tiles.swift.minos := 26.0
tiles.swift.target := arm64-apple-ios$(tiles.swift.minos)-simulator
# the swift 6 language, with an entry point marked by {@main} instead of a {main.swift}; optimize
# unless this is a debug build, which gets symbols instead
tiles.swift.flags := \
    -swift-version 6 -parse-as-library \
    ${if ${filter debug,$(target.variants)},-Onone -g,-O}

# the app: its name, its identity, its version, and the platform recorded in its description
tiles.app.name := Tiles
tiles.app.identifier := com.para-sim.mm.examples.tiles
tiles.app.version := 1.0
tiles.app.platform := iPhoneSimulator
# the template of its description
tiles.app.plist := $(project.home)/$(tiles.swift.root)Info.plist.in
# the simulator accepts the ad hoc signature, which needs no identity
tiles.app.identity := -

# the bundle is made in the project's staging area. mm sets {tiles.tmpdir} only after it reads
# this file, while the rules below need the location as they are read, so it is spelled out here
# the same way
tiles.staging := $(builder.staging)tiles/
tiles.bundle := $(tiles.staging)$(tiles.app.name).app/
# its parts: the executable and the description
tiles.executable := $(tiles.bundle)$(tiles.app.name)
tiles.info := $(tiles.bundle)Info.plist
# signing rewrites the executable, so the time of the signature is kept by a stamp outside the
# bundle instead
tiles.signed := $(tiles.staging)$(tiles.app.name).signed


# building the project makes the signed bundle
tiles: $(tiles.signed)

# sign the bundle once its parts are in place; the signature covers all of them, so it is redone
# whenever any of them changes
$(tiles.signed): $(tiles.executable) $(tiles.info)
	@${call log.action,"codesign",$(tiles.bundle)}
	$(toolchain.xcode.env) $(toolchain.xcode.cli) codesign \
	    --force --sign $(tiles.app.identity) --timestamp=none $(tiles.bundle)
	touch $@

# compile all the sources into one module and link them into the bundle, once the toolchain is
# known to be present
$(tiles.executable): $(tiles.swift.sources) | xcode.verify
	@${call log.action,"swiftc",$(tiles.swift.root)}
	$(mkdirp) $(@D)
	$(toolchain.xcode.env) $(toolchain.xcode.cli) --sdk $(tiles.swift.sdk) swiftc \
	    -target $(tiles.swift.target) $(tiles.swift.flags) \
	    -module-name $(tiles.app.name) -o $@ $(tiles.swift.sources)

# describe the app by filling in its template, and make sure the result is a valid property list
$(tiles.info): $(tiles.app.plist) $(project.home)/.mm/tiles.mm
	@${call log.action,"plist",$@}
	$(mkdirp) $(@D)
	sed \
	    -e 's|@IDENTIFIER@|$(tiles.app.identifier)|g' \
	    -e 's|@NAME@|$(tiles.app.name)|g' \
	    -e 's|@VERSION@|$(tiles.app.version)|g' \
	    -e 's|@EXECUTABLE@|$(tiles.app.name)|g' \
	    -e 's|@MINOS@|$(tiles.swift.minos)|g' \
	    -e 's|@PLATFORM@|$(tiles.app.platform)|g' \
	    $< > $@
	plutil -lint -s $@


# end of file
