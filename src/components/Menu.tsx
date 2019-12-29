import React, { useEffect, useState } from "react";

const fetchMenuItems = () => {
  return fetch("/api", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      query: "{ menuItems { id name pric } }"
    })
  }).then(response => response.json());
};

type MenuItem = {
  id: string;
  name: string;
  price: number;
};

const Menu: React.FC = () => {
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);

  useEffect(() => {
    fetchMenuItems().then(result => {
      if (result.errors) console.log(result.errors);
      else setMenuItems(result.data.menuItems);
    });
  }, []);

  return (
    <div>
      {menuItems.map(item => (
        <MenuItemCard item={item} key={item.id} />
      ))}
    </div>
  );
};

type MenuItemCardProps = {
  item: MenuItem;
};

const MenuItemCard: React.FC<MenuItemCardProps> = ({ item }) => {
  return (
    <div>
      {item.name} ($ {item.price})
    </div>
  );
};

export default Menu;
