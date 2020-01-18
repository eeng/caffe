import { QueryResult } from "@apollo/client";
import React, { ReactElement } from "react";
import APIError from "./APIError";
import SectionLoader from "./SectionLoader";

type Props<TData> = {
  result: QueryResult<TData>;
  render: (data: TData) => ReactElement;
};

// Simplifies the handling of the loading and error states of GraphQL queries
function QueryResultWrapper<TData>({ result, render }: Props<TData>) {
  const { loading, error, data } = result;

  return (
    <>
      {loading && <SectionLoader />}
      {error && <APIError error={error} />}
      {data && render(data)}
    </>
  );
}

export default QueryResultWrapper;
