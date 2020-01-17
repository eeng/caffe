import React, { Fragment } from "react";
import { Redirect, Route, Switch } from "react-router-dom";
import { SemanticToastContainer } from "react-semantic-toasts";
import "react-semantic-toasts/styles/react-semantic-alert.css";
import LoginPage from "../accounts/LoginPage";
import ConfigPage from "../configuration/ConfigPage";
import OrderDetailsPage from "../ordering/OrderDetailsPage";
import OrdersPage from "../ordering/OrdersPage";
import PlaceOrderPage from "../ordering/PlaceOrderPage";
import NotFoundPage from "./NotFoundPage";
import PrivateRoute from "./PrivateRoute";
import { useAuth } from "/accounts/AuthProvider";
import DashboardPage from "/reports/DashboardPage";

const Routes = () => (
  <Fragment>
    <Switch>
      <PrivateRoute exact path="/">
        <HomePageSelector />
      </PrivateRoute>
      <PrivateRoute path="/dashboard" permission="get_stats">
        <DashboardPage />
      </PrivateRoute>
      <PrivateRoute path="/place_order">
        <PlaceOrderPage />
      </PrivateRoute>
      <PrivateRoute path="/orders/:id">
        <OrderDetailsPage />
      </PrivateRoute>
      <PrivateRoute path="/orders">
        <OrdersPage />
      </PrivateRoute>
      <PrivateRoute path="/config" permission="list_users">
        <ConfigPage />
      </PrivateRoute>
      <Route path="/login">
        <LoginPage />
      </Route>
      <Route path="*">
        <NotFoundPage />
      </Route>
    </Switch>
    <SemanticToastContainer position="bottom-right" />
  </Fragment>
);

function HomePageSelector() {
  const { can } = useAuth();
  const homePage = can("get_stats") ? "/dashboard" : "/place_order";

  return <Redirect to={homePage} />;
}

export default Routes;
