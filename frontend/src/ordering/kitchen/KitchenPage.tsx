import { gql, useQuery } from "@apollo/client";
import Fuse from "fuse.js";
import React, { useState } from "react";
import { Header, Segment } from "semantic-ui-react";
import { OrderDetails } from "../model";
import PreparingLabel from "../waitstaff/PreparingLabel";
import BeginPreparationButton from "./BeginPreparationButton";
import "./KitchenPage.less";
import MarkAsPreparedButton from "./MarkAsPreparedButton";
import Page from "/shared/Page";
import QueryResultWrapper from "/shared/QueryResultWrapper";
import Result from "/shared/Result";
import SearchInput from "/shared/SearchInput";

export const KITCHEN_ORDERS_QUERY = gql`
  query KitchenOrders {
    kitchenOrders {
      id
      code
      items {
        menuItemId
        menuItemName
        quantity
        state
      }
    }
  }
`;

function KitchenPage() {
  const result = useQuery<{ kitchenOrders: OrderDetails[] }>(
    KITCHEN_ORDERS_QUERY,
    { pollInterval: 10000 }
  );

  return (
    <Page title="Kitchen" className="KitchenPage">
      <QueryResultWrapper
        result={result}
        render={data =>
          data.kitchenOrders.length ? (
            <KitchenOrders orders={data.kitchenOrders} />
          ) : (
            <Result
              icon="ban"
              header="Nothing to Cook"
              subheader="When an order containing food is placed, it should appear in this page in order to be prepared by the chef."
            />
          )
        }
      />
    </Page>
  );
}

function KitchenOrders({ orders }: { orders: OrderDetails[] }) {
  const [search, setSearch] = useState("");

  const filteredOrders = search
    ? new Fuse(orders, { keys: ["code"], threshold: 0.1 }).search(search)
    : orders;

  return (
    <>
      <div className="filters">
        <SearchInput
          search={search}
          onSearch={setSearch}
          autoFocus
          placeholder="Search by order code"
        />
      </div>

      <div className="orders">
        {filteredOrders.map(order => (
          <KitchenOrder order={order} key={order.id} />
        ))}
      </div>
    </>
  );
}

function KitchenOrder({ order }: { order: OrderDetails }) {
  return (
    <div className="order">
      <Header attached="top" inverted size="small">
        Order {order.code}
      </Header>
      <Segment attached="bottom" className="items">
        {order.items.map(item => (
          <div key={item.menuItemId} className="menu-item">
            <div className="description">
              <div className="quantity">{item.quantity} x</div>
              <div className="name">{item.menuItemName}</div>
            </div>

            <div className="labels">
              <PreparingLabel item={item} />
            </div>

            <div className="actions">
              <BeginPreparationButton item={item} order={order} />
              <MarkAsPreparedButton item={item} order={order} />
            </div>
          </div>
        ))}
      </Segment>
    </div>
  );
}

export default KitchenPage;
