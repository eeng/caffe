function formatCurrency(number: number) {
  return new Intl.NumberFormat("en", {
    style: "currency",
    currency: "USD"
  }).format(number);
}

function formatDate(value: string | Date) {
  const date = typeof value == "string" ? new Date(value) : value;
  return date.toLocaleDateString();
}

function formatDateTime(value: string | Date) {
  const date = typeof value == "string" ? new Date(value) : value;
  return date.toLocaleString();
}

export { formatCurrency, formatDate, formatDateTime };
