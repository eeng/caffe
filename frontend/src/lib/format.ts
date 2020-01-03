function formatCurrency(number: number) {
  return new Intl.NumberFormat("en", {
    style: "currency",
    currency: "USD"
  }).format(number);
}

export { formatCurrency };
