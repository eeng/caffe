import { QueryResult } from "@apollo/client";
import React from "react";
import APIErrorMessage from "./APIErrorMessage";
import SectionLoader from "./SectionLoader";

type Props<TData> = {
  result: QueryResult<TData>;
  render: (data: TData) => React.ReactNode;
};

// Simplifies the handling of the loading and error states of GraphQL queries
function QueryResultWrapper<TData>({ result, render }: Props<TData>) {
  const { loading, error, data } = result;

  return (
    <>
      {loading && !data && <SectionLoader />}
      {error && <APIErrorMessage error={error} />}
      {data && render(data)}
    </>
  );
}

export default QueryResultWrapper;
