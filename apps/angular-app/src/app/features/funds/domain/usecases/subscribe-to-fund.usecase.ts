import { Injectable, Inject } from '@angular/core';
import { Observable, of } from 'rxjs';
import { Result, left } from '../../../../core/errors/either';
import { InsufficientBalanceFailure, AlreadySubscribedFailure, ValidationFailure } from '../../../../core/errors/failures';
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

    if (params.amount < params.fund.minAmount) {
      const min = params.fund.minAmount.toLocaleString('es-CO');
      return of(left(new ValidationFailure(`El monto minimo es $${min}`)));
    }

    if (params.currentBalance < params.amount) {
      return of(left(new InsufficientBalanceFailure(params.fund.name, params.fund.minAmount)));
    }

    return this.repository.subscribeTo(params.fund.id, params.amount, params.notification);
  }
}
