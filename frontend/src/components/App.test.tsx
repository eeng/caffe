import React from "react";
import { render } from "@testing-library/react";
import App from "./App";

test("renders ok", () => {
  const { getByText } = render(<App />);
  const element = getByText(/environment/i);
  expect(element).toBeInTheDocument();
});
