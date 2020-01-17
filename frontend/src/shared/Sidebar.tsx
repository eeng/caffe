import { useAuth } from "/accounts/AuthProvider";
import React from "react";
import { Menu, Divider } from "semantic-ui-react";
import { NavLink } from "react-router-dom";

export function Sidebar() {
  const { can, logout } = useAuth();

  return (
    <div className="Sidebar">
      <Menu secondary vertical fluid>
        {can("get_stats") && (
          <Menu.Item
            content="Dashboard"
            icon="line graph"
            as={NavLink}
            to="/dashboard"
          />
        )}
        {can("place_order") && (
          <Menu.Item
            content="Place Order"
            icon="food"
            as={NavLink}
            to="/place_order"
          />
        )}
        {can("list_orders") && (
          <Menu.Item
            content="My Orders"
            icon="list alternate"
            as={NavLink}
            to="/orders"
          />
        )}
        {can("list_users") && (
          <Menu.Item
            content="Configuration"
            icon="cog"
            as={NavLink}
            to="/config"
          />
        )}
        <Divider />
        <Menu.Item content="Logout" icon="log out" onClick={logout} />
      </Menu>
    </div>
  );
}
