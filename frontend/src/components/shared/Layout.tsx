import React from "react";
import { NavLink } from "react-router-dom";
import { Divider, Icon, Menu } from "semantic-ui-react";
import { useAuth } from "../AuthProvider";
import styles from "./Layout.module.css";

type Props = {
  header: string;
  children: React.ReactNode;
};

function Layout({ header, children }: Props) {
  return (
    <div className={styles.layout}>
      <UserHeader />
      <div className={styles.header}>{header}</div>
      <Sidebar />
      <div className={styles.content}>{children}</div>
    </div>
  );
}

function UserHeader() {
  const { user } = useAuth();

  return (
    <div className={styles.user}>
      <Icon name="user circle" size="big" />
      {user?.name}
    </div>
  );
}

function Sidebar() {
  const { can, logout } = useAuth();

  return (
    <div className={styles.sidebar}>
      <Menu secondary vertical fluid className={styles.menu}>
        <Menu.Item content="Home" icon="home" as={NavLink} to="/" exact />
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
