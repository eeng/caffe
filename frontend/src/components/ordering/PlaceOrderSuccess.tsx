import React from "react";
import { Button, Divider, Header, Icon, Segment } from "semantic-ui-react";
import Layout from "../shared/Layout";
import { useLocation, Link, Redirect } from "react-router-dom";

function PlaceOrderSuccess() {
  const location = useLocation();

  if (!location.state) return <Redirect to={{ pathname: "/" }} />;

  return (
    <Layout header="Order Placed">
      <Segment padded="very" textAlign="center">
        <Header as="h2" icon>
          <Icon name="check circle" color="green" />
          Well Done!
          <Header.Subheader>
            Your order has been registered and we'll prepare it right away.
          </Header.Subheader>
          <Divider hidden />
          <Button
            content="View Order Status"
            primary
            as={Link}
            to={`/orders/${location.state.orderId}`}
          />
        </Header>
      </Segment>
    </Layout>
  );
}

export default PlaceOrderSuccess;
