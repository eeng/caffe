import React, { useState, useContext, useEffect } from "react";
import FullScreenSpinner from "./FullScreenSpinner";
import { gql, ApolloError } from "apollo-boost";
import { useMutation, useApolloClient } from "@apollo/react-hooks";

type User = {
  id: string;
  email: string;
  name: string;
};

export type Credentials = {
  email: string;
  password: string;
};

enum AuthStatus {
  FetchingFromStorage,
  NotLoggedIn,
  LoggingIn,
  LoggingFailed,
  LoggedIn
}

type State = {
  token?: string;
  user?: User;
  status: AuthStatus;
};

type Auth = {
  token?: string;
  user?: User;
  status: AuthStatus;
  isLoggedIn: boolean;
  isLoggingIn: boolean;
  login: (credentials: Credentials) => void;
  logout: () => void;
};

const AuthContext = React.createContext<Auth>({
  status: AuthStatus.NotLoggedIn,
  isLoggedIn: false,
  isLoggingIn: false,
  login: _ => {},
  logout: () => {}
});

const LOGIN_MUTATION = gql`
  mutation($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      token
      user {
        id
        name
        email
      }
    }
  }
`;

const AuthProvider: React.FC = ({ children }) => {
  const client = useApolloClient();

  const [state, setState] = useState<State>({
    status: AuthStatus.FetchingFromStorage
  });

  useEffect(() => {
    try {
      const authState = JSON.parse(localStorage.getItem("authState") || "");
      setState({ ...authState, status: AuthStatus.LoggedIn });
    } catch (_) {
      setState({ status: AuthStatus.NotLoggedIn });
    }
  }, []);

  if (state.status == AuthStatus.FetchingFromStorage)
    return <FullScreenSpinner />;

  const login = (credentials: Credentials) => {
    setState({ ...state, status: AuthStatus.LoggingIn });
    client
      .mutate({
        mutation: LOGIN_MUTATION,
        variables: { email: credentials.email, password: credentials.password }
      })
      .then(({ data }) => {
        localStorage.setItem("authState", JSON.stringify(data.login));
        setState({ ...data.login, status: AuthStatus.LoggedIn });
      })
      .catch((error: ApolloError) => {
        if (error.graphQLErrors[0].message == "invalid_credentials")
          setState({ status: AuthStatus.LoggingFailed });
        else {
          setState({ status: AuthStatus.NotLoggedIn });
          throw error;
        }
      });
  };

  const logout = () => {
    localStorage.removeItem("authState");
    setState({ status: AuthStatus.NotLoggedIn });
  };

  const auth: Auth = {
    ...state,
    isLoggedIn: state.status == AuthStatus.LoggedIn,
    isLoggingIn: state.status == AuthStatus.LoggingIn,
    login,
    logout
  };

  return <AuthContext.Provider value={auth}>{children}</AuthContext.Provider>;
};

export const useAuth = () => useContext(AuthContext);

export default AuthProvider;
