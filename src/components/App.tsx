import React from "react";
import CssBaseline from "@material-ui/core/CssBaseline";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "@apollo/react-hooks";
import Login from "./Login";
import Home from "./Home";

const client = new ApolloClient({
  uri: "/api"
});

const App: React.FC = () => {
  return (
    <>
      <CssBaseline />
      <ApolloProvider client={client}>
        <Home />
      </ApolloProvider>
    </>
  );
};

export default App;
