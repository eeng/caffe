import React from "react";
import { Loader } from "semantic-ui-react";
import "./FullScreenSpinner.less";

function FullScreenSpinner() {
  return (
    <div className="FullScreenSpinner">
      <Loader active size="big" />
    </div>
  );
}

export default FullScreenSpinner;
