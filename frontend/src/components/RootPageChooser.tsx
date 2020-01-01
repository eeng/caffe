import React from "react";
import Login from "./Login";
import Home from "./Home";
import { useAuth, AuthStatus } from "./AuthProvider";

function RootPageChooser() {
  const { status } = useAuth();
  return status == AuthStatus.LoggedIn ? <Home /> : <Login />;
}

export default RootPageChooser;
