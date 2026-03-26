import { Injectable, inject, signal } from '@angular/core';
import { Subscription } from '../../domain/entities/subscription.entity';
import { GetActiveSubscriptionsUseCase } from '../../domain/usecases/get-active-subscriptions.usecase';
import { CancelSubscriptionUseCase } from '../../domain/usecases/cancel-subscription.usecase';
import { BalanceStore } from '../../../balance/presentation/state/balance.store';
import { Failure } from '../../../../core/errors/failures';

@Injectable({ providedIn: 'root' })
export class PortfolioStore {
  private readonly getSubscriptionsUseCase = inject(GetActiveSubscriptionsUseCase);
  private readonly cancelUseCase = inject(CancelSubscriptionUseCase);
  private readonly balanceStore = inject(BalanceStore);

  private readonly _subscriptions = signal<Subscription[]>([]);
  private readonly _loading = signal<boolean>(false);
  private readonly _error = signal<string | null>(null);
  private readonly _cancelling = signal<number | null>(null);

  readonly subscriptions = this._subscriptions.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly error = this._error.asReadonly();
  readonly cancelling = this._cancelling.asReadonly();

  loadSubscriptions(): void {
    this._loading.set(true);
    this._error.set(null);

    this.getSubscriptionsUseCase.execute().subscribe({
      next: (result) => {
        result.fold(
          (failure: Failure) => {
            this._error.set(failure.message);
            this._loading.set(false);
          },
          (subs: Subscription[]) => {
            this._subscriptions.set(subs);
            this._loading.set(false);
          }
        );
      },
      error: () => {
        this._error.set('Error inesperado al cargar portafolio');
        this._loading.set(false);
      },
    });
  }

  cancelSubscription(subscription: Subscription): void {
    this._cancelling.set(subscription.fundId);
    this._error.set(null);

    this.cancelUseCase.execute(subscription).subscribe({
      next: (result) => {
        result.fold(
          (failure: Failure) => {
            this._error.set(failure.message);
            this._cancelling.set(null);
          },
          () => {
            this._cancelling.set(null);
            this.balanceStore.refresh();
            this.loadSubscriptions();
          }
        );
      },
      error: () => {
        this._error.set('Error inesperado al cancelar suscripcion');
        this._cancelling.set(null);
      },
    });
  }
}
