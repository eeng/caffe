import {
  ApolloClient,
  ApolloLink,
  ApolloProvider,
  HttpLink,
  InMemoryCache
} from "@apollo/client";
import React from "react";
import { hot } from "react-hot-loader";
import { BrowserRouter } from "react-router-dom";
import AuthProvider, { AUTH_TOKEN } from "./accounts/AuthProvider";
import Routes from "./routing/Routes";

const httpLink = new HttpLink({ uri: `${process.env.BACKEND_URL}/api` });

const authLink = new ApolloLink((operation, forward) => {
  const token = localStorage.getItem(AUTH_TOKEN);
  operation.setContext({
    headers: {
      authorization: token ? `Bearer ${token}` : ""
    }
  });
  return forward(operation);
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache(),
  defaultOptions: {
    watchQuery: { fetchPolicy: "cache-and-network" }
  }
});

function App() {
  return (
    <ApolloProvider client={client}>
      <AuthProvider>
        <BrowserRouter>
          <Routes />
        </BrowserRouter>
      </AuthProvider>
    </ApolloProvider>
  );
}

export default hot(module)(App);
