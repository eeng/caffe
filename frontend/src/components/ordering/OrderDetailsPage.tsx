import React from "react";
import Page from "../shared/Page";
import { useParams } from "react-router-dom";
import { gql, useQuery } from "@apollo/client";
import { Order } from "./model";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import { Table, List, Label } from "semantic-ui-react";
import { formatCurrency, formatDate } from "/lib/format";

const GET_ORDER_QUERY = gql`
  query($id: ID) {
    order(id: $id) {
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

interface OrderDetails extends Order {
  orderAmount: number;
  state: string;
  orderDate: Date;
}

function OrderDetailsPage() {
  const { id } = useParams();
  const result = useQuery<OrderDetails>(GET_ORDER_QUERY, {
    variables: { id: id }
  });

  return (
    <Page title="Order Details">
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
        <Table.Cell>Date</Table.Cell>
        <Table.Cell>{formatDate(order.orderDate)}</Table.Cell>
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
