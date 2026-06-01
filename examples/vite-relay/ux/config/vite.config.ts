// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import relay from "vite-plugin-relay";

// the relay plugin rewrites the {graphql``} tags to import the generated artifacts; it must come
// before the react plugin so the transform runs first
export default defineConfig({
  plugins: [relay, react()],
});

// end of file
