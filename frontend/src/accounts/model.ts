export type Role = "ADMIN" | "CHEF" | "WAITSTAFF" | "CASHIER" | "CUSTOMER";

export type Permission =
  | "calculate_stats"
  | "place_order"
  | "list_orders"
  | "get_kitchen_orders"
  | "get_waitstaff_orders"
  | "get_activity_feed"
  | "list_users";

export type User = {
  id: string;
  email: string;
  name: string;
  role: Role;
  permissions: Permission[];
};
