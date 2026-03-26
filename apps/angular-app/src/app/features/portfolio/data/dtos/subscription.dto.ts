export interface TransactionDto {
  id: number;
  type: 'subscription' | 'cancellation';
  fundId: number;
  amount: number;
  notification: string;
  date: string;
}
