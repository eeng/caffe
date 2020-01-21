import { gql, useQuery } from "@apollo/client";
import React from "react";
import { Link } from "react-router-dom";
import { Button, Table } from "semantic-ui-react";
import Page from "../shared/Page";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import Result from "../shared/Result";
import CancelOrderButton from "./CancelOrderButton";
import { OrderDetails } from "./model";
import OrderState from "./OrderState";
import { formatCurrency, formatDistanceToNow } from "/lib/format";

export const MY_ORDERS_QUERY = gql`
  query {
    orders {
      id
      code
      orderDate
      orderAmount
      state
      viewerCanCancel
    }
  }
`;

function OrdersPage() {
  const result = useQuery<{ orders: OrderDetails[] }>(MY_ORDERS_QUERY);

  return (
    <Page title="Orders">
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
          <Table.HeaderCell>Code</Table.HeaderCell>
          <Table.HeaderCell>Date</Table.HeaderCell>
          <Table.HeaderCell textAlign="center">State</Table.HeaderCell>
          <Table.HeaderCell textAlign="right">Amount</Table.HeaderCell>
          <Table.HeaderCell collapsing>Actions</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {orders.map(order => (
          <Table.Row key={order.id}>
            <Table.Cell>
              <Link to={`/orders/${order.id}`}>{order.code}</Link>
            </Table.Cell>
            <Table.Cell>{formatDistanceToNow(order.orderDate)}</Table.Cell>
            <Table.Cell textAlign="center">
              <OrderState order={order} />
            </Table.Cell>
            <Table.Cell textAlign="right">
              {formatCurrency(order.orderAmount)}
            </Table.Cell>
            <Table.Cell>
              <CancelOrderButton order={order} basic compact size="small" />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
}

export default OrdersPage;
