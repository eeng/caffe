import { gql, useQuery } from "@apollo/client";
import { startOfDay, startOfMonth, startOfWeek, startOfYear } from "date-fns";
import React, { useState } from "react";
import { Dropdown, Segment, Statistic } from "semantic-ui-react";
import Page from "../shared/Page";
import "./DashboardPage.less";
import { formatCurrency } from "/lib/format";
import QueryResultWrapper from "/shared/QueryResultWrapper";

type Stats = {
  orderCount: number;
  amountEarned: number;
  tipEarned: number;
};

const STATS_QUERY = gql`
  query($since: String) {
    stats(since: $since) {
      orderCount
      amountEarned
      tipEarned
    }
  }
`;

const SINCE_FILTER_OPTS = {
  today: { text: "Today", fn: startOfDay },
  thisWeek: { text: "This Week", fn: startOfWeek },
  thisMonth: { text: "This Month", fn: startOfMonth },
  thisYear: { text: "This Year", fn: startOfYear }
};

type SinceValue = keyof typeof SINCE_FILTER_OPTS;

const convertSinceValueToDate = (value: SinceValue) =>
  SINCE_FILTER_OPTS[value].fn(new Date());

type Filters = {
  since: SinceValue;
};

function DashboardPage() {
  const [filters, setFilters] = useState<Filters>({
    since: "today"
  });

  const result = useQuery<{ stats: Stats }>(STATS_QUERY, {
    variables: { since: convertSinceValueToDate(filters.since) }
  });

  return (
    <Page title="Dashboard" className="DashboardPage">
      <span>
        Show stats from{" "}
        <SinceFilterDropdown
          value={filters.since}
          onChange={value => setFilters({ since: value })}
        />
      </span>

      <QueryResultWrapper
        result={result}
        render={({ stats }) => (
          <Statistic.Group size="large">
            <Statistic
              label="Orders Placed"
              value={stats.orderCount}
              as={Segment}
              padded="very"
            />
            <Statistic
              label="Amount Earned"
              value={formatCurrency(stats.amountEarned)}
              as={Segment}
              padded="very"
            />
            <Statistic
              label="Tips"
              value={formatCurrency(stats.tipEarned)}
              as={Segment}
              padded="very"
            />
          </Statistic.Group>
        )}
      />
    </Page>
  );
}

function SinceFilterDropdown({
  value,
  onChange
}: {
  value: SinceValue;
  onChange: (value: SinceValue) => void;
}) {
  const dropdownOpts = Object.entries(SINCE_FILTER_OPTS).map(([k, v]) => ({
    value: k,
    text: v.text
  }));

  return (
    <Dropdown
      inline
      options={dropdownOpts}
      value={value}
      onChange={(_, { value }) => onChange(value as SinceValue)}
    />
  );
}

export default DashboardPage;
