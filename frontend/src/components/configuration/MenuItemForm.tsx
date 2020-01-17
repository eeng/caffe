import { gql, useMutation, useQuery } from "@apollo/client";
import React, { useState } from "react";
import { Link, useHistory, useParams } from "react-router-dom";
import { toast } from "react-semantic-toasts";
import { Button, Form, Segment } from "semantic-ui-react";
import QueryResultWrapper from "../shared/QueryResultWrapper";
import CategoryDropdown from "./CategoryDropdown";
import { MENU_ITEMS_QUERY } from "./MenuSection";

type MenuItemInput = {
  id?: string;
  name: string;
  description?: string;
  price: string;
  isDrink: boolean;
  categoryId?: string;
};

const CREATE_MENU_ITEM = gql`
  mutation(
    $name: String!
    $description: String
    $price: Decimal!
    $categoryId: ID!
    $isDrink: Boolean
  ) {
    createMenuItem(
      name: $name
      description: $description
      price: $price
      categoryId: $categoryId
      isDrink: $isDrink
    ) {
      id
    }
  }
`;

const UPDATE_MENU_ITEM = gql`
  mutation(
    $id: ID!
    $name: String!
    $description: String
    $price: Decimal!
    $categoryId: ID!
    $isDrink: Boolean
  ) {
    updateMenuItem(
      id: $id
      name: $name
      description: $description
      price: $price
      categoryId: $categoryId
      isDrink: $isDrink
    ) {
      id
    }
  }
`;

function MenuItemForm({ item }: { item: MenuItemInput }) {
  const isNewRecord = item.id == null;
  const [formData, setFormData] = useState(item);

  const [save, { loading }] = useMutation(
    isNewRecord ? CREATE_MENU_ITEM : UPDATE_MENU_ITEM,
    {
      // I needed to pass the whole query object due to this issue: https://github.com/apollographql/apollo-client/issues/5419
      refetchQueries: [
        { query: MENU_ITEMS_QUERY },
        "GetMenuItem",
        "PlaceOrderMenu"
      ],
      awaitRefetchQueries: true
    }
  );

  const history = useHistory();

  function handleChange(_event: any, { name, value }: any) {
    setFormData({ ...formData, [name]: value });
  }

  const isValid =
    formData.name &&
    formData.categoryId &&
    formData.price &&
    parseFloat(formData.price) >= 0;

  function handleSubmit() {
    if (isValid)
      save({ variables: formData }).then(() => {
        toast({
          title: "Excelent!",
          description: `Menu item "${formData.name}" saved.`,
          type: "success"
        });
        history.push("/config");
      });
  }

  return (
    <Segment>
      <Form onSubmit={handleSubmit} loading={loading}>
        <Form.Input
          label="Name"
          name="name"
          value={formData.name}
          onChange={handleChange}
          required
          autoFocus
        />
        <Form.Input
          label="Description"
          name="description"
          value={formData.description || ""}
          onChange={handleChange}
        />
        <Form.Field>
          <CategoryDropdown
            value={formData.categoryId}
            onChange={handleChange}
          />
        </Form.Field>
        <Form.Input
          label="Price"
          name="price"
          value={formData.price}
          onChange={handleChange}
          required
          type="number"
          step="0.01"
        />
        <Form.Field>
          <Form.Checkbox
            label="Is drink?"
            toggle
            checked={formData.isDrink}
            name="isDrink"
            onChange={(e, { name, checked }) =>
              handleChange(e, { name, value: checked })
            }
          />
        </Form.Field>

        <Button
          primary
          content={isNewRecord ? "Create" : "Update"}
          disabled={!isValid}
        />
        <Button content="Cancel" as={Link} to="/config" />
      </Form>
    </Segment>
  );
}

export function NewMenuItemForm() {
  const item = {
    name: "",
    price: "0.0",
    isDrink: false
  };
  return <MenuItemForm item={item} />;
}

const MENU_ITEM_QUERY = gql`
  query GetMenuItem($id: ID!) {
    menuItem(id: $id) {
      id
      name
      description
      price
      isDrink
      categoryId
    }
  }
`;

export function EditMenuItemForm() {
  const { id } = useParams();
  const result = useQuery<{ menuItem: MenuItemInput }>(MENU_ITEM_QUERY, {
    variables: { id: id }
  });
  return (
    <QueryResultWrapper
      result={result}
      render={data => <MenuItemForm item={data.menuItem} />}
    />
  );
}
