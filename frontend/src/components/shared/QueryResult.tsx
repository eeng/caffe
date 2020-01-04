import { QueryResult } from "@apollo/react-common";
import React, { ReactElement } from "react";
import APIError from "./APIError";
import SectionLoader from "./SectionLoader";

type Props = {
  result: QueryResult;
  render: (data: any) => ReactElement;
};

// Simplifies the handling of the loading and error states of GraphQL queries
function QueryResultWrapper({ result, render }: Props) {
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
