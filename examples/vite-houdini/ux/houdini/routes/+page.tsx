// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import { useState } from "react";
import type { PageProps } from "./$types";

// the root page: houdini resolves the {AppGreeting} query and hands it in as a prop (the
// destructured name must match the query); the counter is purely client-side, for parity with
// the relay example
export default function ({ AppGreeting }: PageProps) {
  const [count, setCount] = useState(0);
  return (
    <main>
      <h1>houdini + vite</h1>
      <p>the server says: {AppGreeting.greeting}</p>
      <button onClick={() => setCount((c) => c + 1)}>clicked {count} times</button>
    </main>
  );
}

/* end of file */
