import { ApolloError } from "@apollo/client";

type ServerError =
  | "invalid_credentials"
  | "unauthorized"
  | "item_already_prepared"
  | "item_already_served";

export const isServerError = (
  serverError: ServerError,
  apolloError: ApolloError
) =>
  apolloError.graphQLErrors.length &&
  apolloError.graphQLErrors.some(gqlError => gqlError.message == serverError);

export const isNetworkError = (error: ApolloError) => error.networkError;
