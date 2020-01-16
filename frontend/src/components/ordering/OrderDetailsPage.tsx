import React from "react";
import Page from "../shared/Page";
import { useParams } from "react-router-dom";

function OrderDetailsPage() {
  const { id } = useParams();
  return <Page title="Order Details">{id}</Page>;
}

export default OrderDetailsPage;
