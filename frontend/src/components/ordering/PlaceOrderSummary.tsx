import Layout from "components/shared/Layout";
import React from "react";
import { Link } from "react-router-dom";
import { Button, Segment, Header, Icon } from "semantic-ui-react";
import { useCurrentOrder, isOrderEmpty, Order } from "./CurrentOrderProvider";

function PlaceOrderSummary() {
  const { order } = useCurrentOrder();

  return (
    <Layout header="Order Summary" actions={[<GoBackButton />]}>
      {isOrderEmpty(order) ? (
        <EmptyOrderMessage />
      ) : (
        <OrderDetails order={order} />
      )}
    </Layout>
  );
}

const GoBackButton = () => (
  <Button icon="reply" color="brown" as={Link} to="/place_order" />
);

const OrderDetails = ({ order }: { order: Order }) => (
  <Header content="Items" />
);

const EmptyOrderMessage = () => (
  <Segment placeholder>
    <Header icon>
      <Icon name="meh outline" />
      Your order is empty!
    </Header>
    <Button primary as={Link} to="/place_order">
      Order Something
    </Button>
  </Segment>
);

export default PlaceOrderSummary;
