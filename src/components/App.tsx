import React from "react";
import styles from "./App.module.css";
import Menu from "./Menu";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "@apollo/react-hooks";

const client = new ApolloClient({
  uri: "/api"
});

const App: React.FC = () => {
  return (
    <ApolloProvider client={client}>
      <div className={styles.app}>
        <Menu />
      </div>
    </ApolloProvider>
  );
};

export default App;
