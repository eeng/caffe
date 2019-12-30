import React from "react";
import CssBaseline from "@material-ui/core/CssBaseline";
import "typeface-roboto";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "@apollo/react-hooks";
import Login from "./Login";

const client = new ApolloClient({
  uri: "/api"
});

const App: React.FC = () => {
  return (
    <>
      <CssBaseline />
      <ApolloProvider client={client}>
        <Login />
      </ApolloProvider>
    </>
  );
};

export default App;
