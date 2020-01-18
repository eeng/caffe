import { gql, useQuery } from "@apollo/client";
import React from "react";
import { useParams } from "react-router-dom";
import { Label, List, Table } from "semantic-ui-react";
import GoBackButton from "../shared/GoBackButton";
import Page from "../shared/Page";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import { Order, OrderDetails } from "./model";
import { formatCurrency, formatDateTime } from "/lib/format";

const GET_ORDER_QUERY = gql`
  query($id: ID) {
    order(id: $id) {
      id
      state
      orderAmount
      orderDate
      notes
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
  <Table definition>
    <Table.Body>
      <Table.Row>
        <Table.Cell>ID</Table.Cell>
        <Table.Cell>{order.id}</Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>Date</Table.Cell>
        <Table.Cell>{formatDateTime(order.orderDate)}</Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>State</Table.Cell>
        <Table.Cell>
          <Label content={order.state.toUpperCase()} />
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
        <Table.Cell>Total</Table.Cell>
        <Table.Cell>{formatCurrency(order.orderAmount)}</Table.Cell>
      </Table.Row>
    </Table.Body>
  </Table>
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
