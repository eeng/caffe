import React from "react";
import { ApolloError } from "@apollo/client";
import { Message } from "semantic-ui-react";
import { isServerError, isNetworkError } from "/lib/errors";

function APIErrorMessage({ error }: { error: ApolloError | undefined }) {
  if (!error) return null;

  if (isNetworkError(error))
    return (
      <Message
        header="Network Error"
        content="There seems to be a problem with the connection to our servers. Please try again later."
        error
        icon="wifi"
      />
    );
  else if (isServerError("unauthorized", error))
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
