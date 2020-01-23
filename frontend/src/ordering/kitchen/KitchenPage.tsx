import { gql, useQuery } from "@apollo/client";
import React from "react";
import { Header, Icon, Label, Segment } from "semantic-ui-react";
import { OrderDetails } from "../model";
import BeginPreparationButton from "./BeginPreparationButton";
import "./KitchenPage.less";
import MarkAsPreparedButton from "./MarkAsPreparedButton";
import Page from "/shared/Page";
import QueryResultWrapper from "/shared/QueryResultWrapper";
import Result from "/shared/Result";
import PreparingLabel from "../waitstaff/PreparingLabel";

const KITCHEN_ORDERS_QUERY = gql`
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
            <div className="orders">
              {data.kitchenOrders.map(order => (
                <KitchenOrder order={order} key={order.id} />
              ))}
            </div>
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
