import React from "react";
import { useLocation } from "react-router-dom";

function NotFoundPage() {
  let location = useLocation();

  return <div>Oops, nothing was found at path: {location.pathname}</div>;
}

export default NotFoundPage;
