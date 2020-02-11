import React from "react";
import { ApolloError } from "@apollo/client";
import { Message } from "semantic-ui-react";
import { isServerError } from "/lib/errors";

function APIErrorMessage({ error }: { error: ApolloError | undefined }) {
  if (!error) return null;

  if (isServerError("unauthorized", error))
    return (
      <Message
        header="Access Denied"
        content="You are not authorized to view this page."
        error
        icon="lock"
      />
    );
  else
    return (
      <Message
        header="Error"
        content={<pre>{JSON.stringify(error, null, 2)}</pre>}
        error
      />
    );
}

export default APIErrorMessage;
