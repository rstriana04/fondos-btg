import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Subscription } from '../entities/subscription.entity';
import { PortfolioRepository } from '../repositories/portfolio.repository';
import { PORTFOLIO_REPOSITORY } from '../../../../core/di/tokens';

@Injectable({ providedIn: 'root' })
export class CancelSubscriptionUseCase {
  constructor(@Inject(PORTFOLIO_REPOSITORY) private readonly repository: PortfolioRepository) {}

  execute(subscription: Subscription): Observable<Result<void>> {
    return this.repository.cancelSubscription(subscription);
  }
}
