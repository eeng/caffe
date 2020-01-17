import React from "react";
import { Route, Redirect, RouteProps } from "react-router-dom";
import { useAuth, AuthStatus } from "../accounts/AuthProvider";

interface Props extends RouteProps {
  permission?: string;
}

// A wrapper for <Route> that redirects to the login screen if you're not yet authenticated,
// or to the home page if you don't have the necessary permission.
function PrivateRoute({ permission, children, ...rest }: Props) {
  const { status, can } = useAuth();

  return (
    <Route
      {...rest}
      render={({ location }) =>
        status == AuthStatus.LoggedIn ? (
          !permission || can(permission) ? (
            children
          ) : (
            <Redirect to="/" />
          )
        ) : (
          <Redirect
            to={{
              pathname: "/login",
              state: { from: location }
            }}
          />
        )
      }
    />
  );
}
export default PrivateRoute;
