import React, { useContext, useReducer } from "react";

export interface OrderItem {
  menuItemId: string;
  quantity: number;
}

export interface Order {
  items: OrderItem[];
}

interface AddItem {
  type: "ADD_ITEM";
  menuItemId: string;
  quantity: number;
}

interface RemoveItem {
  type: "REMOVE_ITEM";
  menuItemId: string;
}

export type Action = AddItem | RemoveItem;

function addItemOrIncrementQty(
  items: OrderItem[],
  action: AddItem
): OrderItem[] {
  if (items.some(item => item.menuItemId == action.menuItemId))
    return items.map(item =>
      item.menuItemId == action.menuItemId
        ? { ...item, quantity: item.quantity + action.quantity }
        : item
    );
  else
    return [
      ...items,
      { menuItemId: action.menuItemId, quantity: action.quantity }
    ];
}

function reducer(order: Order, action: Action) {
  switch (action.type) {
    case "ADD_ITEM":
      return {
        ...order,
        items: addItemOrIncrementQty(order.items, action)
      };
    case "REMOVE_ITEM":
      return {
        ...order,
        items: order.items.filter(item => item.menuItemId != action.menuItemId)
      };
  }
}

export type CurrentOrderContextType = {
  order: Order;
  dispatch: React.Dispatch<Action>;
};

const DEFAULT_STATE = { items: [] };

const CurrentOrderContext = React.createContext<CurrentOrderContextType>({
  order: DEFAULT_STATE,
  dispatch: () => null
});

function CurrentOrderProvider({ children }: { children: React.ReactNode }) {
  const [order, dispatch] = useReducer(reducer, DEFAULT_STATE);

  return (
    <CurrentOrderContext.Provider value={{ order, dispatch }}>
      {children}
    </CurrentOrderContext.Provider>
  );
}

export default CurrentOrderProvider;

export const useCurrentOrder = () => useContext(CurrentOrderContext);

export const isOrderEmpty = (order: Order) => order.items.length == 0;
