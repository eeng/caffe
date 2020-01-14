import { gql, QueryResult, useQuery } from "@apollo/client";
import { MenuItem } from "components/configuration/MenuSection";
import Layout from "components/shared/Layout";
import QueryResultWrapper from "components/shared/QueryResultWrapper";
import { formatCurrency } from "lib/format";
import React from "react";
import { Button, Card, Grid, Label } from "semantic-ui-react";

function PlaceOrderPage() {
  return (
    <Layout header="Place Order">
      <Menu />
    </Layout>
  );
}

export const MENU_ITEMS_QUERY = gql`
  query OrderMenuItems {
    menuItems {
      id
      name
      description
      price
      imageUrl
      category {
        name
      }
    }
  }
`;

function Menu() {
  const result = useQuery<QueryResult>(MENU_ITEMS_QUERY);

  return (
    <QueryResultWrapper
      result={result}
      render={data =>
        data.menuItems.map((item: MenuItem) => (
          <MenuItemCard item={item} key={item.id} />
        ))
      }
    />
  );
}

const MenuItemCard = ({ item }: { item: MenuItem }) => (
  <Card
    header={item.name}
    meta={item.category.name}
    description={item.description}
    image={item.imageUrl}
    extra={
      <Grid columns="equal">
        <Grid.Column verticalAlign="middle">
          <Label content={formatCurrency(item.price)} tag />
        </Grid.Column>
        <Grid.Column textAlign="right">
          <Button
            content="Add"
            compact
            basic
            color="green"
            icon="add to cart"
          />
        </Grid.Column>
      </Grid>
    }
  />
);

export default PlaceOrderPage;
