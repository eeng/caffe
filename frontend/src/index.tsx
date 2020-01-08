import React from "react";
import ReactDOM from "react-dom";
import App from "./components/App";

ReactDOM.render(<App />, document.getElementById("root"));

// Needed for Hot Module Replacement
if (typeof module.hot !== "undefined") {
  module.hot.accept();
}
