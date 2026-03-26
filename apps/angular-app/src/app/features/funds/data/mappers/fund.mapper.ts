import { Fund } from '../../domain/entities/fund.entity';
import { FundDto } from '../dtos/fund.dto';

export class FundMapper {
  static fromDto(dto: FundDto): Fund {
    return {
      id: dto.id,
      name: dto.name,
      minAmount: dto.minAmount,
      category: dto.category as 'FPV' | 'FIC',
    };
  }

  static fromDtoList(dtos: FundDto[]): Fund[] {
    return dtos.map(FundMapper.fromDto);
  }
}
