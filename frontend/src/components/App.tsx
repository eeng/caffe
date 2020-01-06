import React, { Fragment } from "react";
import { SemanticToastContainer } from "react-semantic-toasts";
import "react-semantic-toasts/styles/react-semantic-alert.css";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "@apollo/react-hooks";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import AuthProvider, { AUTH_TOKEN } from "./AuthProvider";
import LoginPage from "./LoginPage";
import HomePage from "./HomePage";
import ConfigPage from "./configuration/ConfigPage";
import PrivateRoute from "./PrivateRoute";
import NotFoundPage from "./NotFoundPage";

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
        <Router>
          <Switch>
            <PrivateRoute exact path="/">
              <HomePage />
            </PrivateRoute>
            <PrivateRoute path="/config" permission="list_users">
              <ConfigPage />
            </PrivateRoute>
            <Route path="/login">
              <LoginPage />
            </Route>
            <Route path="*">
              <NotFoundPage />
            </Route>
          </Switch>
        </Router>
      </AuthProvider>
      <SemanticToastContainer position="bottom-right" />
    </ApolloProvider>
  );
}

export default App;
