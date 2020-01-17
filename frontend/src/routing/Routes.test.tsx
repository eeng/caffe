import React from "react";
import { MemoryRouter } from "react-router-dom";
import { factory, render } from "/__test__/testHelper";
import AuthProvider, { ME_QUERY, AUTH_TOKEN } from "../accounts/AuthProvider";
import Routes from "./Routes";

test("renders the login page if the user not authenticated", async () => {
  const mockQuery = factory
    .mockQuery(ME_QUERY)
    .returnsError(new Error("unauthorized"));

  const { findByText } = render(
    <AuthProvider>
      <Routes />
    </AuthProvider>,
    { mocks: [mockQuery] }
  );
  await findByText("Sign In");
});

test("renders the home page if the user is authenticated", async () => {
  localStorage.setItem(AUTH_TOKEN, "...");

  const mockQuery = factory.mockQuery(ME_QUERY).returnsData({
    me: factory.user({ name: "Max Payne" })
  });

  const { findByText } = render(
    <AuthProvider>
      <Routes />
    </AuthProvider>,
    { mocks: [mockQuery] }
  );
  await findByText("Max Payne");
});

test("renders a 404 page on a bad url", async () => {
  const { findByText } = render(
    <MemoryRouter initialEntries={["/non-existent"]}>
      <Routes />
    </MemoryRouter>
  );
  await findByText(/Looks like the page you're looking for has been removed/);
});
