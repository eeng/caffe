import { fireEvent } from "@testing-library/react";

function fill(element: Document | Element | Window, text: string) {
  fireEvent.change(element, {
    target: { value: text }
  });
}

const fire = { ...fireEvent, fill };

export default fire;
