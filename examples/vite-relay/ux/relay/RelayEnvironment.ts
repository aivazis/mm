// -*- TypeScript -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

import {
  Environment,
  Network,
  RecordSource,
  Store,
  type FetchFunction,
} from "relay-runtime";

// the demo server; the dev/run step wires up a pyre graphql server here
const endpoint = "http://localhost:8080/graphql";

// post a query to the server and return its json response
const fetchFn: FetchFunction = async (params, variables) => {
  const response = await fetch(endpoint, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ query: params.text, variables }),
  });
  return await response.json();
};

// the relay environment shared by the whole app
export const environment = new Environment({
  network: Network.create(fetchFn),
  store: new Store(new RecordSource()),
});

/* end of file */
