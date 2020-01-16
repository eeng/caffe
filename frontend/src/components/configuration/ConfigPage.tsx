import React from "react";
import { NavLink, useLocation } from "react-router-dom";
import { Container, Menu, Tab } from "semantic-ui-react";
import Page from "../shared/Page";
import MenuSection from "./MenuSection";
import UsersSection from "./UsersSection";

function ConfigPage() {
  const location = useLocation();
  const activeTabIndex = location.pathname == "/config/users" ? 1 : 0;

  return (
    <Page title="Configuration">
      <Tab
        menu={{ secondary: true, pointing: true }}
        activeIndex={activeTabIndex}
        panes={[
          {
            menuItem: (
              <Menu.Item
                name="Menu"
                as={NavLink}
                to="/config"
                key="menu"
                exact
              />
            ),
            render: () => <MenuSection />
          },
          {
            menuItem: (
              <Menu.Item
                name="Users"
                as={NavLink}
                to="/config/users"
                key="users"
              />
            ),
            render: () => <UsersSection />
          }
        ]}
      />
    </Page>
  );
}

export default ConfigPage;
