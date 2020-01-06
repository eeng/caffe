import React from "react";
import AppBar from "../AppBar";
import { Tab, Container, Menu } from "semantic-ui-react";
import MenuSection from "./MenuSection";
import UsersSection from "./UsersSection";
import { Link, useLocation, NavLink } from "react-router-dom";
import Layout from "../shared/Layout";

function ConfigPage() {
  const location = useLocation();
  const activeTabIndex = location.pathname == "/config/users" ? 1 : 0;

  return (
    <Layout header="Configuration">
      <Container>
        <Tab
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
              render: () => <Tab.Pane content={<MenuSection />} />
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
              render: () => <Tab.Pane content={<UsersSection />} />
            }
          ]}
        />
      </Container>
    </Layout>
  );
}

export default ConfigPage;
