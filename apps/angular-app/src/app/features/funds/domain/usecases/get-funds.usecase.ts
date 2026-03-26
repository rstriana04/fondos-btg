import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Fund } from '../entities/fund.entity';
import { FundRepository } from '../repositories/fund.repository';
import { FUND_REPOSITORY } from '../../../../core/di/tokens';

@Injectable({ providedIn: 'root' })
export class GetFundsUseCase {
  constructor(@Inject(FUND_REPOSITORY) private readonly repository: FundRepository) {}

  execute(): Observable<Result<Fund[]>> {
    return this.repository.getFunds();
  }
}
