import React, { useContext, useReducer, useEffect, useState } from "react";
import { Action, NEW_ORDER, reducer } from "./model";
import { Order } from "../model";

export type CurrentOrderContextType = {
  order: Order;
  dispatch: React.Dispatch<Action>;
};

const CurrentOrderContext = React.createContext<CurrentOrderContextType>({
  order: NEW_ORDER,
  dispatch: () => null
});

const STORED_ORDER_NAME = "currentOrder";

function saveCurrentOrder(order: Order) {
  sessionStorage.setItem(STORED_ORDER_NAME, JSON.stringify(order));
}

function loadCurrentOrder(dispatch: React.Dispatch<Action>) {
  try {
    const storedOrder = JSON.parse(
      sessionStorage.getItem(STORED_ORDER_NAME) || ""
    );
    dispatch({ type: "RESTORE_ORDER", order: storedOrder });
  } catch (_) {}
}

// Persist the order to the storage on each change and restores it on mount,
// so the state is not lost on page refresh or when navigating outside pages below this context.
function usePersistentOrderState(
  order: Order,
  dispatch: React.Dispatch<Action>
) {
  const [stateRestored, setStateRestored] = useState(false);

  useEffect(() => {
    loadCurrentOrder(dispatch);
    setStateRestored(true);
  }, []);

  useEffect(() => {
    if (stateRestored) saveCurrentOrder(order);
  }, [order]);
}

function CurrentOrderProvider({ children }: { children: React.ReactNode }) {
  const [order, dispatch] = useReducer(reducer, NEW_ORDER);

  usePersistentOrderState(order, dispatch);

  return (
    <CurrentOrderContext.Provider value={{ order, dispatch }}>
      {children}
    </CurrentOrderContext.Provider>
  );
}

export default CurrentOrderProvider;

export const useCurrentOrder = () => useContext(CurrentOrderContext);
