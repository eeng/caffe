import React, { Fragment } from "react";
import AppBar from "../AppBar";
import { Tab, Container, Menu } from "semantic-ui-react";
import MenuSection from "./MenuSection";
import UsersSection from "./UsersSection";
import { Link, useLocation } from "react-router-dom";

function ConfigPage() {
  const location = useLocation();
  const activeTabIndex = location.pathname == "/config/users" ? 1 : 0;

  return (
    <Fragment>
      <AppBar title="Configuration" />
      <Container>
        <Tab
          activeIndex={activeTabIndex}
          panes={[
            {
              menuItem: (
                <Menu.Item
                  name="Menu"
                  as={Link}
                  to="/config"
                  key="menu"
                  active={activeTabIndex == 0}
                />
              ),
              render: () => <MenuSection />
            },
            {
              menuItem: (
                <Menu.Item
                  name="Users"
                  as={Link}
                  to="/config/users"
                  key="users"
                  active={activeTabIndex == 1}
                />
              ),
              render: () => <UsersSection />
            }
          ]}
        />
      </Container>
    </Fragment>
  );
}

export default ConfigPage;
