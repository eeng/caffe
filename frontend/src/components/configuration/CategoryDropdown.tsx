import { useQuery } from "@apollo/react-hooks";
import { gql } from "apollo-boost";
import React from "react";
import { Form, FormDropdownProps } from "semantic-ui-react";

type Category = {
  id: string;
  name: string;
};

type CategoriesData = {
  categories: Category[];
};

const CATEGORIES_QUERY = gql`
  {
    categories {
      id
      name
    }
  }
`;

function CategoryDropdown(props: FormDropdownProps) {
  const { data, loading } = useQuery<CategoriesData>(CATEGORIES_QUERY);
  const options = data
    ? data.categories.map(c => ({
        key: c.id,
        value: c.id,
        text: c.name
      }))
    : [];

  return (
    <Form.Dropdown
      name="categoryId"
      label="Category"
      placeholder="Select a category..."
      options={options}
      loading={loading}
      selection
      required
      {...props}
    />
  );
}

export default CategoryDropdown;
