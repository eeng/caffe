import React from "react";
import { Route, Switch } from "react-router-dom";
import CurrentOrderProvider from "./CurrentOrderProvider";
import PlaceOrderForm from "./PlaceOrderForm";
import PlaceOrderSummary from "./PlaceOrderSummary";

function PlaceOrderPage() {
  return (
    <CurrentOrderProvider>
      <Switch>
        <Route path="/place_order" exact>
          <PlaceOrderForm />
        </Route>
        <Route path="/place_order/summary" exact>
          <PlaceOrderSummary />
        </Route>
      </Switch>
    </CurrentOrderProvider>
  );
}

export default PlaceOrderPage;
