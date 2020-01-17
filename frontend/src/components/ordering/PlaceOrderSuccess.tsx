import React from "react";
import { Button, Divider, Header, Icon, Segment } from "semantic-ui-react";
import Page from "../shared/Page";
import { useLocation, Link, Redirect } from "react-router-dom";
import Result from "../shared/Result";

function PlaceOrderSuccess() {
  const location = useLocation();

  if (!location.state) return <Redirect to="/place_order" />;

  return (
    <Page title="Order Placed">
      <Result
        header="Well Done"
        subheader="Your order has been registered and we'll prepare it right away."
        icon="check circle"
        color="green"
        actions={[
          <Button
            content="View Order Status"
            primary
            as={Link}
            to={`/orders/${location.state.orderId}`}
          />
        ]}
      />
    </Page>
  );
}

export default PlaceOrderSuccess;
