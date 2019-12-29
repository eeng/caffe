import * as React from "react";
import styles from "./App.module.css";
import Menu from "./Menu";

const App: React.FC = () => {
  return (
    <div className={styles.app}>
      <Menu />
    </div>
  );
};

export default App;
