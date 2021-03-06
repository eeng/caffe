import { MockedProvider, MockedResponse } from "@apollo/client/testing";
import "@testing-library/jest-dom/extend-expect";
import { render } from "@testing-library/react";
import React from "react";
import { MemoryRouter } from "react-router-dom";
import { SemanticToastContainer } from "react-semantic-toasts";
import * as factory from "./factory";
import fire from "./events";

interface RenderOptions {
  mocks?: MockedResponse[];
}

const customRender = (
  ui: React.ReactElement,
  { mocks = [] }: RenderOptions = {}
) =>
  render(
    <MockedProvider mocks={mocks} addTypename={false}>
      <MemoryRouter>
        {ui}
        <SemanticToastContainer />
      </MemoryRouter>
    </MockedProvider>
  );

// re-export everything from @testing-library/react
export * from "@testing-library/react";
// override render method
export { customRender as render, factory, fire };
