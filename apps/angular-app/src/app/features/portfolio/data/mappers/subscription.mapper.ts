import { Subscription } from '../../domain/entities/subscription.entity';
import { TransactionDto } from '../dtos/subscription.dto';
import { FundDto } from '../../../funds/data/dtos/fund.dto';

export class SubscriptionMapper {
  static fromTransactionDto(dto: TransactionDto, fund: FundDto): Subscription {
    return {
      id: dto.id,
      fundId: dto.fundId,
      fundName: fund.name,
      category: fund.category as 'FPV' | 'FIC',
      amount: dto.amount,
      date: dto.date,
      notification: dto.notification,
    };
  }
}
