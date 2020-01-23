import { gql, useQuery } from "@apollo/client";
import React from "react";
import { useParams } from "react-router-dom";
import { List, Table } from "semantic-ui-react";
import GoBackButton from "../shared/GoBackButton";
import Page from "../shared/Page";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import CancelOrderButton from "./CancelOrderButton";
import { Order, OrderDetails } from "./model";
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
    <Page title="Order Details" actions={[<GoBackButton to="/orders" />]}>
      <QueryResultWrapper
        result={result}
        render={data => <OrderDetails order={data.order} />}
      />
    </Page>
  );
}

const OrderDetails = ({ order }: { order: OrderDetails }) => (
  <>
    <Table definition>
      <Table.Body>
        <Table.Row>
          <Table.Cell>Code</Table.Cell>
          <Table.Cell>{order.code}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Date</Table.Cell>
          <Table.Cell>{formatDateTime(order.orderDate)}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>State</Table.Cell>
          <Table.Cell>
            <OrderStateLabel order={order} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Items</Table.Cell>
          <Table.Cell>
            <OrderItems order={order} />
          </Table.Cell>
        </Table.Row>
        {order.notes && (
          <Table.Row>
            <Table.Cell>Notes</Table.Cell>
            <Table.Cell>{order.notes}</Table.Cell>
          </Table.Row>
        )}
        <Table.Row>
          <Table.Cell>Order Total</Table.Cell>
          <Table.Cell>{formatCurrency(order.orderAmount)}</Table.Cell>
        </Table.Row>
        {order.amountPaid > 0 && (
          <Table.Row>
            <Table.Cell>Amount Paid</Table.Cell>
            <Table.Cell>{formatCurrency(order.amountPaid)}</Table.Cell>
          </Table.Row>
        )}
        {order.tipAmount > 0 && (
          <Table.Row>
            <Table.Cell>Tip</Table.Cell>
            <Table.Cell>{formatCurrency(order.tipAmount)}</Table.Cell>
          </Table.Row>
        )}
      </Table.Body>
    </Table>

    <CancelOrderButton order={order} floated="right" />
    <PayOrderButton
      order={order}
      floated="right"
      refetchQueries={["OrderDetails"]}
    />
  </>
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
