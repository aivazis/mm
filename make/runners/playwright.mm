# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# playwright: a node-based end-to-end runner; it needs the client's node_modules, so it runs from
# a staging area; it discovers its own specs and starts servers through playwright.config.ts, so
# serial vs parallel routing and server fixtures are its concern, not ours
runner.playwright.prepare := staged
runner.playwright.launch := npx playwright test
runner.playwright.doc := "node end-to-end runner; owns the browsers and the servers under test"
runner.playwright.suite := "stage.modules: the ux bundle's node_modules"


# end of file
