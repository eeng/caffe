import { gql, useQuery } from "@apollo/client";
import React from "react";
import { Link } from "react-router-dom";
import { Button, Label, Table } from "semantic-ui-react";
import Page from "../shared/Page";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import Result from "../shared/Result";
import { OrderDetails } from "./model";
import { formatCurrency, formatDate } from "/lib/format";

export const MY_ORDERS_QUERY = gql`
  query {
    orders {
      id
      orderDate
      orderAmount
      state
    }
  }
`;

function OrdersPage() {
  const result = useQuery<{ orders: OrderDetails[] }>(MY_ORDERS_QUERY);

  return (
    <Page title="My Orders">
      <QueryResultWrapper
        result={result}
        render={data =>
          data.orders.length ? (
            <OrderList orders={data.orders} />
          ) : (
            <Result
              header="No Orders"
              subheader="You haven't placed any orders yet."
              icon="folder open outline"
              actions={[
                <Button
                  content="Place Order"
                  primary
                  as={Link}
                  to="/place_order"
                />
              ]}
            />
          )
        }
      />
    </Page>
  );
}

function OrderList({ orders }: { orders: OrderDetails[] }) {
  return (
    <Table>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell>ID</Table.HeaderCell>
          <Table.HeaderCell textAlign="center">Date</Table.HeaderCell>
          <Table.HeaderCell textAlign="center">State</Table.HeaderCell>
          <Table.HeaderCell textAlign="right">Amount</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {orders.map(order => (
          <Table.Row key={order.id}>
            <Table.Cell>
              <Link to={`/orders/${order.id}`}>{order.id}</Link>
            </Table.Cell>
            <Table.Cell textAlign="center">
              {formatDate(order.orderDate)}
            </Table.Cell>
            <Table.Cell textAlign="center">
              <Label content={order.state.toUpperCase()} />
            </Table.Cell>
            <Table.Cell textAlign="right">
              {formatCurrency(order.orderAmount)}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
}

export default OrdersPage;
