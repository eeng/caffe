import { gql, useMutation } from "@apollo/client";
import React, { useEffect } from "react";
import { Link, useHistory } from "react-router-dom";
import {
  Button,
  Divider,
  Form,
  Header,
  Icon,
  Segment,
  Table,
  TextArea,
  TextAreaProps
} from "semantic-ui-react";
import Page from "../shared/Page";
import {
  CurrentOrderContextType,
  useCurrentOrder
} from "./CurrentOrderProvider";
import { isOrderEmpty, Order, OrderItem, orderTotalAmount } from "./model";
import "./PlaceOrderSummary.less";
import { formatCurrency } from "/lib/format";

function PlaceOrderSummary() {
  const state = useCurrentOrder();

  return (
    <Page
      title="Order Summary"
      actions={[<GoBackButton />]}
      className="PlaceOrderSummary"
    >
      {isOrderEmpty(state.order) ? (
        <EmptyOrderMessage />
      ) : (
        <OrderDetails {...state} />
      )}
    </Page>
  );
}

const GoBackButton = () => (
  <Button icon="reply" color="brown" as={Link} to="/place_order" />
);

function OrderDetails({ order, dispatch }: CurrentOrderContextType) {
  return (
    <>
      <Table>
        <Table.Body>
          {order.items.map(item => (
            <Table.Row key={item.menuItemId}>
              <Table.Cell>{item.menuItemName}</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  icon="add"
                  compact
                  basic
                  size="small"
                  onClick={() =>
                    dispatch({
                      type: "INCREMENT_QTY",
                      menuItemId: item.menuItemId
                    })
                  }
                />
                <Button
                  icon="minus"
                  compact
                  basic
                  size="small"
                  disabled={item.quantity == 1}
                  onClick={() =>
                    dispatch({
                      type: "DECREMENT_QTY",
                      menuItemId: item.menuItemId
                    })
                  }
                />
                <Button
                  icon="remove"
                  compact
                  basic
                  size="small"
                  color="red"
                  onClick={() =>
                    dispatch({
                      type: "REMOVE_ITEM",
                      menuItemId: item.menuItemId
                    })
                  }
                />
              </Table.Cell>
              <Table.Cell textAlign="right" collapsing>
                {item.quantity} x {formatCurrency(item.price)}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
        <Table.Footer>
          <Table.Row>
            <Table.HeaderCell className="TotalLabel" colSpan="2">
              Total
            </Table.HeaderCell>
            <Table.HeaderCell className="TotalAmount">
              {formatCurrency(orderTotalAmount(order))}
            </Table.HeaderCell>
          </Table.Row>
        </Table.Footer>
      </Table>

      <Form>
        <TextArea
          placeholder="You can enter additional notes here..."
          value={order.notes}
          onChange={(_, { value }: TextAreaProps) =>
            dispatch({ type: "FIELD_CHANGE", field: "notes", value: value })
          }
        />
      </Form>

      <Divider hidden />
      <ConfirmOrderButton order={order} dispatch={dispatch} />
    </>
  );
}

type OrderItemInput = Pick<OrderItem, "menuItemId" | "quantity"> & {
  menuItemId: string;
};
type PlaceOrderInput = Omit<Order, "items"> & { items: OrderItemInput[] };

const PLACE_ORDER_MUTATION = gql`
  mutation($items: [OrderItemInput], $notes: String) {
    placeOrder(items: $items, notes: $notes) {
      id
    }
  }
`;

const orderToMutationInput = (order: Order): PlaceOrderInput => ({
  ...order,
  items: order.items.map(item => ({
    quantity: item.quantity,
    menuItemId: item.menuItemId
  }))
});

function ConfirmOrderButton({ order, dispatch }: CurrentOrderContextType) {
  const [placeOrder, { loading, data }] = useMutation(PLACE_ORDER_MUTATION, {
    variables: orderToMutationInput(order)
  });

  const history = useHistory();
  useEffect(() => {
    if (data) {
      history.replace("/place_order/success", { orderId: data.placeOrder.id });
      dispatch({ type: "RESET_ORDER" });
    }
  }, [data]);

  return (
    <Button
      primary
      content="Confirm Order"
      size="large"
      floated="right"
      loading={loading}
      disabled={loading}
      onClick={() => placeOrder()}
    />
  );
}

const EmptyOrderMessage = () => (
  <Segment padded="very" textAlign="center" placeholder>
    <Header as="h2" icon>
      <Icon name="meh outline" />
      Your order is empty!
      <Divider hidden />
      <Button content="Order Something" primary as={Link} to="/place_order" />
    </Header>
  </Segment>
);

export default PlaceOrderSummary;
