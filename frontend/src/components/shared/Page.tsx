import React from "react";
import { NavLink } from "react-router-dom";
import { Divider, Icon, Menu } from "semantic-ui-react";
import { useAuth } from "../AuthProvider";
import "./Page.less";
import classNames from "classnames/bind";

type Props = {
  title: string;
  actions?: React.ReactNode[];
  children: React.ReactNode;
  className?: string;
};

function Page({ title, actions, className, children }: Props) {
  return (
    <div className={classNames("Page", className)}>
      <UserHeader />
      <PageHeader title={title} actions={actions} />
      <Sidebar />
      <div className="PageContent">{children}</div>
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

const PageHeader = ({ title, actions }: Pick<Props, "title" | "actions">) => (
  <div className="PageHeader">
    <div className="PageTitle">{title}</div>
    {actions?.map((action, i) => (
      <div key={i}>{action}</div>
    ))}
  </div>
);

function Sidebar() {
  const { can, logout } = useAuth();

  return (
    <div className="Sidebar">
      <Menu secondary vertical fluid>
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

export default Page;
