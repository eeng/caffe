import React, { Fragment } from "react";
import { Route, Switch } from "react-router-dom";
import { SemanticToastContainer } from "react-semantic-toasts";
import "react-semantic-toasts/styles/react-semantic-alert.css";
import LoginPage from "../accounts/LoginPage";
import ConfigPage from "../configuration/ConfigPage";
import ActivityFeedPage from "../ordering/activities/ActivityFeedPage";
import OrderDetailsPage from "../ordering/OrderDetailsPage";
import OrdersPage from "../ordering/OrdersPage";
import PlaceOrderPage from "../ordering/placing/PlaceOrderPage";
import HomePageSelector from "./HomePageSelector";
import NotFoundPage from "./NotFoundPage";
import PrivateRoute from "./PrivateRoute";
import KitchenPage from "/ordering/kitchen/KitchenPage";
import DashboardPage from "/reports/DashboardPage";
import WaitstaffPage from "/ordering/waitstaff/WaitstaffPage";

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
      <PrivateRoute path="/kitchen">
        <KitchenPage />
      </PrivateRoute>
      <PrivateRoute path="/waitstaff">
        <WaitstaffPage />
      </PrivateRoute>
      <PrivateRoute path="/activity_feed" permission="get_activity_feed">
        <ActivityFeedPage />
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

export default Routes;
