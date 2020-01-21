import React from "react";
import Page from "/shared/Page";
import { gql, useQuery } from "@apollo/client";
import QueryResultWrapper from "/shared/QueryResultWrapper";
import { Activity, ActivityType } from "./model";
import { Feed, Segment } from "semantic-ui-react";
import { formatDistanceToNow } from "/lib/format";
import Avatar from "/accounts/Avatar";
import Result from "/shared/Result";
import { Link } from "react-router-dom";

const ACTIVITY_QUERY = gql`
  query {
    activities {
      id
      type
      published
      actor {
        id
        name
      }
      objectType
      objectId
    }
  }
`;

function ActivityFeedPage() {
  const result = useQuery<{ activities: Activity[] }>(ACTIVITY_QUERY, {
    pollInterval: 10000
  });

  return (
    <Page title="Activity Feed">
      <QueryResultWrapper
        result={result}
        render={data =>
          data.activities.length ? (
            <ActivityFeed activities={data.activities} />
          ) : (
            <Result
              icon="ban"
              header="No Activity"
              subheader="When events are fired (like placing an order) they should appear here after a few seconds."
            />
          )
        }
      />
    </Page>
  );
}

function ActivityFeed({ activities }: { activities: Activity[] }) {
  return (
    <Segment>
      <Feed>
        {activities.map(activity => (
          <Feed.Event key={activity.id}>
            <Feed.Label>
              {activity.actor && <Avatar user={activity.actor} />}
            </Feed.Label>
            <Feed.Content>
              <Feed.Summary>
                <Feed.User>{activity.actor?.name || "Guest"}</Feed.User>{" "}
                {HUMAN_ACTIVITY_TYPE[activity.type]}{" "}
                <Link to={`/orders/${activity.objectId}`}>an order</Link>
                <Feed.Date>{formatDistanceToNow(activity.published)}</Feed.Date>
              </Feed.Summary>
            </Feed.Content>
          </Feed.Event>
        ))}
      </Feed>
    </Segment>
  );
}

const HUMAN_ACTIVITY_TYPE: Record<ActivityType, string> = {
  OrderPlaced: "placed",
  OrderPaid: "paid",
  OrderCancelled: "cancelled",
  FoodBeingPrepared: "starting preparing",
  FoodPrepared: "finished preparing",
  ItemsServed: "served"
};

export default ActivityFeedPage;
