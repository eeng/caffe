import { User } from "/accounts/model";

export type ActivityType =
  | "OrderPlaced"
  | "OrderPaid"
  | "OrderCancelled"
  | "FoodBeingPrepared"
  | "FoodPrepared"
  | "ItemsServed";

export interface Activity {
  id: string;
  type: ActivityType;
  published: string;
  actor?: User;
  objectId: string;
}
