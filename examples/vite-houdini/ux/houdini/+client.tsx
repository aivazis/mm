// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import { HoudiniClient } from "$houdini";

// the runtime client; this is where queries are sent, both server-side during SSR and from the
// browser after hydration — the same pyre graphql server the schema was introspected from
export default new HoudiniClient({
  url: "http://localhost:8080/graphql",
});

/* end of file */
