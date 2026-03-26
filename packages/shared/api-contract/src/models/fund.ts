import { FundCategory } from '../enums/fund-category';

export interface Fund {
  readonly id: string;
  readonly name: string;
  readonly minAmount: number;
  readonly category: FundCategory;
}
