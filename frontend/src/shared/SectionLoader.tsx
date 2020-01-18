import React from "react";
import { Segment, Loader } from "semantic-ui-react";

function SectionLoader() {
  return (
    <Segment basic padded="very">
      <Loader active />
    </Segment>
  );
}

export default SectionLoader;
