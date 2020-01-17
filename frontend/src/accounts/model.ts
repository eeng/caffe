type Role = "ADMIN" | "CHEF" | "WAITSTAFF" | "CASHIER" | "CUSTOMER";

export type User = {
  id: string;
  email: string;
  name: string;
  role?: Role;
  permissions: string[];
};
