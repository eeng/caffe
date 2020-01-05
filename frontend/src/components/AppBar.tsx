import React, { Fragment } from "react";
import { useAuth } from "./AuthProvider";
import { Menu, Icon, Visibility } from "semantic-ui-react";
import { Link } from "react-router-dom";

interface Props {
  title: string;
}

function AppBar({ title }: Props) {
  const { logout, user, can } = useAuth();

  return (
    <Fragment>
      <Menu fixed="top" inverted>
        <Menu.Item as={Link} to="/" icon="bars" />
        <Menu.Item name={title} />
        <Menu.Item icon="user" position="right" content={user?.name} />
        {can("list_users") && <Menu.Item as={Link} to="/config" icon="cog" />}
        <Menu.Item onClick={logout} icon="log out" />
      </Menu>
      <div style={{ height: "60px" }} />
    </Fragment>
  );
}

export default AppBar;
