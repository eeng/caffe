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

enum Status {
  FetchingFromStorage,
  NotLoggedIn,
  LoggingIn,
  LoggedIn
}

type State = {
  token?: string;
  user?: User;
  status: Status;
};

type Auth = {
  token?: string;
  user?: User;
  status: Status;
  isLoggedIn: boolean;
  login: (credentials: Credentials) => void;
  logout: () => void;
};

const AuthContext = React.createContext<Auth>({
  status: Status.NotLoggedIn,
  isLoggedIn: false,
  login: _ => {},
  logout: () => {}
});

const AuthProvider: React.FC = ({ children }) => {
  const [state, setState] = useState<State>({
    status: Status.FetchingFromStorage
  });

  useEffect(() => {
    try {
      const authState = JSON.parse(localStorage.getItem("authState") || "");
      setState({ ...authState, status: Status.LoggedIn });
    } catch (_) {
      setState({ status: Status.NotLoggedIn });
    }
  }, []);

  if (state.status == Status.FetchingFromStorage) return <FullScreenSpinner />;

  const login = (credentials: Credentials) => {
    console.log("login", credentials);

    const response = {
      token: "...",
      user: { id: "..", name: "john", email: "x@a.com" }
    };

    localStorage.setItem("authState", JSON.stringify(response));
    setState({ ...response, status: Status.LoggedIn });
    return true;
  };

  const logout = () => {
    console.log("logout");

    localStorage.removeItem("authState");
    setState({ status: Status.NotLoggedIn });
  };

  const auth: Auth = {
    ...state,
    isLoggedIn: state.status == Status.LoggedIn,
    login,
    logout
  };

  return <AuthContext.Provider value={auth}>{children}</AuthContext.Provider>;
};

export const useAuth = () => useContext(AuthContext);

export default AuthProvider;
