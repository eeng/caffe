import React from "react";
import Login from "./Login";
import Home from "./Home";
import { useAuth } from "./AuthProvider";

const RootPageChooser: React.FC = () => {
  const { isLoggedIn } = useAuth();
  return isLoggedIn ? <Home /> : <Login />;
};

export default RootPageChooser;
