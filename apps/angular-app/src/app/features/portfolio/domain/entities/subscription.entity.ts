export interface Subscription {
  id: number;
  fundId: number;
  fundName: string;
  category: 'FPV' | 'FIC';
  amount: number;
  date: string;
  notification: string;
}
