import { gql, useMutation, useQuery } from "@apollo/client";
import Fuse from "fuse.js";
import React, { useState } from "react";
import { Link, Route, Switch, useRouteMatch } from "react-router-dom";
import { toast } from "react-semantic-toasts";
import { Button, Grid, Message, Popup, Table } from "semantic-ui-react";
import { formatCurrency } from "../lib/format";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import SearchInput from "../shared/SearchInput";
import { EditMenuItemForm, NewMenuItemForm } from "./MenuItemForm";
import { MenuItem } from "./model";

type QueryResult = {
  menuItems: MenuItem[];
};

export const MENU_ITEMS_QUERY = gql`
  query GetMenuItems {
    menuItems {
      id
      name
      price
      isDrink
      category {
        name
      }
    }
  }
`;

function MenuSection() {
  const { url } = useRouteMatch();
  return (
    <Switch>
      <Route exact path={url} component={MenuItemsList} />
      <Route path={`${url}/new`} component={NewMenuItemForm} />
      <Route path={`${url}/edit/:id`} component={EditMenuItemForm} />
    </Switch>
  );
}

function MenuItemsList() {
  const result = useQuery<QueryResult>(MENU_ITEMS_QUERY);

  return (
    <QueryResultWrapper
      result={result}
      render={data => <MenuItems menuItems={data.menuItems} />}
    />
  );
}

function MenuItems({ menuItems }: QueryResult) {
  const [search, setSearch] = useState("");
  const { url } = useRouteMatch();

  const filteredMenuItems = search
    ? new Fuse(menuItems, { keys: ["name", "category.name"] }).search(search)
    : menuItems;

  return (
    <>
      <Grid columns="2">
        <Grid.Column>
          <SearchInput search={search} onSearch={setSearch} autoFocus />
        </Grid.Column>
        <Grid.Column textAlign="right">
          <Button
            content="Add"
            primary
            icon="plus"
            labelPosition="right"
            as={Link}
            to={`${url}/new`}
          />
        </Grid.Column>
      </Grid>

      {filteredMenuItems.length ? (
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
                  <Button
                    icon="edit"
                    size="tiny"
                    compact
                    circular
                    basic
                    as={Link}
                    to={`${url}/edit/${item.id}`}
                  />
                  <DeleteMenuItemButton item={item} />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      ) : (
        <Message content="No menu items were found." />
      )}
    </>
  );
}

export const DELETE_MENU_ITEM_MUTATION = gql`
  mutation($id: ID!) {
    deleteMenuItem(id: $id) {
      id
    }
  }
`;

function DeleteMenuItemButton({ item }: { item: MenuItem }) {
  const [deleteMenuItem, { loading }] = useMutation(DELETE_MENU_ITEM_MUTATION, {
    variables: { id: item.id },
    refetchQueries: ["GetMenuItems"],
    awaitRefetchQueries: true
  });

  function handleConfirm() {
    deleteMenuItem().then(() =>
      toast({
        title: "Deleted!",
        description: `Menu "${item.name}" is gone...`,
        type: "success",
        time: 4000
      })
    );
  }

  return (
    <Popup
      content={<Button content="Confirm" color="red" onClick={handleConfirm} />}
      on="click"
      pinned
      position="top center"
      disabled={loading}
      trigger={
        <Button
          icon="delete"
          color="red"
          size="tiny"
          compact
          circular
          basic
          loading={loading}
          disabled={loading}
          title="Delete"
        />
      }
    />
  );
}

export default MenuSection;
