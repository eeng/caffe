import { useAuth } from "/accounts/AuthProvider";
import React from "react";
import { Menu, Divider } from "semantic-ui-react";
import { NavLink } from "react-router-dom";

export function Sidebar() {
  const { can, logout } = useAuth();

  return (
    <div className="Sidebar">
      <Menu secondary vertical fluid>
        {can("calculate_stats") && (
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
            icon="cart"
            as={NavLink}
            to="/place_order"
          />
        )}
        {can("list_orders") && (
          <Menu.Item
            content="Orders"
            icon="list alternate"
            as={NavLink}
            to="/orders"
          />
        )}
        {can("get_kitchen_orders") && (
          <Menu.Item content="Kitchen" icon="food" as={NavLink} to="/kitchen" />
        )}
        {can("get_waitstaff_orders") && (
          <Menu.Item
            content="Waitstaff"
            icon="coffee"
            as={NavLink}
            to="/waitstaff"
          />
        )}
        {can("get_activity_feed") && (
          <Menu.Item
            content="Activity Feed"
            icon="book"
            as={NavLink}
            to="/activity_feed"
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
