import React, { Fragment } from "react";
import { Route, Switch, Redirect } from "react-router-dom";
import { SemanticToastContainer } from "react-semantic-toasts";
import "react-semantic-toasts/styles/react-semantic-alert.css";
import ConfigPage from "../configuration/ConfigPage";
import LoginPage from "../accounts/LoginPage";
import PlaceOrderPage from "../ordering/PlaceOrderPage";
import NotFoundPage from "./NotFoundPage";
import PrivateRoute from "./PrivateRoute";
import OrderDetailsPage from "../ordering/OrderDetailsPage";
import OrdersPage from "../ordering/OrdersPage";
import { useAuth, Role } from "/accounts/AuthProvider";
import DashboardPage from "/reports/DashboardPage";

const Routes = () => (
  <Fragment>
    <Switch>
      <PrivateRoute exact path="/">
        <HomePageSelector />
      </PrivateRoute>
      <PrivateRoute path="/dashboard" permission="list_users">
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
  const { user } = useAuth();
  const homePage = user?.role == Role.Customer ? "/place_order" : "/dashboard";

  return <Redirect to={homePage} />;
}

export default Routes;
