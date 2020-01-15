import { gql, useQuery } from "@apollo/client";
import { Category, MenuItem } from "../configuration/MenuSection";
import Layout from "../shared/Layout";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import { formatCurrency } from "/lib/format";
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
import {
  Action,
  CurrentOrderContextType,
  Order,
  useCurrentOrder
} from "./CurrentOrderProvider";
import "./PlaceOrderForm.less";

function PlaceOrderForm() {
  const state = useCurrentOrder();

  return (
    <Layout
      header="Place Order"
      actions={[<ReviewOrderButton order={state.order} />]}
    >
      <Menu {...state} />
    </Layout>
  );
}

const MENU_QUERY = gql`
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
  const totalQty = order.items.reduce(
    (total, item) => total + item.quantity,
    0
  );

  return (
    <Transition visible={totalQty > 0} animation="fade left" duration={500}>
      <Button
        content="My Order"
        icon="cart"
        color="brown"
        label={{ content: totalQty, basic: true, color: "brown" }}
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
                {category.items?.map(item => (
                  <MenuItemCard
                    item={item}
                    dispatch={dispatch}
                    key={item.id}
                    qtyOrdered={
                      order.items.find(oi => oi.menuItemId == item.id)
                        ?.quantity || 0
                    }
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
  dispatch,
  qtyOrdered
}: {
  item: MenuItem;
  dispatch: React.Dispatch<Action>;
  qtyOrdered: number;
}) => (
  <Card
    header={item.name}
    description={item.description}
    image={item.imageUrl}
    className={qtyOrdered > 0 ? "ordered" : undefined}
    extra={
      <div className="CardExtra">
        <div>
          <Label content={formatCurrency(item.price)} tag />
        </div>
        <div className="CardActions">
          <Transition
            visible={qtyOrdered > 0}
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
                content: qtyOrdered
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
                menuItemId: item.id
              })
            }
          />
        </div>
      </div>
    }
  />
);

export default PlaceOrderForm;
