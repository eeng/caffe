import React from "react";
import Layout from "../shared/Layout";
import { useParams } from "react-router-dom";

function OrderDetailsPage() {
  const { id } = useParams();
  return <Layout header="Order Details">{id}</Layout>;
}

export default OrderDetailsPage;
