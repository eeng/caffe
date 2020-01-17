import classNames from "classnames/bind";
import React from "react";
import { Icon } from "semantic-ui-react";
import { useAuth } from "../accounts/AuthProvider";
import "./Page.less";
import { Sidebar } from "./Sidebar";

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

const PageHeader = ({
  title,
  actions = []
}: Pick<Props, "title" | "actions">) => (
  <div className="PageHeader">
    <div className="PageTitle">{title}</div>
    {actions.map((action, i) => (
      <div key={i}>{action}</div>
    ))}
  </div>
);

export default Page;
