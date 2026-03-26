export interface Fund {
  id: number;
  name: string;
  minAmount: number;
  category: 'FPV' | 'FIC';
}
