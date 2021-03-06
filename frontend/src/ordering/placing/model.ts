import { MenuItem } from "/configuration/model";
import { OrderItem, Order } from "../model";

interface AddItem {
  type: "ADD_ITEM";
  menuItem: MenuItem;
  quantity: number;
}

interface RemoveItem {
  type: "REMOVE_ITEM";
  menuItemId: string;
}

interface IncrementQty {
  type: "INCREMENT_QTY";
  menuItemId: string;
}

interface DecrementQty {
  type: "DECREMENT_QTY";
  menuItemId: string;
}

interface FieldChange {
  type: "FIELD_CHANGE";
  field: string;
  value: any;
}

interface ResetOrder {
  type: "RESET_ORDER";
}

interface RestoreOrder {
  type: "RESTORE_ORDER";
  order: Order;
}

export type Action =
  | AddItem
  | RemoveItem
  | IncrementQty
  | DecrementQty
  | FieldChange
  | ResetOrder
  | RestoreOrder;

function changeQty(items: OrderItem[], menuItemId: string, by: number) {
  return items.map(item =>
    item.menuItemId == menuItemId
      ? { ...item, quantity: Math.max(item.quantity + by, 1) }
      : item
  );
}

function addItemOrIncrementQty(
  items: OrderItem[],
  action: AddItem
): OrderItem[] {
  if (items.some(item => item.menuItemId == action.menuItem.id))
    return changeQty(items, action.menuItem.id, action.quantity);
  else
    return [
      ...items,
      {
        menuItemId: action.menuItem.id,
        menuItemName: action.menuItem.name,
        price: action.menuItem.price,
        quantity: action.quantity
      }
    ];
}

export const NEW_ORDER: Order = { items: [], notes: "" };

export function reducer(order: Order, action: Action): Order {
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
    case "INCREMENT_QTY":
      return {
        ...order,
        items: changeQty(order.items, action.menuItemId, 1)
      };
    case "DECREMENT_QTY":
      return {
        ...order,
        items: changeQty(order.items, action.menuItemId, -1)
      };
    case "FIELD_CHANGE":
      return {
        ...order,
        [action.field]: action.value
      };
    case "RESET_ORDER":
      return NEW_ORDER;
    case "RESTORE_ORDER":
      return action.order;
  }
}
