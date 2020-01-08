import React from "react";
import { render } from "@testing-library/react";
import Router from "./Router";
import "@testing-library/jest-dom/extend-expect";

test("renders the login page if not authenticated", () => {
  const { getByText } = render(<Router />);
  expect(getByText(/Sign In/i)).toBeInTheDocument();
});
