import { ApolloProvider } from "@apollo/react-hooks";
import ApolloClient from "apollo-boost";
import React from "react";
import "react-semantic-toasts/styles/react-semantic-alert.css";
import AuthProvider, { AUTH_TOKEN } from "./AuthProvider";
import Router from "./Router";

const client = new ApolloClient({
  uri: "/api",
  request: operation => {
    const token = localStorage.getItem(AUTH_TOKEN);
    operation.setContext({
      headers: {
        authorization: token ? `Bearer ${token}` : ""
      }
    });
  }
});

function App() {
  return (
    <ApolloProvider client={client}>
      <AuthProvider>
        <Router />
      </AuthProvider>
    </ApolloProvider>
  );
}

export default App;
