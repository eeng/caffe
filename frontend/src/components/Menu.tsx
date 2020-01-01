import React from "react";
import { gql } from "apollo-boost";
import { useQuery } from "@apollo/react-hooks";

type MenuItem = {
  id: string;
  name: string;
  price: number;
};

type QueryResult = {
  menuItems: MenuItem[];
};

const MENU_ITEMS_QUERY = gql`
  {
    menuItems {
      id
      name
      price
    }
  }
`;

function Menu() {
  const { loading, error, data } = useQuery<QueryResult>(MENU_ITEMS_QUERY);

  return (
    <div>
      {loading && "Loading"}
      {error?.message}
      {data?.menuItems.map(item => (
        <MenuItemCard item={item} key={item.id} />
      ))}
    </div>
  );
}

type MenuItemCardProps = {
  item: MenuItem;
};

function MenuItemCard({ item }: MenuItemCardProps) {
  return (
    <div>
      {item.name} ($ {item.price})
    </div>
  );
}

export default Menu;
