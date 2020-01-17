import { GraphQLError } from "graphql";
import React from "react";
import { factory, fire, render } from "/__test__/testHelper";
import AuthProvider, { LOGIN_MUTATION } from "./AuthProvider";
import LoginPage from "./LoginPage";

test("invalid credentials", async () => {
  const mockMutation = factory
    .mockQuery(LOGIN_MUTATION, {
      variables: { email: "wrong@acme.com", password: "secret" }
    })
    .returnsError(new GraphQLError("invalid_credentials"));

  const r = render(
    <AuthProvider>
      <LoginPage />
    </AuthProvider>,
    { mocks: [mockMutation] }
  );
  await r.findByText("Sign In");

  fire.fill(r.getByPlaceholderText("E-mail address"), "wrong@acme.com");
  fire.fill(r.getByPlaceholderText("Password"), "secret");
  fire.click(r.getByText("Login"));

  await r.findByText(/Invalid email or password/);
  expect(r.getByText("Sign In")).toBeInTheDocument();
});

test.skip("network errors", async () => {
  const mockMutation = factory
    .mockQuery(LOGIN_MUTATION, {
      variables: { email: "bob@acme.com", password: "secret" }
    })
    .returnsNetworkError(new Error("Network error"));

  const r = render(
    <AuthProvider>
      <LoginPage />
    </AuthProvider>,
    { mocks: [mockMutation] }
  );
  await r.findByText("Sign In");

  fire.fill(r.getByPlaceholderText("E-mail address"), "bob@acme.com");
  fire.fill(r.getByPlaceholderText("Password"), "secret");
  fire.click(r.getByText("Login"));

  await r.findByText(/Network error/);
  expect(r.getByText("Sign In")).toBeInTheDocument();
});
