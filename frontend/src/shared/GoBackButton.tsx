import React from "react";
import { Link } from "react-router-dom";
import { Button, ButtonProps } from "semantic-ui-react";

function GoBackButton(props: ButtonProps) {
  return <Button icon="reply" color="brown" as={Link} {...props} />;
}

export default GoBackButton;
