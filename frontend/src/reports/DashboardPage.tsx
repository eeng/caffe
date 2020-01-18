import React from "react";
import Page from "../shared/Page";
import { Statistic, Container, Segment } from "semantic-ui-react";
import { formatCurrency } from "/lib/format";
import QueryResultWrapper from "/shared/QueryResultWrapper";
import { gql, useQuery } from "@apollo/client";
import "./DashboardPage.less";

type Stats = {
  orderCount: number;
  amountEarned: number;
};

const STATS_QUERY = gql`
  query {
    stats {
      amountEarned
      orderCount
    }
  }
`;

function DashboardPage() {
  const result = useQuery<{ stats: Stats }>(STATS_QUERY);

  return (
    <Page title="Dashboard" className="DashboardPage">
      <QueryResultWrapper
        result={result}
        render={({ stats }) => (
          <Statistic.Group size="large">
            <Statistic label="Today's Orders" value={stats.orderCount} />
            <Statistic
              label="Amount Earned"
              value={formatCurrency(stats.amountEarned)}
            />
          </Statistic.Group>
        )}
      />
    </Page>
  );
}

export default DashboardPage;
