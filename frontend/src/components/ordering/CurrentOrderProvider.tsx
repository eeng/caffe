import React, { useContext, useReducer } from "react";
import { Action, NEW_ORDER, Order, reducer } from "./model";

export type CurrentOrderContextType = {
  order: Order;
  dispatch: React.Dispatch<Action>;
};

const CurrentOrderContext = React.createContext<CurrentOrderContextType>({
  order: NEW_ORDER,
  dispatch: () => null
});

function CurrentOrderProvider({ children }: { children: React.ReactNode }) {
  const [order, dispatch] = useReducer(reducer, NEW_ORDER);

  return (
    <CurrentOrderContext.Provider value={{ order, dispatch }}>
      {children}
    </CurrentOrderContext.Provider>
  );
}

export default CurrentOrderProvider;

export const useCurrentOrder = () => useContext(CurrentOrderContext);
