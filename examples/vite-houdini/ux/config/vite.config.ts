// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import houdini from "houdini/vite";
import adapter from "houdini-adapter-auto";

// the houdini plugin owns the router and folds graphql codegen into the build; it must precede
// the react plugin. houdini drives its own refresh, so react's fast refresh is turned off
export default defineConfig({
  plugins: [houdini({ adapter }), react({ fastRefresh: false })],
});

/* end of file */
