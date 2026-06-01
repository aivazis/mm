// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import { Suspense, useState } from "react";
import { graphql, useLazyLoadQuery } from "react-relay";
import type { AppGreetingQuery } from "./__generated__/AppGreetingQuery.graphql";

// the query relay-compiler turns into a generated artifact
const greetingQuery = graphql`
  query AppGreetingQuery {
    greeting
  }
`;

// the data-driven half: fetches the greeting from the server
function Greeting() {
  const data = useLazyLoadQuery<AppGreetingQuery>(greetingQuery, {});
  return <p>the server says: {data.greeting}</p>;
}

// the app: a server-backed greeting plus a purely client-side counter for interactivity
export function App() {
  const [count, setCount] = useState(0);
  return (
    <main>
      <h1>relay + vite</h1>
      <Suspense fallback={<p>loading…</p>}>
        <Greeting />
      </Suspense>
      <button onClick={() => setCount((c) => c + 1)}>clicked {count} times</button>
    </main>
  );
}

/* end of file */
