import React, { useState } from "react";
import { Table, Tab, Input, Button, Grid } from "semantic-ui-react";
import { gql } from "apollo-boost";
import { useQuery } from "@apollo/react-hooks";
import APIError from "../APIError";
import Fuse from "fuse.js";
import { formatCurrency } from "../../lib/format";

type Category = {
  name: string;
};

type MenuItem = {
  id: string;
  name: string;
  description: string;
  price: number;
  isDrink: boolean;
  category: Category;
};

type QueryResult = {
  menuItems: MenuItem[];
};

const MENU_ITEMS_QUERY = gql`
  {
    menuItems {
      id
      name
      description
      price
      isDrink
      category {
        name
      }
    }
  }
`;

function MenuSection() {
  const { loading, error, data } = useQuery<QueryResult>(MENU_ITEMS_QUERY);

  return (
    <Tab.Pane loading={loading}>
      {error && <APIError error={error} />}
      {data && <MenuItemsList menuItems={data?.menuItems} />}
    </Tab.Pane>
  );
}

function MenuItemsList({ menuItems }: QueryResult) {
  const [search, setSearch] = useState("");

  const filteredMenuItems = search
    ? new Fuse(menuItems, { keys: ["name", "category.name"] }).search(search)
    : menuItems;

  return (
    <>
      <Grid columns="2">
        <Grid.Column>
          <Input
            icon="search"
            placeholder="Search..."
            value={search}
            onChange={(_, { value }) => setSearch(value)}
            autoFocus
          />
        </Grid.Column>
        <Grid.Column textAlign="right">
          <Button content="Add" primary icon="plus" labelPosition="right" />
        </Grid.Column>
      </Grid>

      <Table celled>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Category</Table.HeaderCell>
            <Table.HeaderCell textAlign="right" collapsing>
              Price
            </Table.HeaderCell>
            <Table.HeaderCell></Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {filteredMenuItems.map(item => (
            <Table.Row key={item.id}>
              <Table.Cell>{item.name}</Table.Cell>
              <Table.Cell>{item.category.name}</Table.Cell>
              <Table.Cell textAlign="right">
                {formatCurrency(item.price)}
              </Table.Cell>
              <Table.Cell singleLine collapsing>
                <Button icon="edit" size="tiny" compact circular basic />
                <Button
                  icon="delete"
                  color="red"
                  size="tiny"
                  compact
                  circular
                  basic
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </>
  );
}

export default MenuSection;
