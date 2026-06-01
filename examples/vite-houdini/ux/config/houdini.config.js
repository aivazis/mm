// -*- JavaScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

/// <references types="houdini-react">
/** @type {import('houdini').ConfigFile} */
const config = {
	// pull the schema by introspecting the pyre graphql server; codegen and the dev server
	// regenerate the runtime whenever it changes
	watchSchema: {
		url: "http://localhost:8080/graphql",
	},
	// the react bindings
	plugins: {
		"houdini-react": {},
	},
};

export default config;

/* end of file */
