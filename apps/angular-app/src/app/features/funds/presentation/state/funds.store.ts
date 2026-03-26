import { Injectable, inject, signal, computed } from '@angular/core';
import { Fund } from '../../domain/entities/fund.entity';
import { GetFundsUseCase } from '../../domain/usecases/get-funds.usecase';
import { SubscribeToFundUseCase, SubscribeParams } from '../../domain/usecases/subscribe-to-fund.usecase';
import { BalanceStore } from '../../../balance/presentation/state/balance.store';
import { Failure } from '../../../../core/errors/failures';

@Injectable({ providedIn: 'root' })
export class FundsStore {
  private readonly getFundsUseCase = inject(GetFundsUseCase);
  private readonly subscribeUseCase = inject(SubscribeToFundUseCase);
  private readonly balanceStore = inject(BalanceStore);

  private readonly _funds = signal<Fund[]>([]);
  private readonly _loading = signal<boolean>(false);
  private readonly _error = signal<string | null>(null);
  private readonly _subscribing = signal<boolean>(false);
  private readonly _subscribeError = signal<string | null>(null);
  private readonly _subscribeSuccess = signal<string | null>(null);

  readonly funds = this._funds.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly error = this._error.asReadonly();
  readonly subscribing = this._subscribing.asReadonly();
  readonly subscribeError = this._subscribeError.asReadonly();
  readonly subscribeSuccess = this._subscribeSuccess.asReadonly();

  readonly fpvFunds = computed(() => this._funds().filter((f) => f.category === 'FPV'));
  readonly ficFunds = computed(() => this._funds().filter((f) => f.category === 'FIC'));
  readonly totalFunds = computed(() => this._funds().length);

  loadFunds(): void {
    this._loading.set(true);
    this._error.set(null);

    this.getFundsUseCase.execute().subscribe({
      next: (result) => {
        result.fold(
          (failure: Failure) => {
            this._error.set(failure.message);
            this._loading.set(false);
          },
          (funds: Fund[]) => {
            this._funds.set(funds);
            this._loading.set(false);
          }
        );
      },
      error: () => {
        this._error.set('Error inesperado al cargar fondos');
        this._loading.set(false);
      },
    });
  }

  subscribeTo(fund: Fund, amount: number, notification: string): Promise<boolean> {
    return new Promise((resolve) => {
      this._subscribing.set(true);
      this._subscribeError.set(null);

      const params: SubscribeParams = {
        fund,
        amount,
        notification,
        currentBalance: this.balanceStore.balance(),
        subscribedFundIds: this.balanceStore.subscribedFunds(),
      };

      this.subscribeUseCase.execute(params).subscribe({
        next: (result) => {
          result.fold(
            (failure: Failure) => {
              this._subscribeError.set(failure.message);
              this._subscribing.set(false);
              resolve(false);
            },
            () => {
              this._subscribing.set(false);
              this._subscribeSuccess.set('Suscripcion realizada exitosamente');
              this.balanceStore.refresh();
              resolve(true);
            }
          );
        },
        error: () => {
          this._subscribeError.set('Error inesperado al suscribirse');
          this._subscribing.set(false);
          resolve(false);
        },
      });
    });
  }

  clearSubscribeError(): void {
    this._subscribeError.set(null);
  }

  clearSubscribeSuccess(): void {
    this._subscribeSuccess.set(null);
  }
}
