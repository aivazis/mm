# -*- makefile -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# an iPad app written in swift with SwiftUI, built for the simulator, whose colors and icon come
# from an asset catalog. mm does not build apps by itself yet, so this fragment carries the rules:
# compile the sources and the assets, lay out the bundle, describe it to iOS, and sign it. every
# apple tool is reached through the {xcode} toolchain

# the sources
swatches.swift.root := swift/swatches/
swatches.swift.sources = ${wildcard $(project.home)/$(swatches.swift.root)*.swift}
# the platform whose sdk the compiler uses, the oldest release the app runs on, and the target
# built for; the simulator is a platform of its own, with its own sdk and target
swatches.swift.sdk := iphonesimulator
swatches.swift.minos := 26.0
swatches.swift.target := arm64-apple-ios$(swatches.swift.minos)-simulator
# the swift 6 language, with an entry point marked by {@main} instead of a {main.swift}; optimize
# unless this is a debug build, which gets symbols instead
swatches.swift.flags := \
    -swift-version 6 -parse-as-library \
    ${if ${filter debug,$(target.variants)},-Onone -g,-O}

# the assets: a catalog of named colors, and the icon, each a directory of files
swatches.assets.catalog := $(project.home)/$(swatches.swift.root)Assets.xcassets
swatches.assets.icon := $(project.home)/$(swatches.swift.root)AppIcon.icon
swatches.assets.sources = ${shell find $(swatches.assets.catalog) $(swatches.assets.icon) -type f}
# the names under which the app finds its icon and the color that tints its controls
swatches.assets.icon.name := AppIcon
swatches.assets.accent := AccentColor
# the devices the assets are compiled for
swatches.assets.devices := ipad

# the app: its name, its identity, its version, and the platform recorded in its description
swatches.app.name := Swatches
swatches.app.identifier := com.para-sim.mm.examples.swatches
swatches.app.version := 1.0
swatches.app.platform := iPhoneSimulator
# the template of its description
swatches.app.plist := $(project.home)/$(swatches.swift.root)Info.plist.in
# the simulator accepts the ad hoc signature, which needs no identity
swatches.app.identity := -

# the bundle is made in the project's staging area. mm sets {swatches.tmpdir} only after it reads
# this file, while the rules below need the location as they are read, so it is spelled out here
# the same way
swatches.staging := $(builder.staging)swatches/
swatches.bundle := $(swatches.staging)$(swatches.app.name).app/
# its parts: the executable, the compiled assets and the description
swatches.executable := $(swatches.bundle)$(swatches.app.name)
swatches.car := $(swatches.bundle)Assets.car
swatches.info := $(swatches.bundle)Info.plist
# compiling the assets also yields the entries they add to the description, kept outside the
# bundle until they are merged into it
swatches.partial := $(swatches.staging)assets.plist
# signing rewrites the executable, so the time of the signature is kept by a stamp outside the
# bundle instead
swatches.signed := $(swatches.staging)$(swatches.app.name).signed

# the simulated device the app runs on, picked by its name among the devices of a runtime, since
# every runtime has its own devices and they share their names
swatches.simulator.runtime := iOS 27.2
swatches.simulator.device := iPad Pro 13-inch (M5)


# building the project makes the signed bundle
swatches: $(swatches.signed)

