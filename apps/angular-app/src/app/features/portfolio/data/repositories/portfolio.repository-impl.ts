import { Injectable, inject } from '@angular/core';
import { Observable, map, catchError, of, forkJoin, switchMap } from 'rxjs';
import { Result, right, left } from '../../../../core/errors/either';
import { ServerFailure } from '../../../../core/errors/failures';
import { Subscription } from '../../domain/entities/subscription.entity';
import { PortfolioRepository } from '../../domain/repositories/portfolio.repository';
import { PortfolioRemoteDatasource } from '../datasources/portfolio-remote.datasource';
import { SubscriptionMapper } from '../mappers/subscription.mapper';

@Injectable({ providedIn: 'root' })
export class PortfolioRepositoryImpl extends PortfolioRepository {
  private readonly datasource = inject(PortfolioRemoteDatasource);

  getActiveSubscriptions(): Observable<Result<Subscription[]>> {
    return forkJoin({
      transactions: this.datasource.getTransactions(),
      funds: this.datasource.getFunds(),
      user: this.datasource.getUser(),
    }).pipe(
      map(({ transactions, funds, user }) => {
        const subscribedFundIds = user.subscribedFunds || [];
        const fundMap = new Map(funds.map((f) => [f.id, f]));

        // Get the latest subscription transaction for each active fund
        const activeSubscriptions: Subscription[] = [];
        for (const fundId of subscribedFundIds) {
          const fund = fundMap.get(fundId);
          if (!fund) continue;

          // Find the most recent subscription transaction for this fund
          const subTx = transactions
            .filter((t) => t.type === 'subscription' && t.fundId === fundId)
            .sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())[0];

          if (subTx) {
            activeSubscriptions.push(SubscriptionMapper.fromTransactionDto(subTx, fund));
          }
        }

        return right<Subscription[]>(activeSubscriptions);
      }),
      catchError((error) => {
        return of(left<ServerFailure>(new ServerFailure(error.message)));
      })
    );
  }

  cancelSubscription(subscription: Subscription): Observable<Result<void>> {
    return this.datasource.getUser().pipe(
      switchMap((user) => {
        const newBalance = user.balance + subscription.amount;
        const newSubscribed = (user.subscribedFunds || []).filter(
          (id: number) => id !== subscription.fundId
        );
        return this.datasource
          .cancelSubscription(subscription.fundId, subscription.amount, subscription.notification)
          .pipe(
            switchMap(() => this.datasource.updateUser(newBalance, newSubscribed)),
            map(() => right<void>(undefined))
          );
      }),
      catchError((error) => {
        return of(left<ServerFailure>(new ServerFailure(error.message)));
      })
    );
  }
}
