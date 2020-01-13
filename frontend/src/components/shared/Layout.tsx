import React from "react";
import { NavLink } from "react-router-dom";
import { Divider, Icon, Menu } from "semantic-ui-react";
import { useAuth } from "../AuthProvider";
import "./Layout.less";

type Props = {
  header: string;
  children: React.ReactNode;
};

function Layout({ header, children }: Props) {
  return (
    <div className="Layout">
      <UserHeader />
      <div className="PageHeader">{header}</div>
      <Sidebar />
      <div className="LayoutContent"> {children}</div>
    </div>
  );
}

function UserHeader() {
  const { user } = useAuth();

  return (
    <div className="UserHeader">
      <Icon name="user circle" size="big" />
      {user?.name}
    </div>
  );
}

function Sidebar() {
  const { can, logout } = useAuth();

  return (
    <div className="Sidebar">
      <Menu secondary vertical fluid>
        <Menu.Item content="Home" icon="home" as={NavLink} to="/" exact />
        {can("place_order") && (
          <Menu.Item
            content="Place Order"
            icon="cart"
            as={NavLink}
            to="/place_order"
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

export default Layout;
