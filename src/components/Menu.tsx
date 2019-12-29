import React, { useEffect, useReducer } from "react";

const fetchMenuItems = async () => {
  return fetch("/api", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      query: "{ menuItems { id name price } }"
    })
  }).then(response => response.json());
};

type MenuItem = {
  id: string;
  name: string;
  price: number;
};

type State = {
  menuItems: MenuItem[];
  loading: boolean;
  error: string;
};

type Action =
  | { type: "FETCH_SUCCESS"; payload: MenuItem[] }
  | { type: "FECTH_ERROR" };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case "FETCH_SUCCESS":
      return { menuItems: action.payload, loading: false, error: "" };
    case "FECTH_ERROR":
      return { menuItems: [], loading: false, error: "Oops" };
  }
}

const Menu: React.FC = () => {
  const [state, dispatch] = useReducer(reducer, {
    menuItems: [],
    loading: true,
    error: ""
  });

  useEffect(() => {
    fetchMenuItems()
      .then(res => {
        if (res.errors) dispatch({ type: "FECTH_ERROR" });
        else dispatch({ type: "FETCH_SUCCESS", payload: res.data.menuItems });
      })
      .catch(_ => dispatch({ type: "FECTH_ERROR" }));
  }, []);

  return (
    <div>
      {state.loading && "Loading"}
      {state.error}
      {state.menuItems.map(item => (
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
