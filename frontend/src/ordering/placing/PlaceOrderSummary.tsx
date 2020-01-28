import { gql, useMutation } from "@apollo/client";
import _ from "lodash";
import React, { useEffect } from "react";
import { Link, useHistory } from "react-router-dom";
import {
  Button,
  Divider,
  Form,
  Table,
  TextArea,
  TextAreaProps,
  Container
} from "semantic-ui-react";
import GoBackButton from "../../shared/GoBackButton";
import Page from "../../shared/Page";
import Result from "../../shared/Result";
import {
  CurrentOrderContextType,
  useCurrentOrder
} from "./CurrentOrderProvider";
import { isOrderEmpty, Order, OrderItem, orderTotalAmount } from "../model";
import "./PlaceOrderSummary.less";
import { formatCurrency } from "/lib/format";

function PlaceOrderSummary() {
  const state = useCurrentOrder();

  return (
    <Page
      title="Order Summary"
      actions={[<GoBackButton to="/place_order" />]}
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

function OrderDetails({ order, dispatch }: CurrentOrderContextType) {
  return (
    <Container>
      <Table>
        <Table.Body>
          {order.items.map(item => (
            <Table.Row key={item.menuItemId}>
              <Table.Cell collapsing>
                <span className="quantity">{item.quantity} x </span>
                <span className="item-name">{item.menuItemName}</span>
              </Table.Cell>
              <Table.Cell className="item-actions">
                <Button
                  icon="add"
                  compact
                  basic
                  circular
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
                  circular
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
                  circular
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
              <Table.Cell textAlign="right" collapsing className="price">
                {formatCurrency(item.price * item.quantity)}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
        <Table.Footer>
          <Table.Row>
            <Table.HeaderCell className="total-label" colSpan="2">
              Total
            </Table.HeaderCell>
            <Table.HeaderCell className="total-amount">
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
      <Button content="Modify Order" icon="edit" as={Link} to="/place_order" />
      <ConfirmOrderButton order={order} dispatch={dispatch} />
    </Container>
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
  items: order.items.map(item => _.pick(item, ["menuItemId", "quantity"]))
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
      icon="check"
    />
  );
}

const EmptyOrderMessage = () => (
  <Result
    header="Your order is empty!"
    icon="meh outline"
    placeholder
    actions={[
      <Button content="Order Something" primary as={Link} to="/place_order" />
    ]}
  />
);

export default PlaceOrderSummary;
