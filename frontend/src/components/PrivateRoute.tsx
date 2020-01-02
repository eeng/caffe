import React from "react";
import { Route, Redirect } from "react-router-dom";
import { useAuth, AuthStatus } from "./AuthProvider";

// A wrapper for <Route> that redirects to the login
// screen if you're not yet authenticated.
function PrivateRoute({ children, ...rest }: any) {
  const { status } = useAuth();
  return (
    <Route
      {...rest}
      render={({ location }) =>
        status == AuthStatus.LoggedIn ? (
          children
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
