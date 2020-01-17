import React, { useRef, useEffect } from "react";
import { Route, Redirect, RouteProps } from "react-router-dom";
import { useAuth, AuthStatus } from "../accounts/AuthProvider";

interface Props extends RouteProps {
  permission?: string;
}

// A wrapper for <Route> that redirects to the login screen if you're not yet authenticated,
// or to the home page if you don't have the necessary permission.
function PrivateRoute({ permission, children, ...rest }: Props) {
  const { status, can } = useAuth();

  const previousStatus = useRef<AuthStatus>();
  useEffect(() => {
    previousStatus.current = status;
  });

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
              state: redirectState(previousStatus?.current, status, location)
            }}
          />
        )
      }
    />
  );
}

// If a non-logged-in user tries to access a private path, this allows us to "remember" it
// so when the user does sign in, we can redirect them back that path.
// But we should "forget" it when the user logs out.
const redirectState = (
  previousStatus: AuthStatus | undefined,
  currentStatus: AuthStatus,
  location: any
) =>
  previousStatus == AuthStatus.LoggedIn &&
  currentStatus == AuthStatus.NotLoggedIn
    ? null
    : { from: location };

export default PrivateRoute;
