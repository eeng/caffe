import React from "react";
import Page from "../shared/Page";
import { Statistic } from "semantic-ui-react";
import { formatCurrency } from "/lib/format";

type Stats = {
  orderCount: number;
  amountEarned: number;
};

function DashboardPage() {
  return (
    <Page title="Dashboard">
      <Statistic.Group>
        <Statistic label="Today's Orders" value={"0"} />
        <Statistic label="Amount Earned" value={formatCurrency(0)} />
      </Statistic.Group>
    </Page>
  );
}

export default DashboardPage;
