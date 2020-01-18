import React from "react";
import { Popup, Button, PopupProps } from "semantic-ui-react";

interface Props extends PopupProps {
  onConfirm: () => any;
}

function Confirm({ onConfirm, children, ...rest }: Props) {
  return (
    <Popup
      content={<Button content="Confirm" color="red" onClick={onConfirm} />}
      trigger={children}
      on="click"
      pinned
      position="top center"
      {...rest}
    />
  );
}

export default Confirm;
