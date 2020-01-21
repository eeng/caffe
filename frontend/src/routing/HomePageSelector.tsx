import { useAuth } from "/accounts/AuthProvider";
import React from "react";
import { Redirect } from "react-router-dom";
import { Role } from "/accounts/model";

const HOME_ROUTE_BY_ROLE: Record<Role, string> = {
  ADMIN: "/dashboard",
  CHEF: "/kitchen",
  CASHIER: "/dashboard",
  WAITSTAFF: "/waitstaff",
  CUSTOMER: "/place_order"
};

function HomePageSelector() {
  const { user } = useAuth();

  const homePage = HOME_ROUTE_BY_ROLE[user!.role] || "/orders";

  return <Redirect to={homePage} />;
}

export default HomePageSelector;
