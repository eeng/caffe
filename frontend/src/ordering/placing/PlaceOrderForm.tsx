import { gql, useQuery } from "@apollo/client";
import React from "react";
import { Link } from "react-router-dom";
import {
  Button,
  Card,
  Header,
  Label,
  Segment,
  Transition
} from "semantic-ui-react";
import { Category, MenuItem } from "../../configuration/model";
import Page from "../../shared/Page";
import QueryResultWrapper from "../../shared/QueryResultWrapper";
import {
  CurrentOrderContextType,
  useCurrentOrder
} from "./CurrentOrderProvider";
import { Order, OrderItem, orderTotalQty } from "../model";
import "./PlaceOrderForm.less";
import { formatCurrency } from "/lib/format";
import _ from "lodash";
import { Action } from "./model";

function PlaceOrderForm() {
  const state = useCurrentOrder();

  return (
    <Page
      title="Place Order"
      actions={[<ReviewOrderButton order={state.order} />]}
    >
      <Menu {...state} />
    </Page>
  );
}

export const MENU_QUERY = gql`
  query PlaceOrderMenu {
    categories {
      name
      position
      items {
        id
        name
        description
        price
        imageUrl
      }
    }
  }
`;

function ReviewOrderButton({ order }: { order: Order }) {
  const totalQty = orderTotalQty(order);

  return (
    <Transition visible={totalQty > 0} animation="fade left" duration={500}>
      <Button
        content="Review Order"
        icon="cart"
        color="green"
        label={{ content: totalQty, basic: true, color: "green" }}
        labelPosition="right"
        as={Link}
        to="/place_order/summary"
      />
    </Transition>
  );
}

interface QueryResult {
  categories: Category[];
}

function Menu({ order, dispatch }: CurrentOrderContextType) {
  const result = useQuery<QueryResult>(MENU_QUERY);

  return (
    <QueryResultWrapper
      result={result}
      render={(data: QueryResult) => (
        <>
          {data.categories.map(category => (
            <Segment vertical key={category.name}>
              <Header content={category.name} color="grey" as="h2" />
              <div className="CardGroup">
                {_.sortBy(category.items, ["name"]).map(item => (
                  <MenuItemCard
                    item={item}
                    dispatch={dispatch}
                    key={item.id}
                    orderedItem={order.items.find(
                      oi => oi.menuItemId == item.id
                    )}
                  />
                ))}
              </div>
            </Segment>
          ))}
        </>
      )}
    />
  );
}

const MenuItemCard = ({
  item,
  orderedItem,
  dispatch
}: {
  item: MenuItem;
  orderedItem?: OrderItem;
  dispatch: React.Dispatch<Action>;
}) => (
  <Card
    header={item.name}
    description={item.description}
    image={item.imageUrl}
    className={orderedItem ? "ordered" : undefined}
    extra={
      <div className="CardExtra">
        <div>
          <Label content={formatCurrency(item.price)} tag />
        </div>
        <div className="CardActions">
          <Transition
            visible={Boolean(orderedItem)}
            animation="fade left"
            duration={300}
          >
            <Button
              color="red"
              icon="remove"
              label={{
                basic: true,
                color: "red",
                pointing: "left",
                content: orderedItem?.quantity || 0
              }}
              onClick={() =>
                dispatch({
                  type: "REMOVE_ITEM",
                  menuItemId: item.id
                })
              }
            />
          </Transition>
          <Button
            content="Add"
            basic
            color="green"
            icon="plus"
            onClick={() =>
              dispatch({
                type: "ADD_ITEM",
                quantity: 1,
                menuItem: item
              })
            }
          />
        </div>
      </div>
    }
  />
);

export default PlaceOrderForm;
