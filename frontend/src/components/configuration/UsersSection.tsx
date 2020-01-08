import { gql, useQuery } from "@apollo/client";
import Fuse from "fuse.js";
import React, { useState } from "react";
import { Message, Table } from "semantic-ui-react";
import QueryResultWrapper from "../shared/QueryResult";
import SearchInput from "../shared/SearchInput";

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
  const result = useQuery<QueryResult>(USERS_QUERY);

  return (
    <QueryResultWrapper
      result={result}
      render={data => <Users users={data.users} />}
    />
  );
}

function Users({ users }: QueryResult) {
  const [search, setSearch] = useState("");

  const filteredUsers = search
    ? new Fuse(users, { keys: ["email", "name", "role"] }).search(search)
    : users;

  return (
    <>
      <SearchInput search={search} onSearch={setSearch} autoFocus />

      {filteredUsers.length ? (
        <Table celled>
          <Table.Header>
            <Table.Row>
              <Table.HeaderCell>E-mail</Table.HeaderCell>
              <Table.HeaderCell>Name</Table.HeaderCell>
              <Table.HeaderCell>Role</Table.HeaderCell>
            </Table.Row>
          </Table.Header>
          <Table.Body>
            {filteredUsers.map(user => (
              <Table.Row key={user.id}>
                <Table.Cell>{user.email}</Table.Cell>
                <Table.Cell>{user.name}</Table.Cell>
                <Table.Cell>{user.role}</Table.Cell>
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      ) : (
        <Message content="No users were found." />
      )}
    </>
  );
}

export default UsersSection;
