export interface FundDto {
  id: number;
  name: string;
  minAmount: number;
  category: string;
}

export interface UserDto {
  id: number;
  balance: number;
  subscribedFunds: number[];
}
