import React from "react";
import {
  Divider,
  Header,
  Icon,
  Segment,
  SemanticICONS,
  StrictSegmentProps,
  SemanticCOLORS
} from "semantic-ui-react";

interface Props extends StrictSegmentProps {
  header?: string;
  subheader?: string;
  icon?: SemanticICONS;
  color?: SemanticCOLORS;
  actions?: React.ReactNode[];
}

function Result({
  header,
  subheader,
  icon = "info circle",
  color,
  actions = [],
  ...rest
}: Props) {
  return (
    <Segment padded="very" textAlign="center" {...rest}>
      <Header as="h2" icon>
        <Icon name={icon} color={color} />
        {header}
        {subheader && <Header.Subheader>{subheader}</Header.Subheader>}
      </Header>
      <Divider hidden />
      {actions.map((action, i) => (
        <div key={i}>{action}</div>
      ))}
    </Segment>
  );
}

export default Result;
