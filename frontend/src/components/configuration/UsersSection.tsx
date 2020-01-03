import React, { useState } from "react";
import { gql } from "apollo-boost";
import { useQuery } from "@apollo/react-hooks";
import APIError from "../APIError";
import Fuse from "fuse.js";
import { Tab, Grid, Input, Button, Table } from "semantic-ui-react";

type Role = "ADMIN" | "CHEF" | "WAITSTAFF" | "CASHIER" | "CUSTOMER";

type User = {
  id: string;
  email: string;
  name: string;
  role: Role;
};

type QueryResult = {
  users: User[];
};

const USERS_QUERY = gql`
  {
    users {
      id
      email
      name
      role
    }
  }
`;

function UsersSection() {
  const { loading, error, data } = useQuery<QueryResult>(USERS_QUERY);

  return (
    <Tab.Pane loading={loading}>
      {error && <APIError error={error} />}
      {data && <Users users={data?.users} />}
    </Tab.Pane>
  );
}

function Users({ users }: QueryResult) {
  const [search, setSearch] = useState("");

  const filteredUsers = search
    ? new Fuse(users, { keys: ["email", "name", "role"] }).search(search)
    : users;

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
            <Table.HeaderCell>E-mail</Table.HeaderCell>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Role</Table.HeaderCell>
            <Table.HeaderCell></Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {filteredUsers.map(user => (
            <Table.Row key={user.id}>
              <Table.Cell>{user.email}</Table.Cell>
              <Table.Cell>{user.name}</Table.Cell>
              <Table.Cell>{user.role}</Table.Cell>
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

export default UsersSection;
