import React from "react";
import CssBaseline from "@material-ui/core/CssBaseline";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "@apollo/react-hooks";
import RootPageChooser from "./RootPageChooser";
import AuthProvider from "./AuthProvider";

const client = new ApolloClient({
  uri: "/api"
});

const App: React.FC = () => {
  return (
    <>
      <CssBaseline />
      <ApolloProvider client={client}>
        <AuthProvider>
          <RootPageChooser />
        </AuthProvider>
      </ApolloProvider>
    </>
  );
};

export default App;
