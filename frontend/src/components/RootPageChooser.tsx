import React from "react";
import LoginPage from "./LoginPage";
import Home from "./Home";
import { useAuth, AuthStatus } from "./AuthProvider";

function RootPageChooser() {
  const { status } = useAuth();
  return status == AuthStatus.LoggedIn ? <Home /> : <LoginPage />;
}

export default RootPageChooser;
