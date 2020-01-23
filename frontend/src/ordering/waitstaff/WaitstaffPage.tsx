import { gql, useQuery } from "@apollo/client";
import React from "react";
import { Header, Label, Message, Segment } from "semantic-ui-react";
import { OrderDetails, OrderItem } from "../model";
import MarkAsServedButton from "./MarkAsPreparedButton";
import PayOrderButton from "./PayOrderButton";
import PreparingLabel from "./PreparingLabel";
import "./WaitstaffPage.less";
import { formatCurrency } from "/lib/format";
import Page from "/shared/Page";
import QueryResultWrapper from "/shared/QueryResultWrapper";
import Result from "/shared/Result";

const WAITSTAFF_ORDERS_QUERY = gql`
  query WaitstaffOrders {
    waitstaffOrders {
      id
      code
      orderAmount
      state
      items {
        menuItemId
        menuItemName
        quantity
        price
        state
        viewerCanServe
      }
    }
  }
`;

function WaitstaffPage() {
  const result = useQuery<{ waitstaffOrders: OrderDetails[] }>(
    WAITSTAFF_ORDERS_QUERY,
    { pollInterval: 10000 }
  );

  return (
    <Page title="Waitstaff" className="WaitstaffPage">
      <QueryResultWrapper
        result={result}
        render={data =>
          data.waitstaffOrders.length ? (
            <div className="orders">
              {data.waitstaffOrders.map(order => (
                <WaitstaffOrder order={order} key={order.id} />
              ))}
            </div>
          ) : (
            <Result
              icon="ban"
              header="Nothing to Serve"
              subheader="When orders are placed, they should appear in this page so the waitstaff can served them."
            />
          )
        }
      />
    </Page>
  );
}

function WaitstaffOrder({ order }: { order: OrderDetails }) {
  const isOrderServed = order.state == "served";

  return (
    <div className="order">
      <Header attached="top" inverted size="small">
        Order {order.code}
      </Header>

      <Segment attached className="items">
        {order.items.map(item => (
          <div key={item.menuItemId} className="menu-item">
            <div className="description">
              <div className="quantity">{item.quantity} x</div>
              <div className="name">{item.menuItemName}</div>
              <div className="price">{formatCurrency(item.price)}</div>
            </div>

            <div className="labels">
              <PreparingLabel item={item} />
              <RequiresPreparationLabel item={item} />
              <ServedLabel item={item} />
            </div>

            <div className="actions">
              <MarkAsServedButton item={item} order={order} />
            </div>
          </div>
        ))}
      </Segment>

      <Message attached="bottom" error={isOrderServed}>
        {isOrderServed && <Message.Header>Awaiting Payment</Message.Header>}
        <p>
          Total Amount:{" "}
          <span className="total">{formatCurrency(order.orderAmount)}</span>
          <PayOrderButton
            order={order}
            floated="right"
            refetchQueries={["WaitstaffOrders"]}
          />
        </p>
      </Message>
    </div>
  );
}

const RequiresPreparationLabel = ({ item }: { item: OrderItem }) =>
  item.state == "pending" && !item.viewerCanServe ? (
    <Label content="Requires Preparation" />
  ) : null;

const ServedLabel = ({ item }: { item: OrderItem }) =>
  item.state == "served" ? (
    <Label content="Served" color="green" icon="check" />
  ) : null;

export default WaitstaffPage;
