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

export { formatCurrency, formatDate };
