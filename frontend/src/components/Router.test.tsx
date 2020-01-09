import React from "react";
import Router from "./Router";
import { render, factory } from "testHelper";
import AuthProvider, { ME_QUERY } from "./AuthProvider";

test("renders the login page if the user not authenticated", async () => {
  const mockQuery = factory
    .mockQuery(ME_QUERY)
    .returnsError(new Error("unauthorized"));

  const { findByText } = render(
    <AuthProvider>
      <Router />
    </AuthProvider>,
    { mocks: [mockQuery] }
  );
  await findByText("Sign In");
});

test("renders the home page if the user is authenticated", async () => {
  const mockQuery = factory.mockQuery(ME_QUERY).returnsData({
    me: factory.user({ name: "Max Payne" })
  });

  const { findByText } = render(
    <AuthProvider>
      <Router />
    </AuthProvider>,
    { mocks: [mockQuery] }
  );
  await findByText("Max Payne");
});