# run the app in the simulator: find the device, boot it unless it is running, install the app,
# launch it, and bring up the window that shows it. this changes the state of the simulator, so it
# is never part of a build, and only runs when asked for
swatches.simulator: $(swatches.signed) | xcode.verify
	@${call log.action,"simulator","$(swatches.simulator.device) on $(swatches.simulator.runtime)"}
	@udid=$$($(toolchain.xcode.env) $(toolchain.xcode.cli) simctl list devices available | \
	    awk -v runtime="$(swatches.simulator.runtime)" -v name="$(swatches.simulator.device)" ' \
	        /^-- / { current = $$0; next } \
	        current == "-- " runtime " --" { \
	            line = $$0; sub(/^ +/, "", line); \
	            if (index(line, name " (") == 1) { print substr(line, length(name) + 3, 36); exit } \
	        }') ; \
	test -n "$$udid" || { \
	    ${call log.error,"there is no '$(swatches.simulator.device)' on '$(swatches.simulator.runtime)'"} ; \
	    exit 1 ; \
	} ; \
	$(toolchain.xcode.env) $(toolchain.xcode.cli) simctl bootstatus $$udid -b > /dev/null && \
	$(toolchain.xcode.env) $(toolchain.xcode.cli) simctl install $$udid $(swatches.bundle) && \
	$(toolchain.xcode.env) $(toolchain.xcode.cli) simctl launch $$udid $(swatches.app.identifier) && \
	open "$(toolchain.xcode.devicehub)"

# sign the bundle once its parts are in place; the signature covers all of them, so it is redone
# whenever any of them changes
$(swatches.signed): $(swatches.executable) $(swatches.car) $(swatches.info)
	@${call log.action,"codesign",$(swatches.bundle)}
	$(toolchain.xcode.env) $(toolchain.xcode.cli) codesign \
	    --force --sign $(swatches.app.identity) --timestamp=none $(swatches.bundle)
	touch $@

# compile all the sources into one module and link them into the bundle, once the toolchain is
# known to be present
$(swatches.executable): $(swatches.swift.sources) | xcode.verify
	@${call log.action,"swiftc",$(swatches.swift.root)}
	$(mkdirp) $(@D)
	$(toolchain.xcode.env) $(toolchain.xcode.cli) --sdk $(swatches.swift.sdk) swiftc \
	    -target $(swatches.swift.target) $(swatches.swift.flags) \
	    -module-name $(swatches.app.name) -o $@ $(swatches.swift.sources)

# compile the catalog and the icon into the bundle, for the same platform and release as the
# code; this places the compiled assets and the loose icons the system shows before it reads them,
# and records the entries the description needs to find the icon and the accent color
$(swatches.car) $(swatches.partial) &: $(swatches.assets.sources) | xcode.verify
	@${call log.action,"actool",$(swatches.swift.root)}
	$(mkdirp) $(swatches.bundle)
	$(toolchain.xcode.env) $(toolchain.xcode.cli) actool \
	    --compile $(swatches.bundle) \
	    --platform $(swatches.swift.sdk) \
	    --minimum-deployment-target $(swatches.swift.minos) \
	    ${foreach device,$(swatches.assets.devices),--target-device $(device)} \
	    --app-icon $(swatches.assets.icon.name) \
	    --accent-color $(swatches.assets.accent) \
	    --output-partial-info-plist $(swatches.partial) \
	    --output-format human-readable-text --errors --warnings \
	    $(swatches.assets.catalog) $(swatches.assets.icon)

# describe the app by filling in its template, fold in the entries that came with the assets, and
# make sure the result is a valid property list
$(swatches.info): $(swatches.app.plist) $(swatches.partial) $(project.home)/.mm/swatches.mm
	@${call log.action,"plist",$@}
	$(mkdirp) $(@D)
	sed \
	    -e 's|@IDENTIFIER@|$(swatches.app.identifier)|g' \
	    -e 's|@NAME@|$(swatches.app.name)|g' \
	    -e 's|@VERSION@|$(swatches.app.version)|g' \
	    -e 's|@EXECUTABLE@|$(swatches.app.name)|g' \
	    -e 's|@MINOS@|$(swatches.swift.minos)|g' \
	    -e 's|@PLATFORM@|$(swatches.app.platform)|g' \
	    $(swatches.app.plist) > $@
	/usr/libexec/PlistBuddy -c "Merge $(swatches.partial)" $@ > /dev/null
	plutil -lint -s $@


# end of file
