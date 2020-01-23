import * as dateFns from "date-fns";

export function formatCurrency(number: number | string) {
  return new Intl.NumberFormat("en", {
    style: "currency",
    currency: "USD"
  }).format(typeof number == "string" ? parseFloat(number) : number);
}

export function formatDate(value: string | Date) {
  const date = typeof value == "string" ? new Date(value) : value;
  return date.toLocaleDateString();
}

export function formatDateTime(value: string | Date) {
  const date = typeof value == "string" ? new Date(value) : value;
  return date.toLocaleString();
}

export function formatDistanceToNow(value: string) {
  return dateFns.formatDistanceToNow(new Date(value), {
    addSuffix: true
  });
}
