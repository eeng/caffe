import "@testing-library/jest-dom/extend-expect";
import { render, RenderOptions } from "@testing-library/react";
import React from "react";
import AuthProvider, { ME_QUERY } from "../components/AuthProvider";
import { MockedProvider } from "@apollo/client/testing";

interface User {
  name?: string;
  permissions?: string[];
}

const userMock = (user?: User) =>
  user
    ? {
        request: {
          query: ME_QUERY
        },
        result: {
          data: {
            me: {
              id: 1,
              name: "User Name",
              permissions: [],
              email: "user@acme.com",
              ...user
            }
          }
        }
      }
    : {
        request: {
          query: ME_QUERY
        },
        error: new Error("unauthorized")
      };

const generateWrapper = ({ user }: { user?: User }) => ({ children }: any) => {
  return (
    <MockedProvider mocks={[userMock(user)]} addTypename={false}>
      <AuthProvider>{children}</AuthProvider>
    </MockedProvider>
  );
};

const customRender = (
  ui: React.ReactElement,
  { user }: { user?: User },
  options?: Omit<RenderOptions, "queries">
) => render(ui, { wrapper: generateWrapper({ user: user }) });

// re-export everything
export * from "@testing-library/react";
// override render method
export { customRender as render };
