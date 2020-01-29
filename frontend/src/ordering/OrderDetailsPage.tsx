import { gql, useQuery } from "@apollo/client";
import React from "react";
import { useParams } from "react-router-dom";
import { Header, List, Segment } from "semantic-ui-react";
import GoBackButton from "../shared/GoBackButton";
import Page from "../shared/Page";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import CancelOrderButton from "./CancelOrderButton";
import { Order, OrderDetails } from "./model";
import "./OrderDetailsPage.less";
import OrderStateLabel from "./OrderStateLabel";
import PayOrderButton from "./waitstaff/PayOrderButton";
import { formatCurrency, formatDateTime } from "/lib/format";

export const GET_ORDER_QUERY = gql`
  query OrderDetails($id: ID) {
    order(id: $id) {
      id
      code
      state
      orderAmount
      amountPaid
      tipAmount
      orderDate
      notes
      viewerCanCancel
      items {
        menuItemId
        menuItemName
        quantity
        price
      }
    }
  }
`;

function OrderDetailsPage() {
  const { id } = useParams();
  const result = useQuery<{ order: OrderDetails }>(GET_ORDER_QUERY, {
    variables: { id: id },
    pollInterval: 10000
  });

  return (
    <Page
      title="Order Details"
      className="OrderDetailsPage"
      actions={[<GoBackButton to="/orders" />]}
    >
      <QueryResultWrapper
        result={result}
        render={data => <OrderDetails order={data.order} />}
      />
    </Page>
  );
}

const OrderDetails = ({ order }: { order: OrderDetails }) => (
  <div className="order">
    <Segment.Group>
      <Header attached="top" inverted>
        Order {order.code}
        <OrderStateLabel order={order} />
      </Header>
      <Segment>
        <span className="field-name">Created on</span>
        {formatDateTime(order.orderDate)}
      </Segment>
      {order.notes && (
        <Segment>
          <span className="field-name">Notes</span>
          {order.notes}
        </Segment>
      )}
      <Segment>
        {order.items.map(item => (
          <div className="order-item" key={item.menuItemId}>
            <div className="quantity">{item.quantity} x </div>
            <div className="name">{item.menuItemName}</div>
            <div className="price">
              {formatCurrency(item.quantity * item.price)}
            </div>
          </div>
        ))}
      </Segment>
      <Segment>
        <div className="order-total">
          <div className="field-name">Order Total</div>
          <div className="amount">{formatCurrency(order.orderAmount)}</div>
        </div>
        {order.amountPaid > 0 && (
          <div className="amount-paid">
            <div className="field-name">Amount Paid</div>
            <div className="amount">{formatCurrency(order.amountPaid)}</div>
          </div>
        )}
        {order.tipAmount > 0 && (
          <div className="tip-amount">
            <div className="field-name">Tip</div>
            <div className="amount">{formatCurrency(order.tipAmount)}</div>
          </div>
        )}
      </Segment>
    </Segment.Group>

    <CancelOrderButton order={order} floated="right" />
    <PayOrderButton
      order={order}
      floated="right"
      refetchQueries={["OrderDetails"]}
    />
  </div>
);

const OrderItems = ({ order }: { order: Order }) => (
  <List relaxed>
    {order.items.map(item => (
      <List.Item key={item.menuItemId}>
        <List.Header>{item.menuItemName}</List.Header>
        {item.quantity} x {formatCurrency(item.price)}
      </List.Item>
    ))}
  </List>
);

export default OrderDetailsPage;
