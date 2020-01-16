export type Category = {
  name: string;
  position?: number;
  items?: MenuItem[];
};

export type MenuItem = {
  id: string;
  name: string;
  description?: string;
  price: number;
  isDrink: boolean;
  category: Category;
  imageUrl?: string;
};
