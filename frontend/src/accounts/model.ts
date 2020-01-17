export enum Role {
  Customer = "CUSTOMER",
  Chef = "CHEF",
  Waitstaff = "WAITSTAFF",
  Cashier = "CASHIER",
  Admin = "ADMIN"
}

export type User = {
  id: string;
  email: string;
  name: string;
  role: Role;
  permissions: string[];
};
