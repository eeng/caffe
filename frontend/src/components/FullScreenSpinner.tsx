import React from "react";
import { Loader } from "semantic-ui-react";
import styles from "./FullScreenSpinner.module.css";

function FullScreenSpinner() {
  return (
    <div className={styles.container}>
      <Loader active size="huge" />
    </div>
  );
}

export default FullScreenSpinner;
