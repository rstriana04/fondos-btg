import { Injectable, Inject } from '@angular/core';
import { Observable, of } from 'rxjs';
import { Result, left } from '../../../../core/errors/either';
import { InsufficientBalanceFailure, AlreadySubscribedFailure } from '../../../../core/errors/failures';
import { Fund } from '../entities/fund.entity';
import { FundRepository } from '../repositories/fund.repository';
import { FUND_REPOSITORY } from '../../../../core/di/tokens';

export interface SubscribeParams {
  fund: Fund;
  amount: number;
  notification: string;
  currentBalance: number;
  subscribedFundIds: number[];
}

@Injectable({ providedIn: 'root' })
export class SubscribeToFundUseCase {
  constructor(@Inject(FUND_REPOSITORY) private readonly repository: FundRepository) {}

  execute(params: SubscribeParams): Observable<Result<void>> {
    if (params.subscribedFundIds.includes(params.fund.id)) {
      return of(left(new AlreadySubscribedFailure(params.fund.name)));
    }

    if (params.currentBalance < params.fund.minAmount) {
      return of(left(new InsufficientBalanceFailure(params.fund.name, params.fund.minAmount)));
    }

    return this.repository.subscribeTo(params.fund.id, params.amount, params.notification);
  }
}
