import React, { Fragment } from "react";
import CssBaseline from "@material-ui/core/CssBaseline";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "@apollo/react-hooks";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import AuthProvider from "./AuthProvider";
import SnackbarProvider from "./SnackbarProvider";
import LoginPage from "./LoginPage";
import HomePage from "./HomePage";
import UsersPage from "./UsersPage";
import PrivateRoute from "./PrivateRoute";
import NotFoundPage from "./NotFoundPage";

const client = new ApolloClient({
  uri: "/api",
  request: operation => {
    const token = localStorage.getItem("token");
    operation.setContext({
      headers: {
        authorization: token ? `Bearer ${token}` : ""
      }
    });
  }
});

function App() {
  return (
    <Fragment>
      <CssBaseline />
      <ApolloProvider client={client}>
        <AuthProvider>
          <SnackbarProvider>
            <Router>
              <Switch>
                <PrivateRoute exact path="/">
                  <HomePage />
                </PrivateRoute>
                <PrivateRoute path="/users">
                  <UsersPage />
                </PrivateRoute>
                <Route path="/login">
                  <LoginPage />
                </Route>
                <Route path="*">
                  <NotFoundPage />
                </Route>
              </Switch>
            </Router>
          </SnackbarProvider>
        </AuthProvider>
      </ApolloProvider>
    </Fragment>
  );
}

export default App;
