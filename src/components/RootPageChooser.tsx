import React from "react";
import Login from "./Login";
import Home from "./Home";
import { useAuth } from "./AuthProvider";

const RootPageChooser: React.FC = () => {
  const { isAuthenticated } = useAuth();
  return isAuthenticated ? <Home /> : <Login />;
};

export default RootPageChooser;
