export interface Transaction {
  id: number;
  type: 'subscription' | 'cancellation';
  fundId: number;
  fundName: string;
  category: 'FPV' | 'FIC';
  amount: number;
  notification: string;
  date: string;
}
