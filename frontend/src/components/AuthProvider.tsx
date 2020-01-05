import React, { useState, useContext, useEffect } from "react";
import FullScreenSpinner from "./FullScreenSpinner";
import { gql, ApolloError } from "apollo-boost";
import { useApolloClient } from "@apollo/react-hooks";

type User = {
  id: string;
  email: string;
  name: string;
};

export type Credentials = {
  email: string;
  password: string;
};

export enum AuthStatus {
  FetchingFromStorage,
  NotLoggedIn,
  LoggingIn,
  LoggingFailed,
  LoggedIn
}

interface State {
  user?: User;
  status: AuthStatus;
}

interface Auth extends State {
  login: (credentials: Credentials) => void;
  logout: () => void;
}

const AuthContext = React.createContext<Auth>({
  status: AuthStatus.NotLoggedIn,
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

function AuthProvider({ children }: any) {
  const client = useApolloClient();

  const [state, setState] = useState<State>({
    status: AuthStatus.FetchingFromStorage
  });

  useEffect(() => {
    try {
      const user = JSON.parse(localStorage.getItem("user") || "");
      setState({ user, status: AuthStatus.LoggedIn });
    } catch (_) {
      setState({ status: AuthStatus.NotLoggedIn });
    }
  }, []);

  if (state.status == AuthStatus.FetchingFromStorage)
    return <FullScreenSpinner />;

  const login = (credentials: Credentials) => {
    setState({ status: AuthStatus.LoggingIn });

    client
      .mutate({ mutation: LOGIN_MUTATION, variables: credentials })
      .then(({ data }) => {
        const { token, user } = data.login;

        localStorage.setItem("token", token);
        localStorage.setItem("user", JSON.stringify(user));

        setState({ user, status: AuthStatus.LoggedIn });

        // Clear the Apollo cache
        client.resetStore();
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
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    setState({ status: AuthStatus.NotLoggedIn });
  };

  const auth: Auth = {
    ...state,
    login,
    logout
  };

  return <AuthContext.Provider value={auth}>{children}</AuthContext.Provider>;
}

export const useAuth = () => useContext(AuthContext);

export default AuthProvider;
