export interface OrderItem {
  quantity: number;
  menuItemId: string;
  menuItemName: string;
  price: number;
  state?: "pending" | "preparing" | "prepared" | "served";
  viewerCanServe?: boolean;
}

export interface Order {
  items: OrderItem[];
  notes: string;
}

export interface OrderDetails extends Order {
  id: string;
  orderAmount: number;
  state: "pending" | "cancelled" | "served" | "paid";
  orderDate: string;
  code: string;
  viewerCanCancel?: boolean;
}

export const isOrderEmpty = (order: Order) => order.items.length == 0;

export const orderTotalQty = (order: Order) =>
  order.items.reduce((total, item) => total + item.quantity, 0);

export const orderTotalAmount = (order: Order) =>
  order.items.reduce((total, item) => total + item.quantity * item.price, 0);
