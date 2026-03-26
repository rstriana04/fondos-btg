import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Subscription } from '../entities/subscription.entity';
import { PortfolioRepository } from '../repositories/portfolio.repository';
import { PORTFOLIO_REPOSITORY } from '../../../../core/di/tokens';

@Injectable({ providedIn: 'root' })
export class GetActiveSubscriptionsUseCase {
  constructor(@Inject(PORTFOLIO_REPOSITORY) private readonly repository: PortfolioRepository) {}

  execute(): Observable<Result<Subscription[]>> {
    return this.repository.getActiveSubscriptions();
  }
}
