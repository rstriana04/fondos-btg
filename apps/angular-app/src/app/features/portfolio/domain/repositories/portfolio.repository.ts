import { Observable } from 'rxjs';
import { Result } from '../../../../core/errors/either';
import { Subscription } from '../entities/subscription.entity';

export abstract class PortfolioRepository {
  abstract getActiveSubscriptions(): Observable<Result<Subscription[]>>;
  abstract cancelSubscription(subscription: Subscription): Observable<Result<void>>;
}
