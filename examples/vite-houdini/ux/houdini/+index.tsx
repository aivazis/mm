// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import type { ReactNode } from "react";

// the html document houdini renders around every route; the router injects the active page
// as {children}
export default function App({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>houdini + vite demo</title>
      </head>
      <body>{children}</body>
    </html>
  );
}

/* end of file */
