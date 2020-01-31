import React from "react";
import {
  factory,
  fire,
  render,
  waitForElementToBeRemoved
} from "/__test__/testHelper";
import MenuSection, {
  DELETE_MENU_ITEM_MUTATION,
  MENU_ITEMS_QUERY
} from "./MenuSection";

test("allows to search menu items", async () => {
  const mockQuery = factory.mockQuery(MENU_ITEMS_QUERY).returnsData({
    menuItems: [
      factory.menuItem({ name: "Burger", category: { name: "Food" } }),
      factory.menuItem({ name: "Fish", category: { name: "Food" } })
    ]
  });

  const r = render(<MenuSection />, { mocks: [mockQuery] });

  expect(await r.findAllByText(/Food/)).toHaveLength(2);
  expect(r.getByText("Burger")).toBeInTheDocument();
  expect(r.getByText("Fish")).toBeInTheDocument();

  fire.fill(r.getByPlaceholderText("Search"), "burg");
  expect(r.queryAllByText(/Food/)).toHaveLength(1);

  fire.click(r.getByTitle("Clear Search"));
  expect(r.queryAllByText(/Food/)).toHaveLength(2);
});

test("when there is no menu items", async () => {
  const mockQuery = factory.mockQuery(MENU_ITEMS_QUERY).returnsData({
    menuItems: []
  });
  const { findByText } = render(<MenuSection />, { mocks: [mockQuery] });
  await findByText(/No menu items were found/);
});

test("deleting a menu item", async () => {
  const burger = factory.menuItem({ name: "Burger" });
  const fish = factory.menuItem({ name: "Fish" });

  const mockQueryBefore = factory.mockQuery(MENU_ITEMS_QUERY).returnsData({
    menuItems: [burger, fish]
  });
  const mockMutation = factory
    .mockQuery(DELETE_MENU_ITEM_MUTATION, { variables: { id: burger.id } })
    .returnsData({ deleteMenuItem: { id: burger.id } });
  const mockQueryAfter = factory.mockQuery(MENU_ITEMS_QUERY).returnsData({
    menuItems: [fish]
  });

  const r = render(<MenuSection />, {
    mocks: [mockQueryBefore, mockMutation, mockQueryAfter]
  });
  await r.findByText("Burger");

  fire.click(r.getAllByTitle("Delete")[0]);
  fire.click(r.getByText("Confirm"));
  await waitForElementToBeRemoved(() => r.queryByText("Burger"));
});
