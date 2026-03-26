export interface User {
  readonly id: string;
  readonly name: string;
  readonly balance: number;
  readonly subscribedFunds: readonly SubscribedFund[];
}

export interface SubscribedFund {
  readonly fundId: string;
  readonly fundName: string;
  readonly amount: number;
  readonly date: string;
  readonly category: string;
}
