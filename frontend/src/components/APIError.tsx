import React from "react";
import { ApolloError } from "apollo-boost";
import { Message } from "semantic-ui-react";

function APIError({ error }: { error: ApolloError }) {
  return (
    <Message
      header="Error"
      content={<pre>{JSON.stringify(error, null, 2)}</pre>}
      error
    />
  );
}

export default APIError;
