import React, { useState, useContext, useEffect } from "react";
import FullScreenSpinner from "./FullScreenSpinner";

type User = {
  id: string;
  email: string;
  name: string;
};

export type Credentials = {
  email: string;
  password: string;
};

type Auth = {
  token?: string;
  user?: User;
  isAuthenticated: boolean;
  login: (credentials: Credentials) => boolean;
  logout: () => void;
};

type State = {
  token?: string;
  user?: User;
  loading: boolean;
};

const AuthContext = React.createContext<Auth>({
  isAuthenticated: false,
  login: _ => false,
  logout: () => {}
});

const AuthProvider: React.FC = ({ children }) => {
  const [state, setState] = useState<State>({ loading: true });

  useEffect(() => {
    try {
      const authState = JSON.parse(localStorage.getItem("authState") || "");
      setState({ ...authState, loading: false });
    } catch (_) {
      setState({ loading: false });
    }
  }, []);

  if (state.loading) return <FullScreenSpinner />;

  const login = (credentials: Credentials) => {
    console.log("login", credentials);

    const response = {
      token: "...",
      user: { id: "..", name: "john", email: "x@a.com" }
    };

    localStorage.setItem("authState", JSON.stringify(response));
    setState({ ...response, loading: false });
    return true;
  };

  const logout = () => {
    console.log("logout");

    localStorage.removeItem("authState");
    setState({ loading: false });
  };

  const auth: Auth = {
    user: state.user,
    token: state.token,
    isAuthenticated: state.user != null,
    login,
    logout
  };

  return <AuthContext.Provider value={auth}>{children}</AuthContext.Provider>;
};

export const useAuth = () => useContext(AuthContext);

export default AuthProvider;
