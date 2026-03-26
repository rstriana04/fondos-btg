import { Transaction } from '../../domain/entities/transaction.entity';
import { TransactionDto } from '../dtos/transaction.dto';
import { FundDto } from '../../../funds/data/dtos/fund.dto';

export class TransactionMapper {
  static fromDto(dto: TransactionDto, fund: FundDto | undefined): Transaction {
    return {
      id: dto.id,
      type: dto.type,
      fundId: dto.fundId,
      fundName: fund?.name ?? 'Fondo desconocido',
      category: (fund?.category as 'FPV' | 'FIC') ?? 'FIC',
      amount: dto.amount,
      notification: dto.notification,
      date: dto.date,
    };
  }

  static fromDtoList(dtos: TransactionDto[], funds: FundDto[]): Transaction[] {
    const fundMap = new Map(funds.map((f) => [f.id, f]));
    return dtos.map((dto) => TransactionMapper.fromDto(dto, fundMap.get(dto.fundId)));
  }
}
