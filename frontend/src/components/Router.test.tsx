import React from "react";
import Router from "./Router";
import { render } from "./TestUtils";

it("renders the login page if the user not authenticated", async () => {
  const { findByText } = render(<Router />, {});
  await findByText("Sign In");
});

it("renders the home page if the user is authenticated", async () => {
  const { findByText } = render(<Router />, { user: { name: "Max Payne" } });
  await findByText("Max Payne");
});
