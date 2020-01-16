import { reducer } from "./model";
import { factory } from "/__test__/testHelper";

describe("reducer", () => {
  test("ADD_ITEM action", () => {
    const fish = factory.menuItem({ name: "Fish" });
    const beer = factory.menuItem({ name: "Beer" });
    let order = factory.order({ items: [] });

    order = reducer(order, { type: "ADD_ITEM", menuItem: fish, quantity: 1 });
    expect(order.items).toEqual([
      expect.objectContaining({ menuItemId: fish.id, quantity: 1 })
    ]);

    order = reducer(order, { type: "ADD_ITEM", menuItem: fish, quantity: 2 });
    expect(order.items).toEqual([
      expect.objectContaining({ menuItemId: fish.id, quantity: 3 })
    ]);

    order = reducer(order, { type: "ADD_ITEM", menuItem: beer, quantity: 1 });
    expect(order.items).toEqual([
      expect.objectContaining({ menuItemId: fish.id, quantity: 3 }),
      expect.objectContaining({ menuItemId: beer.id, quantity: 1 })
    ]);
  });

  test("REMOVE_ITEM action", () => {
    const fish = factory.menuItem({ name: "Fish" });
    let order = factory.order({
      items: [factory.item({ menuItemId: fish.id })]
    });

    order = reducer(order, { type: "REMOVE_ITEM", menuItemId: fish.id });
    expect(order.items).toEqual([]);
  });

  test("INCREMENT_QTY and DECREMENT_QTY actions", () => {
    const fish = factory.menuItem({ name: "Fish" });
    let order = factory.order({
      items: [factory.item({ menuItemId: fish.id, quantity: 1 })]
    });

    order = reducer(order, { type: "INCREMENT_QTY", menuItemId: fish.id });
    expect(order.items).toEqual([
      expect.objectContaining({ menuItemId: fish.id, quantity: 2 })
    ]);

    order = reducer(order, { type: "DECREMENT_QTY", menuItemId: fish.id });
    expect(order.items).toEqual([
      expect.objectContaining({ menuItemId: fish.id, quantity: 1 })
    ]);

    order = reducer(order, { type: "DECREMENT_QTY", menuItemId: fish.id });
    expect(order.items).toEqual([
      expect.objectContaining({ menuItemId: fish.id, quantity: 1 })
    ]);
  });
});
