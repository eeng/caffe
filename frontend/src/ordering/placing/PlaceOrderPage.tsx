import React from "react";
import { Route, Switch } from "react-router-dom";
import CurrentOrderProvider from "./CurrentOrderProvider";
import PlaceOrderForm from "./PlaceOrderForm";
import PlaceOrderSummary from "./PlaceOrderSummary";
import PlaceOrderSuccess from "./PlaceOrderSuccess";

function PlaceOrderPage() {
  return (
    <CurrentOrderProvider>
      <Switch>
        <Route path="/place_order" exact>
          <PlaceOrderForm />
        </Route>
        <Route path="/place_order/summary">
          <PlaceOrderSummary />
        </Route>
        <Route path="/place_order/success">
          <PlaceOrderSuccess />
        </Route>
      </Switch>
    </CurrentOrderProvider>
  );
}

export default PlaceOrderPage;
